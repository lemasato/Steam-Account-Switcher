Gdip_Startup()
{
	global GDIP_TOKEN
	Ptr := A_PtrSize ? "UPtr" : "UInt"

	if (GDIP_TOKEN)
		return
	
	if !DllCall("GetModuleHandle", "str", "gdiplus", Ptr)
		DllCall("LoadLibrary", "str", "gdiplus")
	VarSetCapacity(si, A_PtrSize = 8 ? 24 : 16, 0), si := Chr(1)
	DllCall("gdiplus\GdiplusStartup", A_PtrSize ? "UPtr*" : "uint*", pToken, Ptr, &si, Ptr, 0)
	GDIP_TOKEN := pToken
	return pToken
}

Gdip_Shutdown(pToken="")
{	
	global GDIP_TOKEN
	pToken := !pToken?GDIP_TOKEN:pToken
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	DllCall("gdiplus\GdiplusShutdown", Ptr, pToken)
	if hModule := DllCall("GetModuleHandle", "str", "gdiplus", Ptr)
		DllCall("FreeLibrary", Ptr, hModule)

	GDIP_TOKEN := 
	return 0
}

Gdip_FontCreate(hFamily, Size, Style=0)
{
	; msgbox % hFamily "`n" Size "`n" Syle
   DllCall("gdiplus\GdipCreateFont", A_PtrSize ? "UPtr" : "UInt", hFamily, "float", Size, "int", Style, "int", 0, A_PtrSize ? "UPtr*" : "UInt*", hFont)
   return hFont
}

Gdip_DeleteFontFamily(hFamily)
{
   return DllCall("gdiplus\GdipDeleteFontFamily", A_PtrSize ? "UPtr" : "UInt", hFamily)
}