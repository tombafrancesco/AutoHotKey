#NoEnv
#SingleInstance force
#include C:\Users\tomba\OneDrive\Desktop\AutoHotKey\lib\Acc.ahk
#include C:\Users\tomba\OneDrive\Desktop\AutoHotKey\lib\func.ahk
#include C:\Users\tomba\OneDrive\Desktop\AutoHotKey\lib\gdip.ahk


davinci := "DaVinci Resolve by Blackmagic Design - 17.1.0"

; Numpad0:: 
	; winactivate % davinci
   ; WinGet, hWnd, ID, A															; OPEN MENU, SELECT MENU ITEM
   ; oAcc := Acc_Get("Object", "4.1.11", 0, "ahk_id " hWnd)
   ; msgBox, % oAcc.accName(0)
   ; oAcc.accDoDefaultAction(0)
   ; ; oAcc := Acc_Get("Object", "4.1.11.1.9", 0, "ahk_id " hWnd)
   ; ; oAcc.accDoDefaultAction(0)
   ; oAcc := ""
; return


; numpad0::
	; WinGet, hWnd, ID, A
	; oAcc := Acc_Get("Object", "4.1.2.1.2.1", 0, "ahk_id " hWnd)					; REAL PRETTY WAY OF GETTING CLICKS IN THE RIGHT PLACES
	; ; msgBox, % oAcc.accName(0)
	; oRect := Acc_Location(oAcc)
	; ; MsgBox, % oRect.x " " oRect.y " " oRect.w " " oRect.h
	; DllCall("SetCursorPos", "int", oRect.x + oRect.w/2 , "int", oRect.y+oRect.h/2)
	; oAcc := ""
; return

; Numpad0:: 
	; winactivate % davinci
   ; WinGet, hWnd, ID, A															; FIND IF PAGE IS SELECTED - button technique
   ; oAcc := Acc_Get("Object", "4.2.2.3", 0, "ahk_id " hWnd)						; 4.2.2.1 - 4.2.2.7 color NOTE!! 5,6 inverted
	  ; msgBox, % oAcc.accState(0)												; color:6, fairlight: 5
	  ; if (oAcc.accState(0)=0)													; 0 if selected
		; page:= "edit"															; 1048576 is unselected
return


; Numpad0:: 
	; winactivate % davinci
   ; WinGet, hWnd, ID, A															; FIND IF PAGE IS SELECTED - button technique
   ; oAcc := Acc_Get("Object", "4.2.1.1.1.1.2.5", 0, "ahk_id " hWnd)
	  ; ; msgBox, % oAcc.accState(0)
	  ; if (oAcc.accState(0)=1048592)												; 1048592 is selected (only for pages)
		; page:= "edit"															; 1048576 is unselected
; return



; q::
   ; winactivate DaVinci Resolve by Blackmagic Design - 17.1.0
   ; WinGet, hWnd, ID, A
   ; oAcc := Acc_Get("Object", "4.2.2.6.1.2.3.2.2.1.1.2.1.8.1.2.1.2.2.1.4.4", 0, "ahk_id " hWnd)
   ; oAcc.accDoDefaultAction(0)
   ; mousegetpos x,y
   ; send ^c
   ; boxnum:=clipboard
   ; goto boxedit
; Return
	
; boxedit:
; loop {
	; mousegetpos xnew, ynew
	; boxnum:=(xnew-x)/x
	; send ^a %boxnum%
	; qstate:=getkeystate("q","p")
	; if (qstate=0)
		; break
; }
; return




; q:: ;Notepad - get status bar text
; WinGet, hWnd, ID, A
; oAcc := Acc_Get("Object", "3", 0, "ahk_id " hWnd)
; MsgBox, % oAcc.accName(2)
; msgBox, % oAcc.accDefaultAction(2)
; oAcc.accDoDefaultAction(2)
; oAcc := ""
; return