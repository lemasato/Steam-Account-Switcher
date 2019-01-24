#SingleInstance, Force
#NoEnv

; Basic tray menu
if ( !A_IsCompiled && FileExist(A_ScriptDir "\resources\icon.ico") )
	Menu, Tray, Icon, %A_ScriptDir%\resources\icon.ico
Menu,Tray,Tip,POE Trades Companion - Converting release
Menu,Tray,NoStandard
Menu,Tray,Add,Close,Tray_Close
Menu,Tray,Icon

; Main file
FileRead, ver,%A_ScriptDir%/resources/version.txt ; Get ver from txt
ver := StrReplace(ver, "`n", "") ; Remove any possible linebreak
ver = %ver% ; Auto trim
ver := RegExReplace(ver, "[a-zA-Z]") ; Remove any possible alpha char
ver := StrReplace(ver, "_", "99.") ; If _ detected (beta), use 99 as ver
StringReplace ver,ver,`.,`.,UseErrorLevel

project := "Steam Account Switcher"
ahkFile := project ".ahk"
exeFile := project ".exe"


ToolTip, Compiling %exeFile%
; CompileFile(A_ScriptDir "\" ahkFile, A_ScriptDir "\" exeFile)
CompileFile(A_ScriptDir "\" ahkFile, A_ScriptDir "\" exeFile, project, ver, "© lemasato.github.io " A_YYYY)

; Updater file 
; ToolTip, Compiling Updater.exe
; CompileFile(A_ScriptDir "\Updater.ahk", A_ScriptDir "\Updater.exe")
; CompileFile(A_ScriptDir "\Updater.ahk", A_ScriptDir "\Updater.exe", project ": Updater", "1.0", "© lemasato.github.io " A_YYYY)

; Updater file v2
; ToolTip, Updater_v2.exe
; CompileFile(A_ScriptDir "\Updater_v2.ahk", A_ScriptDir "\Updater_v2.exe")
CompileFile(A_ScriptDir "\Updater_v2.ahk", A_ScriptDir "\Updater_v2.exe", project ": Updater", "2.1", "© lemasato.github.io " A_YYYY)

; End
SoundPlay, *32
ToolTip, Compile Success
Sleep 1500
ToolTip
ExitApp
Return

; - - - - - - - - - -

Esc::ExitApp

Tray_Close:
ExitApp
Return

CompileFile(source, dest, fileDesc="NONE", fileVer="NONE", fileCopyright="NONE") {
    Run_Ahk2Exe(source, ,A_ScriptDir "\resources\icon.ico")

	if (fileDesc != "NONE" || fileVer != "NONE" || fileCopyright != "NONE") {
		StringReplace fileVer,fileVer,`.,`.,UseErrorLevel
		Loop % 3-ErrorLevel {
			fileVer .= ".0"
		}

		Set_FileInfos(dest, fileVer, fileDesc, fileCopyright)
		destVer := FGP_Value(dest, 166) ; 166 = Ver
		destDesc := FGP_Value(dest, 34) ; 34 = Desc
		destCpyR := FGP_Value(dest, 25) ; 25 = Copyright
		while (destVer != fileVer) {
			ToolTip,% "Attempt #" A_Index+1
			.   "`nFailed to set file infos."
			.   "`nFile: " dest
			.   "`n"
			.   "`nFile Version: " fileVer 
			.   "`nCurrent: " destVer
			.   "`n"
			.   "`nFile Description: " fileDesc 
			.   "`nCurrent: " destDesc
			.   "`n"
			.   "`nCopyright: " fileCopyright
			.   "`nCurrent: " destCpyR
			Set_FileInfos(dest, fileVer, fileDesc, fileCopyright)
			Sleep 500
			destVer := FGP_Value(dest, 166) ; 166 = Ver
		}
		ToolTip,
		fileInfos := ""
	}
}

#Include %A_ScriptDir%\lib\
#Include CompileAhk2Exe.ahk
#Include EasyFuncs.ahk
; #Include Logs.ahk
#Include SetFileInfos.ahk
; #Include PoeTrade.ahk
; #Include WindowsSettings.ahk

#Include %A_ScriptDir%\lib\third-party\
; #Include cURL.ahk
#Include FGP.ahk
; #Include IEComObj.ahk
; #Include JSON.ahk
; #Include StdOutStream.ahk