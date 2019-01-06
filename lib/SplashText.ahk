/*		Alternative to the SplashTextOn default command, with additional features

		Use the following hotkey to allow closing the SplashText with space:

		Hotkey, IfWinActive,% "ahk_pid " DllCall("GetCurrentProcessId")
		Hotkey, ~*Space, SpaceRoutine

		SpaceRoutine() {
			global SPACEBAR_WAIT

			if (SPACEBAR_WAIT)
				SplashTextOff()
		}
}
*/

SplashTextOn(title, msg, waitForClose=false, useSpaceToClose=false) {
	global SPACEBAR_WAIT

	if (useSpaceToClose) {
		SPACEBAR_WAIT := true
		msg .= "`n`nPress [ Space ] to close this window."
	}
	else {
		SPACEBAR_WAIT := false
	}

	Gui, Splash:Destroy
	Gui, Splash:+AlwaysOnTop -SysMenu +hwndhGUISplash
	Gui, Splash:Margin, 0, 0
	Gui, Splash:Font, S10 cBlack, Segoe UI

	Gui, Splash:Add, Text, Center hwndhMSG,% msg
	coords := Get_ControlCoords("Splash", hMSG)
	w := coords.W, h := coords.H
	GuiControl, Splash:Move,% hMSG,% "x5 w" coords.W " h" coords.H

	Gui, Splash:Show,% "w" coords.W+10 " h" coords.H+5,% title
	WinWait, ahk_id %hGUISplash%
	if (waitForClose)
		WinWaitClose, ahk_id %hGUISplash%
}

SplashTextOff() {
	global SPACEBAR_WAIT
	SPACEBAR_WAIT := false

	Gui, Splash:Destroy
}