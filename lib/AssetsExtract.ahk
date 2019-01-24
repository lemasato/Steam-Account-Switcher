AssetsExtract() {
	; _TO_BE_ADDED_
	global PROGRAM
	static 0 ; Bypass warning "local same as global" for var 0

	if (A_IsCompiled) {
		FileInstall_Cmds()
		Return
	}

;	File location
	installFile := A_ScriptDir "\FileInstall_Cmds.ahk"
	FileDelete,% installFile

;	Pass PROGRAM to file
	appendToFile .= ""
	.		"if (!A_IsCompiled && A_ScriptName = ""FileInstall_Cmds.ahk"") {"
	. "`n"	"	#Include %A_ScriptDir%/lib/Logs.ahk"
	. "`n"	"	#Include %A_ScriptDir%/lib/WindowsSettings.ahk"
	. "`n"	"	#Include %A_ScriptDir%/lib/third-party/Get_ResourceSize.ahk"
	. "`n"
	. "`n"	"	if (!PROGRAM)"
	. "`n"	"		PROGRAM := {}"
	. "`n"
	. "`n"	"	Loop, %0% {"
	. "`n"	"		paramAE := `%A_Index`%"
	. "`n"	"		if RegExMatch(paramAE, ""O)/(.*)=(.*)"", foundAE)"
	. "`n"	"			PROGRAM[foundAE.1] := foundAE.2"
	. "`n"	"	}"
	. "`n"
	. "`n"	"	FileInstall_Cmds()"
	. "`n"	"}"
	. "`n"	"; --------------------------------"
	. "`n"
	. "`n"


	appendToFile .= ""
	. 		"FileInstall_Cmds() {"
	. "`n"	"global PROGRAM"
	. "`n"
	. "`n"
	. "`n"	"if !(PROGRAM.MAIN_FOLDER) {"
	. "`n" 	"	Msgbox You cannot run this file manually!"
	. "`n"	"ExitApp"
	. "`n"	"}"
	. "`n"
	. "`n"

;	- - - - CURL
	filePath := "lib\third-party\curl.exe"
	appendToFile .= FileInstall("""" filePath """", "PROGRAM.MAIN_FOLDER """ "\" "curl.exe" """", 2)

;	- - - - LINK SHORTCUTS
	; filePath := "Wiki.url"
	; appendToFile .= FileInstall("""" filePath """", "PROGRAM.MAIN_FOLDER """ "\" "Wiki.url" """", 2)
	filePath := "GitHub.url"
	appendToFile .= FileInstall("""" filePath """", "PROGRAM.MAIN_FOLDER """ "\" "GitHub.url" """", 2)

;	- - - - RESOURCES
	allowedFiles := "changelog.txt,icon.ico,changelog_beta.txt"
	Loop, Files,% A_ScriptDir "\resources\*"
	{
		RegExMatch(A_LoopFileFullPath, "O)\\resources\\(.*)", path)
		filePath := "resources\" path.1

		if (IsIn(A_LoopFileName, allowedFiles))
			appendToFile .= FileInstall("""" filePath """", "PROGRAM.MAIN_FOLDER """ "\" A_LoopFileName """", 2)
	}

;	- - - - FONTS
	allowedExtensions := "ttf"
	; allowedFiles := "FontReg.exe,EnumFonts.vbs,Settings.ini"
	allowedFiles := "Settings.ini"
	Loop, Files,% A_ScriptDir "\resources\fonts\*"
	{
		RegExMatch(A_LoopFileFullPath, "O)\\resources\\fonts\\(.*)", path)
		filePath := "resources\fonts\" path.1

		if (IsIn(A_LoopFileName, allowedFiles) || IsIn(A_LoopFileExt, allowedExtensions))
			appendToFile .= FileInstall("""" filePath """", "PROGRAM.FONTS_FOLDER """ "\" path.1 """", 2)
	}
	
;	- - - - ICONS
	allowedExtensions := "ico"
	Loop, Files,% A_ScriptDir "\resources\icons\*"
	{
		RegExMatch(A_LoopFileFullPath, "O)\\resources\\icons\\(.*)", path)
		filePath := "resources\icons\" path.1

		if (IsIn(A_LoopFileExt, allowedExtensions))
			appendToFile .= FileInstall("""" filePath """", "PROGRAM.ICONS_FOLDER """ "\" path.1 """", 2)
	}

;	- - - - IMAGES
	allowedExtensions := "png"
	Loop, Files,% A_ScriptDir "\resources\imgs\*"
	{
		RegExMatch(A_LoopFileFullPath, "O)\\resources\\imgs\\(.*)", path)
		filePath := "resources\imgs\" path.1

		if (IsIn(A_LoopFileExt, allowedExtensions))
			appendToFile .= FileInstall("""" filePath """", "PROGRAM.IMAGES_FOLDER """ "\" path.1 """", 2)
	}

	; - - - - 
	appendToFile .= ""
	. "`n"	
	. "`n"	"if (errorLog)"
	. "`n"	"	MsgBox, 4096, POE Trades Companion,% ""One or multiple files failed to be extracted. Please check the logs file for details."""
	. "`n"	"	.	PROGRAM.LOGS_FILE "
	. "`n"
	. "`n"	"}"

;	ADD TO FILE
	FileAppend,% appendToFile "`n",% installFile
	Sleep 10

	; https://autohotkey.com/board/topic/6717-how-to-find-autohotkey-directory/
	cl := DllCall( "GetCommandLine", "str" )
	StringMid, path_AHk, cl, 2, InStr( cl, """", true, 2 )-2

	installFile_run_cmd := % """" path_AHk """" " /r " """" installFile """"
	.		" /MAIN_FOLDER=" 	"""" PROGRAM.MAIN_FOLDER """"
	.		" /LOGS_FOLDER=" 	"""" PROGRAM.LOGS_FOLDER """"
	.		" /FONTS_FOLDER=" 	"""" PROGRAM.FONTS_FOLDER """"
	.		" /IMAGES_FOLDER=" 	"""" PROGRAM.IMAGES_FOLDER """"
	.		" /ICONS_FOLDER=" 	"""" PROGRAM.ICONS_FOLDER """"
	.		" /LOGS_FILE="		"""" PROGRAM.LOGS_FILE """"

	RunWait,% installFile_run_cmd,% A_ScriptDir
}