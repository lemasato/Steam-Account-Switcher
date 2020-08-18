LocalSettings_VerifyEncoding() {
	global PROGRAM
	iniFile := PROGRAM.INI_FILE

	hINI := FileOpen(iniFile, "r")
	if (hINI.Encoding != "UTF-16") {
		AppendToLogs(A_ThisFunc "(): Wrong ini file encoding (" hINI.Encoding "). Making backup and creating new file with UTF-16 encoding.")
		data := hINI.Read()
		hINI.Close()   

		SplitPath, iniFile, , folder
		FileMove,% iniFile,% folder "\" A_Now "_Preferences.ini", 1

		hINI2 := FileOpen(iniFile, "w", "UTF-16")
		hINI2.Write(Data)
	}
}

Get_LocalSettings_DefaultValues() {
	global PROGRAM

	settings := {}

	settings.SECTIONS_ORDER := "GENERAL,UPDATING,SETTINGS_MAIN,SETTINGS_CUSTOMIZATION_SKINS,SETTINGS_CUSTOM_BUTTON_"
		. ",SETTINGS_SPECIAL_BUTTON_,SETTINGS_HOTKEY_,SETTINGS_HOTKEY_ADV_"

	settings.GENERAL 																	:= {}
	settings.GENERAL.IsFirstTimeRunning													:= "True"
	

	settings.SETTINGS_MAIN 																:= {}
	settings.SETTINGS_MAIN.SavedAccounts												:= ""
	settings.SETTINGS_MAIN.SteamFolder													:= ""
	settings.SETTINGS_MAIN.StartSteamOffline											:= "False"
	settings.SETTINGS_MAIN.MinimizeAfterLogin											:= "False"

	hw := A_DetectHiddenWindows
	DetectHiddenWindows, On
	WinGet, fileProcessName, ProcessName,% "ahk_pid " DllCall("GetCurrentProcessId")
	DetectHiddenWindows, %hw%
	settings.UPDATING 																	:= {}
	settings.UPDATING.PID 																:= DllCall("GetCurrentProcessId")
	settings.UPDATING.FileName 															:= A_ScriptName
	settings.UPDATING.FileProcessName 													:= fileProcessName
	settings.UPDATING.ScriptHwnd 														:= A_ScriptHwnd
	settings.UPDATING.Version 															:= PROGRAM.VERSION
	settings.UPDATING.UseBeta															:= "False"
	settings.UPDATING.CheckForUpdatePeriodically 										:= "OnStartOnly"
	settings.UPDATING.LastUpdateCheck 													:= "19940426000000"
	settings.UPDATING.DownloadUpdatesAutomatically 										:= "True"

	return settings
}

LocalSettings_IsValueValid(iniSect, iniKey, iniValue) {
	global PROGRAM

	isFirstTimeRunning := INI.Get(PROGRAM.INI_FILE, "GENERAL", "IsFirstTimeRunning")

	if (iniSect = "GENERAL") {
		if IsIn(iniKey, "IsFirstTimeRunning,AddShowGridActionToInviteButtons,HasAskedForImport,RemoveCopyItemInfosIfGridActionExists")
			isValueValid := IsIn(iniValue, "True,False") ? True : False	
	}

	else if (iniSect = "SETTINGS_MAIN") {
		isValueValid := IsIn(iniKey,"SavedAccounts,SteamFolder") ? True
		: IsIn(iniKey,"StartSteamOffline,MinimizeAfterLogin") ? ( IsIn(iniValue, "True,False") ? True : False )
		: False
	}

	else if (iniSect = "UPDATING") {
		if (iniKey = "CheckForUpdatePeriodically")
			isValueValid := IsIn(iniValue, "OnStartOnly,OnStartAndEveryFiveHours,OnStartAndEveryDay") ? True : False
		; if (iniKey = "CheckForUpdateCondition")
		; 	isValueValid := True
		; else if (iniKey = "FileName")
		; 	isValueValid := True
		else if (iniKey = "LastUpdateCheck") {
			FormatTime, timeF, %iniValue%, yyyyMMddhhmmss
			isValueValid := (iniValue > A_Now || timeF > A_Now || StrLen(iniValue) != 14)?False : True
		}
		; else if (iniKey = "PID")
		; 	isValueValid := True
		else if IsIn(iniKey, "UseBeta,DownloadUpdatesAutomatically")
			isValueValid := IsIn(iniValue,"True,False") ? True : False
		; else if (iniKey = "Version")
		; 	isValueValid := True
		else
			isValueValid := True
	}

	if (isValueValid = "") {
		MsgBox %A_ThisFunc%(): Couldn't find if statement for:`niniSect: %iniSect%`niniKey: %iniKey%`niniValue: %iniValue%
	}

	return isValueValid
}

Restore_LocalSettings(iniSect, iniKey="") {
	global PROGRAM
	iniFile := PROGRAM.INI_FILE

	defSettings := Get_LocalSettings_DefaultValues()

	if (iniKey = "") { ; Replace entire section
		for key, value in PROGRAM.SETTINGS[iniSect]
			INI.Remove(iniFile, iniSect, key)

		for key, value in defSettings[iniSect]
			INI.Set(iniFile, iniSect, key, value)
	}
	else {
		INI.Set(iniFile, iniSect, iniKey, defSettings[iniSect][iniKey])
	}
}

