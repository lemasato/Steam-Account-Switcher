Get_DpiFactor() {
/*		Credits to ANT-ilic
* 		autohotkey.com/board/topic/6893-guis-displaying-differently-on-other-machines/?p=77893
*
*		Retrieves the current screen-dpi value.
*/
	RegRead, regValue, HKEY_CURRENT_USER, Control Panel\Desktop\WindowMetrics, AppliedDPI 
	dpiFactor := (ErrorLevel || regValue=96)?(1):(regValue/96)
	return dpiFactor
}