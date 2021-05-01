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

Morse(timeout = 250) { 
   tout := timeout/1000
   key := RegExReplace(A_ThisHotKey,"[\*\~\$\#\+\!\^]")
   Loop {
      t := A_TickCount
      KeyWait %key%
      Pattern .= A_TickCount-t > timeout
      KeyWait %key%,DT%tout%
      If (ErrorLevel)
         Return Pattern
   }
}

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

;---------------------------------------------------------------------------------------------  BOXES:




Box_Corner(X, Y, W, H, T="1", Col="yellow", O="I") {    						;  starting top left (x,y,width,height,thickness,offset("o"/"c"/"i" outside centred inside), color)
	If(W < 0)
		X += W, W *= -1															; if wanna draw rectangle upwards/leftwards from corner
	If(H < 0)
		Y += H, H *= -1
	If(T >= 2)
	{
		If(O == "O")															
			X -= T, Y -= T, W += T, H += T
		If(O == "C")
			X -= T / 2, Y -= T / 2
		If(O == "I")
			W -= T, H -= T
	}
	Gui, 96: Show, % "x" X " y" Y " w" W " h" T " NA", Horizontal 1
	Gui, 98: Show, % "x" X " y" Y + H " w" W " h" T " NA", Horizontal 2
	Gui, 97: Show, % "x" X " y" Y " w" T " h" H " NA", Vertical 1
	Gui, 99: Show, % "x" X + W " y" Y " w" T " h" H + T " NA", Vertical 2

}

Box_Centre(X, Y, W="20", H="20", T="2", B="0",  C="yellow") {    							; centred (x,y,width,height,thickness,bullsey(0/1/2),color)
	
	; if (B=1) {
		; Gui, 95: Show, % "x" X-1 " y" Y-1 " w" 2 " h" 2 " NA", Bullseye
		; }
	; if (B=2) {

		; Gui, 95: Show, % "x" X-W/2 " y" Y-H/2 " w" W " h" H " NA", Bullseye
		; }
	if (B<2) {
		X -= (T+W/2), Y -= (T+H/2), W += T, H += T

		; tooltip % x " " y
		Gui, 96: Show, % "x" X " y" Y " w" W " h" T " NA", Horizontal 1
		Gui, 97: Show, % "x" X " y" Y " w" T " h" H " NA", Vertical 1
		Gui, 98: Show, % "x" X " y" Y + H " w" W " h" T " NA", Horizontal 2
		Gui, 99: Show, % "x" X + W " y" Y " w" T " h" H + T " NA", Vertical 2
		}
}


Box_Destroy() {																;destroy
	Loop, 4
		Gui, % A_Index + 95 ":  Destroy"
}


Box_Hide() {																;hide
	Loop, 3
		Gui, % A_Index + 96 ":  Hide"
}

; Live_Box(){																	;put box around control object where mouse is
	; SetBatchLines, -1
	; SetWinDelay, -1
	; Box_Init("FF0000")
		; Loop {
		   ; MouseGetPos, , , Window, Control, 2
		   ; WinGetPos, X1, Y1, , , ahk_id %Window%
		   ; ControlGetPos, X, Y, W, H, , ahk_id %Control%
		   ; if (X)
			  ; Box_Draw(X + X1, Y + Y1, W, H)
		   ; Sleep, 10
		  ; }
; }


; Box_Init(C="FF0000") {
	
	; Gui, 96: +ToolWindow -Caption +AlwaysOnTop +LastFound
	; Gui, 96: Color, % C
	; Gui, 97: +ToolWindow -Caption +AlwaysOnTop +LastFound
	; Gui, 97: Color, % C
	; Gui, 98: +ToolWindow -Caption +AlwaysOnTop +LastFound
	; Gui, 98: Color, % C
	; Gui, 99: +ToolWindow -Caption +AlwaysOnTop +LastFound
	; Gui, 99: Color, % C
; }