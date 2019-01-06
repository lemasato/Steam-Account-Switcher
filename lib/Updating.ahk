IsStableBetter(stable, beta) {
	isStableBetter := False
	
	stableSubVers := StrSplit(stable, "."), betaSubVers := StrSplit(beta, "."), currentSubVers := StrSplit(PROGRAM.VERSION, ".")
	if (betaSubVers.1 = stableSubVers.1 && betaSubVers.2 = stableSubVers.2) || (betaSubVers.1 = currentSubVers.1 && betaSubVers.2 = currentSubVers.2)
		isStableBetter := True

	return isStableBetter
}

IsUpdateAvailable() {
	global PROGRAM
	iniFile := PROGRAM.INI_FILE

	useBeta := INI.Get(iniFile, "UPDATING", "UseBeta")
	INI.Set(iniFile, "UPDATING", "LastUpdateCheck", A_Now)

	recentRels := GitHubAPI_GetRecentReleases(PROGRAM.GITHUB_USER, PROGRAM.GITHUB_REPO)
	if !(recentRels) {
		AppendToLogs(A_ThisFunc "(): Recent releases is empty!")
		return
	}
	latestRel := recentRels.1
	for index, value in recentRels {
		if (foundStableTag && foundBetaTag)
			Break

		isPreRelease := recentRels[index].prerelease
		if (isPreRelease && !foundBetaTag)
			latestBeta := recentRels[index], foundBetaTag := True
		else if (!isPreRelease && !foundStableTag)
			latestStable := recentRels[index], foundStableTag := True
	}
	stableTag := latestStable.tag_name, betaTag := latestBeta.tag_name
	if (useBeta && IsStableBetter(stableTag, betaTag))
		isStableBetter := True

	INI.Set(iniFile, "UPDATING", "LatestStable", stableTag)
	INI.Set(iniFile, "UPDATING", "LatestBeta", betaTag)
	Declare_LocalSettings()

	updateRel := (useBeta && isStableBetter)?(latestStable)
		: (useBeta && !isStableBetter)?(latestBeta)
		: (latestStable)

	relTag := updateRel.tag_name
	relNotes := updateRel.body
	Loop {
		assetName := updateRel.assets[A_Index].name
		SplitPath, assetName, assetFileName, , assetExt
		if (assetExt = "exe")
			exeDL := updateRel.assets[A_Index].browser_download_url
		else if (assetExt = "zip")
			zipDL := updateRel.assets[A_Index].browser_download_url
		else if (assetName = "") || (A_Index > 10)
			Break
	}
	relDL := A_IsCompiled?exeDL : zipDL

	if (relTag && relDL) && (relTag != PROGRAM.VERSION) {
		AppendToLogs(A_ThisFunc "(): Update check: Update found. Tag: " updateRel.tag_name ", Download: " relDL)
		Return {tag:updateRel.tag_name, notes:updateRel.body, download:relDL}
	}
	else if (relTag = PROGRAM.VERSION) {
		AppendToLogs(A_ThisFunc "(): Update check: No update available.")
		return False
	}
	else if (relTag && !relDL) {
		AppendToLogs(A_ThisFunc "(): Update check: Update found but missing asset download. Tag: " updateRel.tag_name ", Download (exe): " exeDL ", Download (zip): " zipDL)
		SplashTextOn(PROGRAM.NAME " - Updating Error", "An update has been detected but cannot be downloaded yet."
		.											"`nPlease try again in a few minutes."
		.											"`n"
		.											"`nIf this keeps on happening, please try updating manually."
		.											"`nYou can find the GitHub repository link in the Settings menu.", 1, 1)
		return "ERROR"
	}
	else {
		AppendToLogs(A_ThisFunc "(): Update check: Failed to retrieve releases from GitHub API.")
		SplashTextOn(PROGRAM.NAME " - Updating Error", "There was an issue when retrieving the latest release from GitHub API"
		.											"`nIf this keeps on happening, please try updating manually."
		.											"`nYou can find the GitHub repository link in the Settings menu.", 1, 1)
		return "ERROR"
	}
}

