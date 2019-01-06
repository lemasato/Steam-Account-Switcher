Get_Changelog(removeTrails=False) {
	global PROGRAM

	if (PROGRAM.IS_BETA = "True")
		FileRead, changelog,% PROGRAM.CHANGELOG_FILE_BETA
	else
		FileRead, changelog,% PROGRAM.CHANGELOG_FILE

	if (removeTrails=True) {
		changelog := StrReplace(changelog, A_Tab, "")
		AutoTrimStr(changelog)
	}

	len := StrLen(changelog)
	if ( len > 60000 ) {
		trim := len - 60000
		StringTrimRight, changelog, changelog, %trim%
		changelog .= "`n`n`n[ Changelog file trimmed. See full changelog file GitHub ]"
	}

	return changelog
}

Set_Clipboard(str) {
	global PROGRAM
	global SET_CLIPBOARD_CONTENT

	Clipboard := ""
	Sleep 10
	Clipboard := str
	ClipWait, 2, 1
	if (ErrorLevel) {
		TrayNotifications.Show(PROGRAM.NAME, "Unable to clipboard the following content: " str
			.	"`nThis may be due to an external clipboard manager creating conflict.")
		return 1
	}
	SET_CLIPBOARD_CONTENT := str
	Sleep 20
}

Reset_Clipboard() {
	global SET_CLIPBOARD_CONTENT
	if (Clipboard = SET_CLIPBOARD_CONTENT)
		Clipboard := ""
}
