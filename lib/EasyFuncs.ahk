StrTrimRight(var, trimCount) {
	StringTrimRight, var, var, %trimCount%
	return var
}

SplitPath(fileOrPath) {
	SplitPath, fileOrPath, fileName, fileDir, fileExt, fileNameNoExt, fileDrive
	
    returnObj := {}
	if RegExMatch(fileName, "iO)(.*)\.(.*) (.*)|(.*)\.(.*)", match)
        fileName := match.1 "." match.2, fileNameNoExt := match.1, fileExt := match.2, fileParams := match.3
	else if (!fileExt) && (fileName)
		fileDir := fileDir "\" fileName, fileName := ""

    returnObj := {FileName: fileName, FileExt: fileExt, FileParams: fileParams, FileNameNoExt: fileNameNoExt
    ,Folder: fileDir, Drive: fileDrive}
	return returnObj
}

GetKeyStateFunc(which) {

	if (which = "All") {
		shiftState := (GetKeyState("Shift"))?("Down"):("Up")
		shiftStateL := (GetKeyState("LShift"))?("Down"):("Up")
		shiftStateR := (GetKeyState("RShift"))?("Down"):("Up")

		ctrlState := (GetKeyState("Ctrl"))?("Down"):("Up")
		ctrlStateL := (GetKeyState("LCtrl"))?("Down"):("Up")
		ctrlStateR := (GetKeyState("RCtrl"))?("Down"):("Up")

		altState := (GetKeyState("Alt"))?("Down"):("Up")
		altStateL := (GetKeyState("LAlt"))?("Down"):("Up")
		altStateR := (GetKeyState("RAlt"))?("Down"):("Up")

		WinStateL := (GetKeyState("LWin"))?("Down"):("Up")
		WinStateR := (GetKeyState("RWin"))?("Down"):("Up")

		obj := {Shift: shiftState, LShift: shiftStateL, RShift: shiftStateR
			, Ctrl: ctrlState, LCtrl: ctrlStateL, RCtrl: ctrlStateR
			, Alt: altState, LAlt: altStateL, RAlt: altStateR
			, LWin: WinStateL, RWin: WinStateR}

		return obj
	}
	else {
		obj := {}
		Loop, Parse, which,% ","
		{
			key := A_LoopField, _count := A_Index
			%key%State := (GetKeyState(key))?("Down"):("Up")
			obj[key] := %key%State
		}

		if (_count = 1) {
			return %key%State
		}
		else 
			return obj
	}
}

SetKeyStateFunc(which) {
	for key, state in which
		str .= "{" key " " state "}"

	if (str)
		Send %str%
}

GetWindowClientInfos(winName) {
/*	Source:
		noname: 		http://autohotkey.com/board/topic/77915-get-client-window/?p=495250
		arcaine.net: 	http://arcaine.net/l2/AtomixMacro/Unsupported/CP&CTRL.ahk
						http://arcaine.net/l2/AtomixMacro/AtomixMacro.ahk

    Edited to add support on AHK U64

	Allows to get a window client infos
*/
    WinGet, hwnd , ID, %winName%

    WinGetPos, , , , Window_Height, ahk_id %hwnd%
    VarSetCapacity(rcClient, 12+A_PtrSize, 0)          ; rcClient Structure 
    DllCall("user32\GetClientRect","uint", hwnd ,"uint",&rcClient)  
    rcClient_x   := NumGet(rcClient, 0, "int")
    rcClient_y   := NumGet(rcClient, 4, "int")
    rcClient_r   := NumGet(rcClient, 8, "int")
    rcClient_b   := NumGet(rcClient, 12, "int")

    VarSetCapacity(pwi, 64+A_PtrSize, 0)
    DllCall("GetWindowInfo", "UInt", hwnd, "UInt", &pwi)
    
    bx := NumGet(pwi, 48, "int") ; border width
    by := NumGet(pwi, 52, "int") ; border height
    RealX := bx
    RealY := Window_Height - by - rcClient_b
    RealWidth := rcClient_r
    RealHeight := rcClient_b

    return {X:RealX, Y:Realy, W:RealWidth, H:RealHeight}
}


