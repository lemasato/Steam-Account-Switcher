/*
*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*
*					Steam Account Switcher																										                *
*					Easily switch between your saved steam accounts                                                                                             *
*                   No password required, clever use of Steam cookies                               															*
*																																								*
*					https://github.com/lemasato/Steam-Account-Switcher/																							*
*																																								*	
*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*
*/

; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

; #Warn LocalSameAsGlobal, StdOut
; #ErrorStdOut
#SingleInstance, Off
#KeyHistory 0
#Persistent
#NoEnv

OnExit("Exit")

DetectHiddenWindows, Off
FileEncoding, UTF-8 ; Cyrilic characters
SetWinDelay, 0
ListLines, Off

; Basic tray menu
if ( !A_IsCompiled && FileExist(A_ScriptDir "\resources\icon.ico") )
	Menu, Tray, Icon, %A_ScriptDir%\resources\icon.ico
Menu,Tray,Tip,Steam Account Switcher
Menu,Tray,NoStandard
Menu,Tray,Add,Tool is loading..., DoNothing
Menu,Tray,Disable,Tool is loading...
Menu,Tray,Add,GitHub,Tray_GitHub
Menu,Tray,Add
Menu,Tray,Add,Reload,Tray_Reload
Menu,Tray,Add,Close,Tray_Exit
Menu,Tray,Icon

Hotkey, IfWinActive,% "ahk_pid " DllCall("GetCurrentProcessId")
Hotkey, ~*Space, SpaceRoutine
Hotkey, ~*Escape, EscapeRoutine

; try {
	Start_Script()
; }
; catch e {
; 	MsgBox, 16,, % "Exception thrown!`n`nwhat: " e.what "`nfile: " e.file
;         . "`nline: " e.line "`nmessage: " e.message "`nextra: " e.extra
; }
Return

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
SpaceRoutine() {
	global PROGRAM, SPACEBAR_WAIT

	if (SPACEBAR_WAIT) {
		SplashTextOff()
	}
}

