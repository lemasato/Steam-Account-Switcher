TrayMenu() {
	global PROGRAM, DEBUG

	Menu,Tray,DeleteAll
	if ( !A_IsCompiled && FileExist(A_ScriptDir "\resources\icon.ico") )
		Menu, Tray, Icon, %A_ScriptDir%\resources\icon.ico
	Menu,Tray,Tip,Steam Account Switcher
	Menu,Tray,NoStandard
	if (DEBUG.settings.open_settings_gui) {
			Menu,Tray,Add,Recreate Settings GUI, Tray_CreateSettings
	}
	; Menu,Tray,Add,Settings, Tray_OpenSettings
	Menu,Tray,Add,Open,Tray_Open
	Menu,Tray,Add
	Menu,Tray,Add,Reload, Tray_Reload
	Menu,Tray,Add,Close, Tray_Exit
	Menu,Tray,Icon
	Menu,Tray,Default,Open ; Double click

	; Icons
	Menu, Tray, Icon,Open,% PROGRAM.ICONS_FOLDER "\gear.ico"
	Menu, Tray, Icon,Reload,% PROGRAM.ICONS_FOLDER "\refresh.ico"
	Menu, Tray, Icon,Close,% PROGRAM.ICONS_FOLDER "\x.ico"
}

Tray_Open(params) {
	global CANCEL_TRAY_MENU
	CANCEL_TRAY_MENU := True
	GUI_AccountSwitcher.Show()
}
Tray_OpenBetaTasks() {
	GUI_BetaTasks.Show()
}
Tray_GitHub() {
	global PROGRAM
	Run, % PROGRAM.LINK_GITHUB
}
Tray_Reload() {
	Reload()
}
Tray_Exit() {
	ExitApp
}
Tray_CreateSettings() {
	GUI_Settings.Create()
	GUI_Settings.Show()
}
Tray_OpenSettings() {
	GUI_Settings.Show()
}