UpdateCheck(checkType="normal", notifOrBox="notif") {
	global PROGRAM, SPACEBAR_WAIT
	iniFile := PROGRAM.INI_FILE

	autoupdate := INI.Get(iniFile, "UPDATING", "DownloadUpdatesAutomatically")
	lastUpdateCheck := INI.Get(iniFile, "UPDATING", "LastUpdateCheck")
	if (checkType="forced") ; Fake the last update check, so it's higher than set limit
		lastUpdateCheck := 1994042612310000

	timeDif := A_Now
	timeDif -= lastUpdateCheck, Minutes

	if FileExist(PROGRAM.UPDATER_FILENAME)
		FileDelete,% PROGRAM.UPDATER_FILENAME

	if !(timeDif > 5) ; Hasn't been longer than 5mins since last check, cancel to avoid spamming GitHub API
		Return

	updateRel := IsUpdateAvailable()
	if !(updateRel) {
		TrayNotifications.Show(PROGRAM.NAME, "You are up to date!")
		return
	}
	if (updateRel = "ERROR") {
		TrayNotifications.Show(PROGRAM.NAME, "An error occured when checking for updates`nPlease try again later or update manually.")
		return
	}

	updTag := updateRel.tag, updDL := updateRel.download, updNotes := updateRel.notes
	global UPDATE_TAGNAME, UPDATE_DOWNLOAD, UPDATE_NOTES
	UPDATE_TAGNAME := updTag, UPDATE_DOWNLOAD := updDL, UPDATE_NOTES := updNotes

	if (checkType="on_start") && (autoupdate = "True") && (A_IsCompiled) {
		DownloadAndRunUpdater()
		return
	}

	if (notifOrBox="box")
		ShowUpdatePrompt(updTag, updDL)
	else if (notifOrBox="notif")
		TrayNotifications.Show(updTag " is available!", "Left click on this notification to run the automatic download.`nRight click to dismiss.", {Is_Update:1, Fade_Timer:20000})
}

ShowUpdatePrompt(ver, dl) {
	global PROGRAM

	MsgBox, 4100,% PROGRAM.NAME " - Update prompt",% ""
	. "Current:" A_Tab A_Tab PROGRAM.VERSION
	. "`nAvailable: " A_Tab ver
	. "`n"
	. "`nWould you like to update now?"
	. "`nThe entire updating process is automated."
	IfMsgBox, Yes
	{
		DownloadAndRunUpdater(dl)
	}
}

DownloadAndRunUpdater(dl="") {
	global PROGRAM, UPDATE_DOWNLOAD

	if InStr(FileExist(A_ScriptDir "\.git"), "D") {
		MsgBox(4096+48, "", "Updating canceled!"
		. "`n" ".git folder detected at script location."
		. "`n" "Updating has been canceled to avoid overwritting changes.")
		return
	}

	dl := dl?dl : UPDATE_DOWNLOAD
	if !(dl) {
		MsgBox(4096, "", "Dowload URL empty, canceling! ")
		return
	}

	if (!A_IsCompiled) {
		success := Download(dl, PROGRAM.MAIN_FOLDER "\Source.zip")
		if !(success) {
			MsgBox(4096+16, "", "Failed to download update!")
			return
		}

		updateFolder := PROGRAM.MAIN_FOLDER "\_UPDATE"
		FileRemoveDir,% updateFolder, 1
		Extract2Folder(PROGRAM.MAIN_FOLDER "\Source.zip", updateFolder)
		if FileExist(PROGRAM.MAIN_FOLDER "\_UPDATE\POE Trades Companion.ahk") {
			folder := updateFolder
		}
		else {
			Loop, Files,% updateFolder "\*", RD
			{
				if FileExist(A_LoopFileFullPath "\POE Trades Companion.ahk") {
					folder := A_LoopFileFullPath
					Break
				}
			}
		}

		if !(folder) {
			MsgBox(4096+16, "", "Couldn't locate the folder containing updated files.`nPlease try updating manually.")
			FileRemoveDir, updateFolder, 1
			return
		}

		FileCopyDir,% folder,% A_ScriptDir, 1
		if (ErrorLevel) {
			MsgBox(4096+16, "", "Failed to copy the new files into the folder.`nPlease try updating manually.")
			FileRemoveDir, updateFolder, 1
			return
		}

		FileRemoveDir, updateFolder, 1
		Reload()
	}
	else {
		success := Download(PROGRAM.LINK_UPDATER, PROGRAM.UPDATER_FILENAME)
		if !(success) {
			MsgBox(4096+16, "", "Failed to download the updater!")
			return
		}
		
		Run_Updater(dl)
	}
}

Run_Updater(downloadLink) {
	global PROGRAM
	iniFile := PROGRAM.INI_FILE

	INI.Set(iniFile, "UPDATING", "LastUpdate", A_Now)
	Run,% PROGRAM.UPDATER_FILENAME 
	. " /Name=""" PROGRAM.NAME  """"
	. " /File_Name=""" A_ScriptDir "\" PROGRAM.NAME ".exe" """"
	. " /Local_Folder=""" PROGRAM.MAIN_FOLDER """"
	. " /Ini_File=""" PROGRAM.INI_FILE """"
	. " /NewVersion_Link=""" downloadLink """"
	ExitApp
}
