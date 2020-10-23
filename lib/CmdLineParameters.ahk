Get_CmdLineParameters() {
	global 0
	
	Loop, %0% {
		param := ""
		param := RegExReplace(%A_Index%, "(.*?)=(.*)", "$1=""$2""") ; Add quotes to parameters. In case any contain a space

		if (param)
			params .= A_Space . param
	}

	return params
}

Handle_CmdLineParameters() {
	global 0, PROGRAM, GAME, RUNTIME_PARAMETERS

	programName := PROGRAM.NAME

	Loop, %0% {
		param := %A_Index%
		
		if RegExMatch(param, "iO)/Account=(.*)", found) {
			RUNTIME_PARAMETERS["Account"] := found.1, found := ""
		}
		else if (param="/StartSteamOffline" || param="/Offline") {
			RUNTIME_PARAMETERS["StartSteamOffline"] := True
		}
		else if (param="/NoAdmin" || param="/SkipAdmin") {
			RUNTIME_PARAMETERS["SkipAdmin"] := True
		}
		else if (param="/NoReplace" || param="/NewInstance") {
			RUNTIME_PARAMETERS["NewInstance"] := True
		}
		else if (param="/StartMinimized") {
			RUNTIME_PARAMETERS["StartMinimized"] := True
		}
		else if RegExMatch(param, "iO)/SteamPath=(.*)", found) || RegExMatch(param, "iO)/SteamFolder=(.*)", found) {
			steamPath := found.1
			if ( SubStr(found.1, 0, 1) = """" ) 		; If it ends with \ (eg: /SteamPath="C:\Program Files (x86)\Steam\")
				steamPath := StrTrimRight(steamPath, 1) ; Then AHK will consider the " as escaped and part of the string, we need to remove it
			RUNTIME_PARAMETERS["SteamPath"] := steamPath, found := ""
		}
		else if RegExMatch(param, "iO)/SteamParams=(.*)", found) {
			steamParams := found.1
			RUNTIME_PARAMETERS["SteamParams"] := steamParams, found := ""
		}
		else if (param="/NoSteamShutdown") {
			RUNTIME_PARAMETERS["NoSteamShutdown"] := True
		}
	}
}