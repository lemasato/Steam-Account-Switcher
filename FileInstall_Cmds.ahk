if (!A_IsCompiled && A_ScriptName = "FileInstall_Cmds.ahk") {
	#Include %A_ScriptDir%/lib/Logs.ahk
	#Include %A_ScriptDir%/lib/WindowsSettings.ahk
	#Include %A_ScriptDir%/lib/third-party/Get_ResourceSize.ahk

	if (!PROGRAM)
		PROGRAM := {}

	Loop, %0% {
		paramAE := %A_Index%
		if RegExMatch(paramAE, "O)/(.*)=(.*)", foundAE)
			PROGRAM[foundAE.1] := foundAE.2
	}

	FileInstall_Cmds()
}
; --------------------------------

FileInstall_Cmds() {
global PROGRAM


if !(PROGRAM.MAIN_FOLDER) {
	Msgbox You cannot run this file manually!
ExitApp
}

if !InStr(FileExist(PROGRAM.MAIN_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.MAIN_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("lib\third-party\curl.exe")
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\curl.exe"
}
else {
	FileGetSize, sourceFileSize, lib\third-party\curl.exe
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\curl.exe"
}
if (sourceFileSize != destFileSize)
	FileInstall, lib\third-party\curl.exe, % PROGRAM.MAIN_FOLDER "\curl.exe", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: lib\third-party\curl.exe"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\curl.exe"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: lib\third-party\curl.exe"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\curl.exe"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.MAIN_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.MAIN_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("GitHub.url")
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\GitHub.url"
}
else {
	FileGetSize, sourceFileSize, GitHub.url
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\GitHub.url"
}
if (sourceFileSize != destFileSize)
	FileInstall, GitHub.url, % PROGRAM.MAIN_FOLDER "\GitHub.url", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: GitHub.url"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\GitHub.url"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: GitHub.url"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\GitHub.url"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.MAIN_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.MAIN_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\changelog.txt")
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\changelog.txt"
}
else {
	FileGetSize, sourceFileSize, resources\changelog.txt
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\changelog.txt"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\changelog.txt, % PROGRAM.MAIN_FOLDER "\changelog.txt", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\changelog.txt"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\changelog.txt"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\changelog.txt"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\changelog.txt"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.MAIN_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.MAIN_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\icon.ico")
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\icon.ico"
}
else {
	FileGetSize, sourceFileSize, resources\icon.ico
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\icon.ico"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\icon.ico, % PROGRAM.MAIN_FOLDER "\icon.ico", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\icon.ico"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\icon.ico"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\icon.ico"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\icon.ico"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.FONTS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.FONTS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\fonts\Segoe UI.ttf")
	FileGetSize, destFileSize, % PROGRAM.FONTS_FOLDER "\Segoe UI.ttf"
}
else {
	FileGetSize, sourceFileSize, resources\fonts\Segoe UI.ttf
	FileGetSize, destFileSize, % PROGRAM.FONTS_FOLDER "\Segoe UI.ttf"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\fonts\Segoe UI.ttf, % PROGRAM.FONTS_FOLDER "\Segoe UI.ttf", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\fonts\Segoe UI.ttf"
	.	"`nDest: " PROGRAM.FONTS_FOLDER "\Segoe UI.ttf"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\fonts\Segoe UI.ttf"
	.	"`nDest: " PROGRAM.FONTS_FOLDER "\Segoe UI.ttf"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.ICONS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.ICONS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\icons\account.ico")
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\account.ico"
}
else {
	FileGetSize, sourceFileSize, resources\icons\account.ico
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\account.ico"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\icons\account.ico, % PROGRAM.ICONS_FOLDER "\account.ico", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\icons\account.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\account.ico"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\icons\account.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\account.ico"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.ICONS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.ICONS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\icons\gear.ico")
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\gear.ico"
}
else {
	FileGetSize, sourceFileSize, resources\icons\gear.ico
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\gear.ico"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\icons\gear.ico, % PROGRAM.ICONS_FOLDER "\gear.ico", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\icons\gear.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\gear.ico"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\icons\gear.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\gear.ico"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.ICONS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.ICONS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\icons\refresh.ico")
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\refresh.ico"
}
else {
	FileGetSize, sourceFileSize, resources\icons\refresh.ico
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\refresh.ico"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\icons\refresh.ico, % PROGRAM.ICONS_FOLDER "\refresh.ico", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\icons\refresh.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\refresh.ico"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\icons\refresh.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\refresh.ico"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.ICONS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.ICONS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\icons\x.ico")
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\x.ico"
}
else {
	FileGetSize, sourceFileSize, resources\icons\x.ico
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\x.ico"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\icons\x.ico, % PROGRAM.ICONS_FOLDER "\x.ico", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\icons\x.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\x.ico"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\icons\x.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\x.ico"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\Discord.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\Discord.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\Discord.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\Discord.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\Discord.png, % PROGRAM.IMAGES_FOLDER "\Discord.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\Discord.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\Discord.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\Discord.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\Discord.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\DonatePaypal.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\DonatePaypal.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\DonatePaypal.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\DonatePaypal.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\DonatePaypal.png, % PROGRAM.IMAGES_FOLDER "\DonatePaypal.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\DonatePaypal.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\DonatePaypal.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\DonatePaypal.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\DonatePaypal.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\GitHub.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\GitHub.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\GitHub.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\GitHub.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\GitHub.png, % PROGRAM.IMAGES_FOLDER "\GitHub.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\GitHub.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\GitHub.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\GitHub.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\GitHub.png"
	.	"`nFlag: " 2
}

; ----------------------------


if (errorLog)
	MsgBox, 4096, Steam Account Switcher,% "One or multiple files failed to be extracted. Please check the logs file for details."
	.	PROGRAM.LOGS_FILE 

}