RemoveTrailingZeroes(num) {
	num := RTrim(num, "0")
	if ( SubStr(num, 0) = "." ) {
		StringTrimRight, num, num, 1
	}
	return num
}

MultiplyBy(byWhat, ByRef num1, ByRef num2="", ByRef num3="", ByRef num4="", ByRef num5="", ByRef num6="", ByRef num7="", ByRef num8="", ByRef num9="", ByRef num10="") {
	num1 *= byWhat
	num2 *= byWhat
	num3 *= byWhat
	num4 *= byWhat
	num5 *= byWhat
	num6 *= byWhat
	num7 *= byWhat
	num8 *= byWhat
	num9 *= byWhat
	num10 *= byWhat
}

RandomStr(l = 24, i = 48, x = 122) { ; length, lowest and highest Asc value
	/*	Credits: POE-TradeMacro
		https://github.com/PoE-TradeMacro/POE-TradeMacro
	*/
	Loop, %l% {
		Random, r, i, x
		s .= Chr(r)
	}
	s := RegExReplace(s, "\W", "i") ; only alphanum.
	
	Return, s
}

Transform_ReadableHotkeyString_Into_AHKHotkeyString(_hotkey, _delimiter="+") {
	len := StrLen(_hotkey)
    Loop 2 {
        mainLoopIndex := A_Index
        Loop, Parse,% _hotkey,% _delimiter
        {
            parseIndex := A_Index

            if (mainLoopIndex = 1) 
                parseTotal := parseIndex
            else {
                firstChar := SubStr(A_LoopField, 1, 1)
                if IsIn(A_LoopField, "Ctrl,LCtrl,RCtrl") && (parseIndex < parseTotal)
                    mod .= firstChar = "L" ? "<^" : firstChar = "R" ? ">^" : "^"
                else if IsIn(A_LoopField, "Shift,LShift,RShift") && (parseIndex < parseTotal)
                    mod .= firstChar = "L" ? "<+" : firstChar = "R" ? ">+" : "+"
                else if IsIn(A_LoopField, "Alt,LAlt,RAlt") && (parseIndex < parseTotal)
                    mod .= firstChar = "L" ? "<!" : firstChar = "R" ? ">!" : "!"
                else if IsIn(A_LoopField, "LWin,RWin") && (parseIndex < parseTotal)
                    mod .= "#" ; firstChar = "L" ? "<#" : firstChar = "R" ? ">#" : "#"
                else
                    hk := A_LoopField
            }
        }
    }

    lastChar := SubStr(_hotkey, 0, 1)
    if (lastChar = _delimiter) && (hk = "")
        hk := lastChar

    fullHk := mod . hk
    return fullHk
}

Transform_AHKHotkeyString_Into_InputSring(_hotkey) {
	readable := Transform_AHKHotkeyString_Into_ReadableHotkeyString(_hotkey)
	len := StrLen(_hotkey), inputsObj := {}
    Loop 2 {
        mainLoopIndex := A_Index
        Loop, Parse,% readable,% "+"
        {
            parseIndex := A_Index

            if (mainLoopIndex = 1) 
                parseTotal := parseIndex
            else {
                firstChar := SubStr(A_LoopField, 1, 1)
                if IsIn(A_LoopField, "Ctrl,LCtrl,RCtrl") && (parseIndex < parseTotal)
                    inputsObj.Push(A_LoopField)
                else if IsIn(A_LoopField, "Shift,LShift,RShift") && (parseIndex < parseTotal)
                    inputsObj.Push(A_LoopField)
                else if IsIn(A_LoopField, "Alt,LAlt,RAlt") && (parseIndex < parseTotal)
                    inputsObj.Push(A_LoopField)
                else if IsIn(A_LoopField, "LWin,RWin") && (parseIndex < parseTotal)
                    inputsObj.Push(A_LoopField)
                else
                    inputsObj.Push(A_LoopField)
            }
        }
    }

	for index, _input in inputsObj {
        downInputs .= "{" _input " Down}"
        upInputs := "{" _input " Up}" upInputs
    }

	downAndUpInputs := downInputs . upInputs
    return downAndUpInputs
}