Set_LocalSettings() {
	global PROGRAM
	iniFile := PROGRAM.INI_FILE

	if !FileExist(iniFile)
		FileAppend,`n,% iniFile

	settingsDefaultValues := Get_LocalSettings_DefaultValues()
	sectsOrder := settingsDefaultValues.SECTIONS_ORDER
	localSettings := Get_LocalSettings()

	isFirstTimeRunning := localSettings.GENERAL.IsFirstTimeRunning
	if !LocalSettings_IsValueValid("GENERAL", "IsFirstTimeRunning", isFirstTimeRunning) {
		Restore_LocalSettings("GENERAL", "IsFirstTimeRunning")
		isFirstTimeRunning := INI.Get(iniFile, "GENERAL", "IsFirstTimeRunning")
	}

	Restore_LocalSettings("UPDATING", "ScriptHwnd")
	Restore_LocalSettings("UPDATING", "FileProcessName")
	Restore_LocalSettings("UPDATING", "FileName")
	Restore_LocalSettings("UPDATING", "PID")

	; Set the order to go through sections
	order := ""
	Loop, Parse, sectsOrder,% ","
	{
		loopedSect := A_LoopField
		for iniSect, nothing in settingsDefaultValues {
			if IsContaining(iniSect, loopedSect) && !IsIn(iniSect, order)
				order .= iniSect ","
		}
	}
	StringTrimRight, order, order, 1
	; Make sure each value is valid
	Loop, Parse, order,% ","
	{
		iniSect := A_LoopField
		for iniKey, defValue in settingsDefaultValues[iniSect] {
			iniValue := localSettings[iniSect][iniKey]
			isValueValid := LocalSettings_IsValueValid(iniSect, iniKey, iniValue)

			if (!isValueValid) {
				if (IsFirstTimeRunning != "True" && !IsIn(iniKey, "IsFirstTimeRunning,LastUpdateCheck"))
					warnMsg .= "Section: " iniSect "`nKey: " iniKey "`nValue: " iniValue "`nDefault value: " defValue "`n`n"
				Restore_LocalSettings(iniSect, iniKey)
			}
		}
	}
	; Show which values were restored to default
	if (warnMsg) {
		Gui, ErrorLog:New, +AlwaysOnTop +ToolWindow +hwndhGuiErrorLog
		Gui, ErrorLog:Add, Text, x10 y10,% "One or multiple ini entries were deemed invalid and were reset to their default value."
		Gui, ErrorLog:Add, Edit, xp y+5 w500 R25 ReadOnly,% warnMsg
		Gui, ErrorLog:Add, Link, xp y+5,% "If you need assistance, you can contact me on: "
		. "<a href=""" PROGRAM.LINK_GITHUB """>GitHub</a> - <a href=""" PROGRAM.LINK_REDDIT """>Reddit</a> - <a href=""" PROGRAM.LINK_GGG """>PoE Forums</a> - <a href=""" PROGRAM.LINK_DISCORD """>Discord</a>"
		Gui, ErrorLog:Show,xCenter yCenter,% PROGRAM.NAME " - Error log"
		WinWait, ahk_id %hGuiErrorLog%
		WinWaitClose, ahk_id %hGuiErrorLog%
	}
}

Get_LocalSettings() {
	global PROGRAM
	iniFile := PROGRAM.INI_FILE
	settingsObj := {}

	Loop, Parse,% INI.Get(iniFile), "`n"
	{
		settingsObj[A_LoopField] := {}

		arr := INI.Get(iniFile, A_LoopField,,1)
		for key, value in arr {
			settingsObj[A_LoopField][key] := value
		}
	}

	PROGRAM.OS := {}
	PROGRAM.OS.RESOLUTION_DPI := Get_DpiFactor()

	return settingsObj
}

Update_LocalSettings() {
	global PROGRAM
	iniFile := PROGRAM.INI_FILE

	priorVer := Ini.Get(iniFile, "UPDATING", "Version", "UNKNOWN")
	priorVerNum := (priorVer="UNKNOWN")?(PROGRAM.Version):(priorVer)
	subVersions := StrSplit(priorVerNum, ".")
	mainVer := subVersions[1], releaseVer := subVersions[2], patchVer := subVersions[3]

	localSettings := Get_LocalSettings()

	Restore_LocalSettings("UPDATING", "Version")
	
	if (localSettings.GENERAL.IsFirstTimeRunning = "True") {
		AppendToLogs(A_ThisFunc "(): IsFirstTimeRunning detected as True")
		
		if (PROGRAM.IS_BETA = "True")
			GUI_BetaTasks.Show()

		INI.Set(iniFile, "GENERAL", "IsFirstTimeRunning", "False")
	}
}

Declare_LocalSettings(settingsObj="") {
	global PROGRAM

	if (settingsObj = "")
		settingsObj := Get_LocalSettings()

	PROGRAM["SETTINGS"] := {}

	for iniSection, nothing in settingsObj {
		PROGRAM["SETTINGS"][iniSection] := {}
		for iniKey, iniValue in settingsObj[iniSection]
			PROGRAM["SETTINGS"][iniSection][iniKey] := iniValue
	}
}