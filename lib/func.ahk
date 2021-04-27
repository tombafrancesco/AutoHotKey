#SingleInstance Force
#include C:\Users\tomba\OneDrive\Desktop\AutoHotKey\lib\Acc.ahk
#include C:\Users\tomba\OneDrive\Desktop\AutoHotKey\lib\Anchor.ahk


GetElementByName(AccObj, name) {									;function for URL retrieval in chrome
   if (AccObj.accName(0) = name)
      return AccObj
   
   for k, v in Acc_Children(AccObj)
      if IsObject(obj := GetElementByName(v, name))
         return obj
}

; numpad0::
	; hwndChrome := WinExist("ahk_class Chrome_WidgetWin_1")								;magic that searches for "youtube.com" in current url
	; AccChrome := Acc_ObjectFromWindow(hwndChrome)
	; AccAddressBar := GetElementByName(AccChrome, "Address and search bar")				;spits out current url
	; msgbox % AccAddressBar.accValue(0)
	; ytpos := instr( AccAddressBar.accValue(0), "youtube.com")								;finds needle "youtube.com" in haystack "accbar.."
	; msgbox % ytpos
; return

;---------------------------------------------------------------------------------------------

; Morse(timeout = 250) { 
   ; tout := timeout/1000
   ; key := RegExReplace(A_ThisHotKey,"[\*\~\$\#\+\!\^]")
   ; Loop {
      ; t := A_TickCount
      ; KeyWait %key%
      ; Pattern .= A_TickCount-t > timeout
      ; KeyWait %key%,DT%tout%
      ; If (ErrorLevel)
         ; Return Pattern
   ; }
; }

; Numpad0:: 
	; p := Morse()
	; If (p = "0"){
		; }
	; else if (p="00") {
		; }
	; else if (p="01") {
		; }
	; else {
	; }
; return

;--------------------------------------------------------------------------------------------

GetCursorPos()
{
    static POINT, init := VarSetCapacity(POINT, 8, 0) && NumPut(8, POINT, "Int")
    if !(DllCall("user32.dll\GetCursorPos", "Ptr", &POINT))
        return DllCall("kernel32.dll\GetLastError")
    return { x : NumGet(POINT, 0, "Int"), y : NumGet(POINT, 4, "Int") }
}

; numpad0::
	; a := GetCursorPos()
	; msgbox % a.x ", " a.y
; return

;---------------------------------------------------------------------------------------------