Transform_AHKHotkeyString_Into_ReadableHotkeyString(_hotkey, _delimiter="+") {
	len := StrLen(_hotkey)

	Loop, Parse,% _hotkey
    {
        parseIndex := A_Index
        curChar := A_LoopField, nextChar := SubStr(_hotkey, parseIndex+1, 1), curAndNextChars := curChar . nextChar

        if (skipNextChar) {
            skipNextChar := False
        }
        else if IsIn(curAndNextChars, "<^,>^,<!,>!,<+,>+,<#,>#") {
            mod := curChar = "<" ? "L" : curChar = ">" ? "R" : ""
            mod .= nextChar = "^" ? "Ctrl" : nextChar = "!" ? "Alt" : nextChar = "+" ? "Shift" : nextChar = "#" ? "Win" : ""
            modStr .= modStr ? "+" mod : mod
            skipNextChar := True
        }
        else if IsIn(curChar, "^,!,+,#") && (parseIndex < len) {
            mod := curChar = "^" ? "Ctrl" : curChar = "!" ? "Alt" : curChar = "+" ? "Shift" : curChar = "#" ? "Win" : ""
            modStr .= modStr ? "+" mod : mod
        }
        else {
            hk := SubStr(_hotkey, parseIndex)
            StringUpper, hk, hk, T
            Break
        }
    }

    hkStr := modStr ? modStr "+" hk : hk
    return hkStr
}

Get_UnderMouse_CtrlHwnd() {
	MouseGetPos, , , , ctrlHwnd, 2
	return ctrlHwnd
}

AutoTrimStr(ByRef string1, ByRef string2="", ByRef string3="", ByRef string4="", ByRef string5="", ByRef string6="", ByRef string7="", ByRef string8="", ByRef string9="", ByRef string10="") {
	_autotrim := A_AutoTrim
	AutoTrim, On

	string1 = %string1%
	string2 = %string2%
	string3 = %string3%
	string4 = %string4%
	string5 = %string5%
	string6 = %string6%
	string7 = %string7%
	string8 = %string8%
	string9 = %string9%
	string10 = %string10%

	AutoTrim, %_autotrim%
}

Set_Format(_NumberType="", _Format="") {
	static prevNumberType, prevFormat
	prevNumberType := _NumberType
	prevFormat := A_FormatFloat

	if (_NumberType = "") && (_Format = "")
		SetFormat, %prevNumberType%, %prevFormat%
	else if (_NumberType) && (_Format = "")
		SetFormat, %_NumberType%, %prevFormat%
	else
		SetFormat, %_NumberType%, %_Format%
}

Set_TitleMatchMode(_MatchMode="") {
	static prevMode
	prevMode := A_TitleMatchMode

	if !(_MatchMode)
		SetTitleMatchMode, %prevMode%
	else
		SetTitleMatchMode, %_MatchMode%
}

MsgBox(_opts="", _title="", _text="", _timeout="") {
	global PROGRAM

	if (_title = "")
		_title := PROGRAM.NAME

	MsgBox,% _opts,% _title,% _text,% _timeout
}

Detect_HiddenWindows(state="") {
	static previousState
	if (state = "" && previousState) {
		DetectHiddenWindows, %previousState%
		Return
	}

	previousState := A_DetectHiddenWindows


	state := (state=True || state="On")?("On"):(state=False || state="Off")?("Off"):("ERROR")
	if (state = "ERROR")
		MsgBox(,, "Invalid use of " A_ThisFunc)
	DetectHiddenWindows, %state%
}