EscapeRoutine() {
    ExitApp
}

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Start_Script() {

	global DEBUG 							:= {} ; Debug values
	global PROGRAM 							:= {} ; Specific to the program's informations
	global RUNTIME_PARAMETERS 				:= {}

	global MyDocuments

	; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	Handle_CmdLineParameters() 		; RUNTIME_PARAMETERS

	MyDocuments 					:= (RUNTIME_PARAMETERS.MyDocuments)?(RUNTIME_PARAMETERS.MyDocuments):(A_MyDocuments)

	; Set global - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	PROGRAM.NAME					:= "Steam Account Switcher"
	PROGRAM.VERSION 				:= "0.1"
	PROGRAM.IS_BETA					:= IsContaining(PROGRAM.VERSION, "beta")?"True":"False"

	PROGRAM.GITHUB_USER 			:= "lemasato"
	PROGRAM.GITHUB_REPO 			:= "Steam-Account-Switcher"
	PROGRAM.GUTHUB_BRANCH			:= "master"

	PROGRAM.MAIN_FOLDER 			:= MyDocuments "\lemasato\" PROGRAM.NAME
	PROGRAM.LOGS_FOLDER 			:= PROGRAM.MAIN_FOLDER "\Logs"
	PROGRAM.FONTS_FOLDER 			:= PROGRAM.MAIN_FOLDER "\Fonts"
	PROGRAM.IMAGES_FOLDER			:= PROGRAM.MAIN_FOLDER "\Images"
	PROGRAM.ICONS_FOLDER			:= PROGRAM.MAIN_FOLDER "\Icons"

	prefsFileName 					:= (RUNTIME_PARAMETERS.InstanceName)?(RUNTIME_PARAMETERS.InstanceName "_Preferences.ini"):("Preferences.ini")
	backupFileName 					:= (RUNTIME_PARAMETERS.InstanceName)?(RUNTIME_PARAMETERS.InstanceName "_Trades_Backup.ini"):("Trades_Backup.ini")
	PROGRAM.FONTS_SETTINGS_FILE		:= PROGRAM.FONTS_FOLDER "\Settings.ini"
	PROGRAM.INI_FILE 				:= PROGRAM.MAIN_FOLDER "\" prefsFileName
	PROGRAM.LOGS_FILE 				:= PROGRAM.LOGS_FOLDER "\" A_YYYY "-" A_MM "-" A_DD " " A_Hour "h" A_Min "m" A_Sec "s.txt"
	PROGRAM.CHANGELOG_FILE 			:= PROGRAM.MAIN_FOLDER "\changelog.txt"
	PROGRAM.CHANGELOG_FILE_BETA 	:= PROGRAM.MAIN_FOLDER "\changelog_beta.txt"

	PROGRAM.NEW_FILENAME			:= PROGRAM.MAIN_FOLDER "\SAS-NewVersion.exe"
	PROGRAM.UPDATER_FILENAME 		:= PROGRAM.MAIN_FOLDER "\SAS-Updater.exe"
	PROGRAM.LINK_UPDATER 			:= "https://raw.githubusercontent.com/lemasato/Steam-Account-Switcher/master/Updater_v2.exe"
	PROGRAM.LINK_CHANGELOG 			:= "https://raw.githubusercontent.com/lemasato/Steam-Account-Switcher/master/resources/changelog.txt"

	PROGRAM.CURL_EXECUTABLE			:= PROGRAM.MAIN_FOLDER "\curl.exe"

	PROGRAM.LINK_REDDIT 			:= "https://www.reddit.com/user/lemasato/submitted/"
	PROGRAM.LINK_GGG 				:= "https://www.pathofexile.com/forum/view-thread/1755148/"
	PROGRAM.LINK_GITHUB 			:= "https://github.com/lemasato/Steam-Account-Switcher/"
	PROGRAM.LINK_SUPPORT 			:= "https://www.paypal.me/masato/"
	PROGRAM.LINK_DISCORD 			:= "https://discord.gg/UMxqtfC"

	PROGRAM.PID 					:= DllCall("GetCurrentProcessId")

	SetWorkingDir,% PROGRAM.MAIN_FOLDER

	if (!A_IsAdmin && !RUNTIME_PARAMETERS.SkipAdmin) {
		ReloadWithParams(" /MyDocuments=""" MyDocuments """", getCurrentParams:=True, asAdmin:=True)
	}

	; Create local directories - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	directories := PROGRAM.MAIN_FOLDER "`n" PROGRAM.LOGS_FOLDER "`n"
	. "`n" PROGRAM.FONTS_FOLDER "`n" PROGRAM.IMAGES_FOLDER "`n" PROGRAM.ICONS_FOLDER

	Loop, Parse, directories, `n, `r
	{
		if (!InStr(FileExist(A_LoopField), "D")) {
			AppendtoLogs("Local directory non-existent. Creating: """ A_LoopField """")
			FileCreateDir, % A_LoopField
			if (ErrorLevel && A_LastError) {
				AppendtoLogs("Failed to create local directory. System Error Code: " A_LastError ". Path: """ A_LoopField """")
			}
		}
	}

	; Logs files
	Create_LogsFile()
	Delete_OldLogsFile()

	Load_DebugJSON()

	if (!RUNTIME_PARAMETERS.NewInstance)
		Close_PreviousInstance()
	TrayRefresh()

	if !(DEBUG.settings.skip_assets_extracting)
		AssetsExtract()

	; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	GDIP_Startup()

	; Fonts related
	LoadFonts() 

	; Local settings
	LocalSettings_VerifyEncoding()
	Set_LocalSettings()
	Update_LocalSettings()
	localSettings := Get_LocalSettings()
	Declare_LocalSettings(localSettings)

	; Update checking
	if !(DEBUG.settings.skip_update_check) {
		periodicUpdChk := PROGRAM.SETTINGS.UPDATE.CheckForUpdatePeriodically
		updChkTimer := (periodicUpdChk="OnStartOnly")?(0)
			: (periodicUpdChk="OnStartAndEveryFiveHours")?(18000000)
			: (periodicUpdChk="OnStartAndEveryDay")?(86400000)
		
		if (updChkTimer)
			SetTimer, UpdateCheck, %updChkTimer%

		if (A_IsCompiled)
			UpdateCheck(checktype:="on_start")
		else
			UpdateCheck(checkType:="on_start", "box")
	}
	else if (DEBUG.settings.force_update_check) {
		UpdateCheck(checkType:="forced")
	}

	TrayMenu()

    GUI_AccountSwitcher.Show()

	ShellMessage_Enable()
}

DoNothing:
Return

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#Include %A_ScriptDir%\lib\
#Include AssetsExtract.ahk
#Include Class_GUI.ahk
#Include Class_GUI_AccountSwitcher.ahk
#Include Class_GUI_SimpleWarn.ahk
#Include Class_INI.ahk
#Include CmdLineParameters.ahk
#Include Debug.ahk
#Include EasyFuncs.ahk
#Include Exit.ahk
#Include FileInstall.ahk
#Include GitHubAPI.ahk
#Include Local_File.ahk
#Include Logs.ahk
#Include ManageFonts.ahk
#Include Misc.ahk
#Include Reload.ahk
#Include ShowToolTip.ahk
#Include SplashText.ahk
#Include Steam.ahk
#Include TrayMenu.ahk
#Include TrayNotifications.ahk
#Include TrayRefresh.ahk
#Include Updating.ahk
#Include WM_Messages.ahk
#Include WindowsSettings.ahk

#Include %A_ScriptDir%\lib\third-party\
#Include AddToolTip.ahk
#Include ChooseColor.ahk
#Include Class_ImageButton.ahk
#Include Clip.ahk
#Include cURL.ahk
#Include Download.ahk
#Include Extract2Folder.ahk
#Include FGP.ahk
#Include GDIP.ahk
#Include JSON.ahk
#Include LV_SetSelColors.ahk
#Include PushBullet.ahk
#Include SetEditCueBanner.ahk
#Include StdOutStream.ahk
#Include StringtoHex.ahk
#Include TilePicture.ahk

if (A_IsCompiled) {
	#Include %A_ScriptDir%/FileInstall_Cmds.ahk
	Return
}
