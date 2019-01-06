/*	PushBullet functions by jNizM
	https://autohotkey.com/boards/viewtopic.php?t=4842
	https://docs.pushbullet.com
	
	HTTP Status Code	
    200 OK - Everything worked as expected.
    400 Bad Request - Usually this results from missing a required parameter.
    401 Unauthorized - No valid access token provided.
    403 Forbidden - The access token is not valid for that request.
    404 Not Found - The requested item doesn't exist.
    429 Too Many Requests - You have been ratelimited for making too many requests to the server.
    5XX Server Error - Something went wrong on Pushbullet's side. If this error is from an intermediate server, it may not be valid JSON.

	Error responses
	(any non-200 error code) contain information on the kind of error that happened. The response JSON will have an error property with the following fields:
    type - A machine-readable code to refer to this type of error. Either invalid_request for client side errors or server for server side errors.
    message - A (mostly) human-readable error message.
    param - (OPTIONAL) Appears sometimes during an invalid_request error to say which parameter in the request caused the error.
    cat - Some sort of ASCII cat to offset the pain of receiving an error message.
*/

PB_PushNote(PB_Token, PB_Title, PB_Message) {
/*	PB_Token   := "G8aldIDL93ldFADFwp9032ADF2klj3ld"
	PB_Title   := "Test Push (Note)"
	PB_Message := "Test Message Pushbullet meets AutoHotkey"
	MsgBox % PB_PushNote(PB_Token, PB_Title, PB_Message)
*/
	WinHTTP := ComObjCreate("WinHTTP.WinHttpRequest.5.1")
	WinHTTP.SetProxy(0)
	WinHTTP.Open("POST", "https://api.pushbullet.com/v2/pushes", 0)
	WinHTTP.SetCredentials(PB_Token, "", 0)
	WinHTTP.SetRequestHeader("Content-Type", "application/json")
	PB_Body := "{""type"": ""note"", ""title"": """ PB_Title """, ""body"": """ PB_Message """}"
	WinHTTP.Send(PB_Body)
	Result := WinHTTP.ResponseText
	Status := WinHTTP.Status
	return Status
}

PB_PushLink(PB_Token, PB_Title, PB_Message, PB_Link) {
/*	PB_Token   := "G8aldIDL93ldFADFwp9032ADF2klj3ld"
	PB_Title   := "Test Push (Link)"
	PB_Message := "Test Message Pushbullet meets AutoHotkey"
	PB_Link    := "http://ahkscript.org/"
	MsgBox % PB_PushLink(PB_Token, PB_Title, PB_Message, PB_Link)
*/
	WinHTTP := ComObjCreate("WinHTTP.WinHttpRequest.5.1")
	WinHTTP.SetProxy(0)
	WinHTTP.Open("POST", "https://api.pushbullet.com/v2/pushes", 0)
	WinHTTP.SetCredentials(PB_Token, "", 0)
	WinHTTP.SetRequestHeader("Content-Type", "application/json")
	PB_Body := "{""type"": ""link"", ""title"": """ PB_Title """, ""body"": """ PB_Message """, ""url"": """ PB_Link """}"
	WinHTTP.Send(PB_Body)
	Result := WinHTTP.ResponseText
	Status := WinHTTP.Status
	return Status
}

PB_PushChecklist(PB_Token, PB_Title, PB_Items) {
/*	PB_Token   := "G8aldIDL93ldFADFwp9032ADF2klj3ld"
	PB_Title   := "Test Push (Checklist)"
	PB_Items   := "[""Item One"", ""Item Two"", ""Item Three""]"
	MsgBox % PB_PushChecklist(PB_Token, PB_Title, PB_Items)
*/
	WinHTTP := ComObjCreate("WinHTTP.WinHttpRequest.5.1")
	WinHTTP.SetProxy(0)
	WinHTTP.Open("POST", "https://api.pushbullet.com/v2/pushes", 0)
	WinHTTP.SetCredentials(PB_Token, "", 0)
	WinHTTP.SetRequestHeader("Content-Type", "application/json")
	PB_Body := "{""type"": ""list"", ""title"": """ PB_Title """, ""items"": " PB_Items "}"
	WinHTTP.Send(PB_Body)
	Result := WinHTTP.ResponseText
	Status := WinHTTP.Status
	return Status
}
