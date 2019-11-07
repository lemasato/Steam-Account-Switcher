Class Steam {

    Start(folder="", exe="", params="") {
        defaultExe := "Steam.exe"
        defaultFolder := Steam.GetInstallationFolder()
        exe := exe ? exe : defaultExe
        folder := folder ? folder : defaultFolder
        params := params ? params : ""

        if (folder != defaultFolder) && !FileExist(folder "/" exe) {
            userFolder := folder, folder := defaultFolder, exe := defaultExe
            MsgBox(4096, "", exe " does not exist in the specified folder!"
            . "`n" """" userFolder """"
            . "`n" "Detected installation folder will be used instead."
            . "`n" """" defaultFolder "/" defaultExe """")
        }

        runCmd := params ? folder "/" exe " " params : folder "/" exe, runDir := folder
        try
            Run,% runCmd,% runDir
        catch e
            MsgBox(4096, "", "Failed to run """ folder "/" exe """"
            . "`n`nExtra debug infos:"
            . "`nwhat: " e.what "`nfile: " e.file "`nline: " e.line
            . "`nmessage: " e.message "`nextra: " e.extra)
    }

    Exit(folder="", exe="") {
        defaultExe := "Steam.exe"
        defaultFolder := Steam.GetInstallationFolder()
        exe := exe ? exe : defaultExe
        folder := folder ? folder : defaultFolder

        if (folder != defaultFolder) && !FileExist(folder "/" exe) {
            userFolder := folder, folder := defaultFolder, exe := defaultExe
            MsgBox(4096, "", exe " does not exist in the specified folder!"
            . "`n" """" userFolder """"
            . "`n" "Detected installation folder will be used instead."
            . "`n" """" defaultFolder "/" defaultExe """")
        }

        runCmd := folder "/" exe " -shutdown", runDir := folder
        try
            Run,% runCmd,% runDir
        catch e
            MsgBox(4096, "", "Failed to run """ folder "/" exe """"
            . "`n`nExtra debug infos:"
            . "`nwhat: " e.what "`nfile: " e.file "`nline: " e.line
            . "`nmessage: " e.message "`nextra: " e.extra)
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
        fileLocation := Steam.GetInstallationFolder() "/config/loginusers.vdf"
        FileRead, fileContent, %fileLocation%
        
        accountsObj := {}, startPos := 1
        Loop {
            foundPos := RegExMatch(fileContent, "iO).*?""(\d+)"".*?{(.*?)\}", accSectionObj, startPos)
            if !(foundPos)
                Break

            thisAccObj := {SteamID:accSectionObj.1}
            Loop, Parse,% accSectionObj.2,% "`n",% "`r"
            {
                if RegExMatch(A_LoopField, "O).*""(.*?)"".*""(.*?)""", lineContentObj) {
                    thisAccObj[lineContentObj.1] := lineContentObj.2
                }
            }
            thisAccName := thisAccObj.AccountName
            accountsObj[thisAccName] := {}
            for key, value in thisAccObj
                accountsObj[thisAccName][key] := value

            startPos := foundPos + StrLen(accSectionObj.0)
        }

        return accountsObj
    }

    SetAccountSettings(_accName, _settings) {
        fileLocation := Steam.GetInstallationFolder() "/config/loginusers.vdf"
        FileRead, fileContent, %fileLocation%
        newfileContent := fileContent

        accList := Steam.GetAccountsList()
   
        startPos := 1
        Loop {
            foundPos := RegExMatch(fileContent, "iO)""\d+"".*?{(.*?)}", accSection, startPos)
            if !(foundPos)
                Break

            if RegexMatch(accSection.1, "iO).*""AccountName"".*""" _accName """") {
                    
                for setting, value in _settings {
                    hasSetting := accList[_accName][setting] != "" ? True : False
                    if (hasSetting)
                        newFileContent := RegExReplace(newFileContent, "i)""" setting """(.*?)""(.*?)""", """" setting """$1""" value """", rcount, 1, startPos)
                    else
                        newFileContent := RegExReplace(newFileContent, "i)""Timestamp""(.*?)""(\d+)""", """Timestamp""$1""$2""`n$1""" setting """$1""" value """", , 1, startPos)
                }
                foundAcc := True
            }

            startPos := foundPos + StrLen(accSection.0)   
        }

        if (foundAcc) {
            fileObj := FileOpen(fileLocation, "r")
            fileEnc := fileObj.Encoding
            fileObj.Close()
            fileObj := FileOpen(fileLocation, "w", fileEnc)
            fileObj.Write(newFileContent)
            fileObj.Close()
        }
    }
}