Get_Windows_Title(_filter="", _filterType="", _delimiter="`n") {
	returnList := Get_Windows_List(_filter, _filterType, _delimiter, "Title")
	return returnList
}

Get_Windows_PID(_filter="", _filterType="", _delimiter=",") {
	returnList := Get_Windows_List(_filter, _filterType, _delimiter, "PID")
	return returnList
}

Get_Windows_ID(_filter="", _filterType="", _delimiter=",") {
	returnList := Get_Windows_List(_filter, _filterType, _delimiter, "ID")
	return returnList
}

Get_Windows_Exe(_filter="", _filterType="", _delimiter=",") {
	returnList := Get_Windows_List(_filter, _filterType, _delimiter, "Exe")
	return returnList
}

Get_Windows_List(_filter, _filterType, _delimiter, _what) {

	_whatAllowed := "ID,PID,ProcessID,Exe,ProcessName,Title"
	if !IsIn(_what, _whatAllowed) {
		Msgbox %A_ThisFunc%(): "%_what%" is not allowed`nAllowed: %_whatAllowed%
		return
	}
	_filterTypeAllowed := "ahk_exe,ahk_id,ahk_pid,Title"
	if !IsIn(_filterType, _filterTypeAllowed) {
		Msgbox %A_ThisFunc%(): "%_filterType%" is not allowed`nAllowed: %_filterTypeAllowed%
		return
	}

	; Assign Cmd
	Cmd := (IsIn(_what, "PID,ProcessID"))?("PID")
			:(IsIn(_what, "Exe,ProcessName"))?("ProcessName")
			:(_what)

	; Assign filter
	filter := (IsIn(_filterType, "ahk_exe,ahk_id,ahk_pid"))?(_filterType " " _filter):(_filter)

	; Assign return
	valuesList := ""
	if IsIn(_delimiter, "Array,[]")
		returnList := []
	else
		returnList := ""

	; Loop through pseudo array
	WinGet, winHwnds, List
	Loop, %winHwnds% {
		loopField := winHwnds%A_Index%
		if (_what = "Title")
			WinGetTitle, value, %filter% ahk_id %loopField%
		else 
			WinGet, value, %Cmd%, %filter% ahk_id %loopField%

		if (value) && !IsIn(value, valuesList) {
			valuesList := (valuesList)?(valuesList "," value):(value)

			if IsIn(_delimiter, "Array,[]")
				returnList.Push(value)
			else
				returnList := (returnList)?(returnList . _delimiter . value):(value)
		}
	}

	Return returnList
}

IsIn(_string, _list) {
	if _string in %_list%
		return True
}

IsContaining(_string, _keyword) {
	if _string contains %_keyword%
		return True
}

CoordMode(obj="") {
/*	Param1
 *	ToolTip: Affects ToolTip.
 *	Pixel: Affects PixelGetColor, PixelSearch, and ImageSearch.
 *	Mouse: Affects MouseGetPos, Click, and MouseMove/Click/Drag.
 *	Caret: Affects the built-in variables A_CaretX and A_CaretY.
 *	Menu: Affects the Menu Show command when coordinates are specified for it.

 *	Param2
 *	If Param2 is omitted, it defaults to Screen.
 *	Screen: Coordinates are relative to the desktop (entire screen).
 *	Relative: Coordinates are relative to the active window.
 *	Window [v1.1.05+]: Synonymous with Relative and recommended for clarity.
 *	Client [v1.1.05+]: Coordinates are relative to the active window's client area, which excludes the window's title bar, menu (if it has a standard one) and borders. Client coordinates are less dependent on OS version and theme.
*/
	if !(obj) { ; No param specified. Return current settings
		CoordMode_Settings := {}

		CoordMode_Settings.ToolTip 	:= A_CoordModeToolTip
		CoordMode_Settings.Pixel 	:= A_CoordModePixel
		CoordMode_Settings.Mouse 	:= A_CoordModeMouse
		CoordMode_Settings.Caret 	:= A_CoordModeCaret
		CoordMode_Settings.Menu 	:= A_CoordModeMenu

		return CoordMode_Settings
	}

	for param1, param2 in obj { ; Apply specified settings.
		if param1 not in ToolTip,Pixel,Mouse,Caret,Menu
			MsgBox, Wrong Param1 for CoordMode: %param1%
		else if param2 not in Screen,Relative,Window,Client
			Msgbox, Wrong Param2 for CoordMode: %param2%
		else
			CoordMode,%param1%,%param2%
	}
}

