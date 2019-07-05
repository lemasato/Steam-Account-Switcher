Get_CmdLineParameters() {
	global 0
	
	Loop, %0% {
		param := ""
		param := RegExReplace(%A_Index%, "=([^""\s]+)", "=""$1""") ; Add quotes to single words parameters. Otherwise "" should be used

		if (param)
			params .= A_Space . param
	}

	return params
}

Handle_CmdLineParameters() {
	global 0, PROGRAM, GAME, RUNTIME_PARAMETERS

	programName := PROGRAM.NAME
	params := Get_CmdLineParameters()

	if RegExMatch(params, "iO)/Account=([^\s]+)", found) {
		RUNTIME_PARAMETERS["Account"] := found.1, found := ""
	}
	; added the "path" parameter it musts be the last parameter
	if RegExMatch(params, "iO)/Path=(.*)", found){
		RUNTIME_PARAMETERS["Path"] := found.1, found := ""
	}
	if (InStr(params,"/StartSteamOffline") || InStr(params,"/Offline")) {
		RUNTIME_PARAMETERS["StartSteamOffline"] := True
	}
	if (InStr(params,"/NoAdmin") ||  InStr(params,"/SkipAdmin")) {
		RUNTIME_PARAMETERS["SkipAdmin"] := True
	}
	if (InStr(params,"/NoReplace") ||  InStr(params,"/NewInstance")) {
		RUNTIME_PARAMETERS["NewInstance"] := True
	}
	if (InStr(params,"/StartMinimized")) {
		RUNTIME_PARAMETERS["StartMinimized"] := True
	}
}