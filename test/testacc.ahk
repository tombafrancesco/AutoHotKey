#NoEnv
#SingleInstance force
#include C:\Users\tomba\OneDrive\Desktop\AutoHotKey\lib\Acc.ahk
#include C:\Users\tomba\OneDrive\Desktop\AutoHotKey\lib\func.ahk
#include C:\Users\tomba\OneDrive\Desktop\AutoHotKey\lib\gdip.ahk


; davinci := "DaVinci Resolve by Blackmagic Design - 17.1.0"

; Numpad0:: 
	; winactivate % davinci
   ; WinGet, hWnd, ID, A
   ; oAcc := Acc_Get("Object", "4.1.11", 0, "ahk_id " hWnd)
   ; msgBox, % oAcc.accName(0)
   ; oAcc.accDoDefaultAction(0)
   ; ; oAcc := Acc_Get("Object", "4.1.11.1.9", 0, "ahk_id " hWnd)
   ; ; oAcc.accDoDefaultAction(0)
   ; oAcc := ""
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