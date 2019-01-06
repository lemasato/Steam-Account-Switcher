Class Steam {

    Start() {
        folder := Steam.GetInstallationFolder()
        Run, %folder%/Steam.exe
    }

    Exit() {
        folder := Steam.GetInstallationFolder()
        Run, %folder%/Steam.exe -shutdown
    }

    SetAutoLoginUser(userName) {
		RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Valve\Steam\,AutoLoginUser,% username
        if (ErrorLevel)
            MsgBox(4096, "", "Unable to set autologin user!")
    }

    GetInstallationFolder() {
        RegRead, folder, HKEY_CURRENT_USER\Software\Valve\Steam\,steamPath

        if FileExist(folder "\Steam.exe")
            return folder
        else MsgBox(4096, "", "Unable to retrieve steam installation folder!")
    }

    GetAccountsList() {
        fileFolder := Steam.GetInstallationFolder() "/config/loginusers.vdf"
        FileRead, fileContent, %fileFolder%
        
        arr := {}
        Loop, Parse, fileContent,% "`n",% "`r"
        {
            if (A_Index > 1) {
                lineContent := A_LoopField

                AutoTrimStr(lineContent)
                if (lineContent = "{") {
                    if RegExMatch(prevLineContent, "O)^""(\d+)""$", steamIDObj)
                        thisSteamID := steamIDObj.1, arr[thisSteamID] := {}
                }
                if RegExMatch(lineContent, "O)""(.*?)"".*""(.*?)""", lineContentObj)
                    arr[thisSteamID][lineContentObj.1] := lineContentObj.2

                prevLineContent := lineContent
            }
        }

        accounts := {}
        for key, value in arr {
            steamID := key, accName := arr[steamID]["AccountName"]
            for subKey, subValue in arr[key] {
                accounts[accName] := {}, accounts[accName][subKey] := subValue
            }
            accounts[accName]["SteamID"] := steamID
        }

        return accounts
    }
}