IsBetween(value, first, last) {
   if value between %first% and %last%
      return true
   else
      return false
}

Convert_TrueFalse_String_To_Value(ByRef value) {
	value := (value="True")?(True):(value="False")?(False):(value)
}

Get_MatchingValue_From_Object_Using_Index(obj, specifiedIndex) {
	matchingValue := ""
	for index, value in obj {
		if (index = specifiedIndex) {
			matchingValue := value
			Break
		}
	}
	return matchingValue
}

Get_MatchingIndex_From_Object_Using_Value(obj, specifiedValue) {
	matchingIndex := ""
	for index, value in obj {
		if (value = specifiedValue) {
			matchingIndex := index
			Break
		}
	}
	return matchingIndex
}

IsDigit(str) {
	if str is digit
		return true
	return false
}

IsHex(str) {
	if str is xdigit
		return true
	return false
}

IsSpace(str) {
	if str is Space
		return true
	return false
}

IsInteger(str) {
	str2 := Round(str)
	str := (str=str2)?(str2):(str) ; Fix trailing zeroes
	
	if str is integer
		return true
	return false
}

IsNum(str) {
	if str is number
		return true
	return false
}

Get_ControlCoords(guiName, ctrlHandler) {
/*		Retrieve a control's position and return them in an array.
		The reason of this function is because the variable content would be blank
			unless its sub-variables (coordsX, coordsY, ...) were set to global.
			(Weird AHK bug)
*/
	GuiControlGet, coords, %guiName%:Pos,% ctrlHandler
	return {X:coordsX,Y:coordsY,W:coordsW,H:coordsH}
}

StringIn(string, _list) {
	if string in %_list%
		return true
}

StringContains(string, match) {
	if string contains %match%
		return true
}

Get_TextCtrlSize(txt, fontName, fontSize, maxWidth="", params="") {
/*		Create a control with the specified text to retrieve
 *		the space (width/height) it would normally take
*/
	Gui, GetTextSize:Destroy
	Gui, GetTextSize:Font, S%fontSize%,% fontName
	if (maxWidth) 
		Gui, GetTextSize:Add, Text,x0 y0 +Wrap w%maxWidth% hwndTxtHandler,% txt
	else 
		Gui, GetTextSize:Add, Text,x0 y0 %params% hwndTxtHandler,% txt
	coords := Get_ControlCoords("GetTextSize", TxtHandler)
	Gui, GetTextSize:Destroy

	return coords

/*	Alternative version, with auto sizing

	Gui, GetTextSize:Font, S%fontSize%,% fontName
	Gui, GetTextsize:Add, Text,x0 y0 hwndTxtHandlerAutoSize,% txt
	coordsAuto := Get_ControlCoords("GetTextSize", TxtHandlerAutoSize)
	if (maxWidth) {
		Gui, GetTextSize:Add, Text,x0 y0 +Wrap w%maxWidth% hwndTxtHandlerFixedSize,% txt
		coordsFixed := Get_ControlCoords("GetTextSize", TxtHandlerFixedSize)
	}
	Gui, GetTextSize:Destroy

	if (maxWidth > coords.Auto)
		coords := coordsAuto
	else
		coords := coordsFixed

	return coords
*/
}

FileDownload(url, dest) {
	UrlDownloadToFile,% url,% dest
	if (ErrorLevel) {
		MsgBox Failed to download file!`nURL: %url%`nDest: %dest%
		return 0
	}
	return 1
}
