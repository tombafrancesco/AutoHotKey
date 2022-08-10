#NoEnv
SendMode Input
SetWorkingDir, C:\Users\tomba\OneDrive\Desktop\AutoHotKey
#include C:\Users\tomba\OneDrive\Desktop\AutoHotKey\lib\resfunc.ahk  	; Resolve function library
#MaxHotkeysPerInterval 120				; mostly for FASTSCROLL
#SingleInstance Force
#InstallKeybdHook


;  000                       00                                        00 
;    0                        0                                         0 
;    0                        0                                         0 
;    0 000   00000   000  000 0 0000     0000    0000     00 000   0000 0 
;    0 0    0     0   0    0  00    0  0     0       0     00     0    00 
;    00     0000000    0  0   0     0  0     0   00000     0      0     0 
;    0 0    0          0  0   0     0  0     0  0    0     0      0     0 
;    0  0   00    0     00    00    0  0     0  0   00     0      0    00 
;  000 0000   0000      00   00 0000     0000    000 00  000000    0000 00
;                       0                                                     
;                       0                                                 
;                    00000  


;----------------------------------- lock window on top

^!Numpad0:: 
	Winset, Alwaysontop, , A 
Return

;----------------------------------- plain text paste, file path

!^v::																			; AltGr V
	send % clipboard
return

;----------------------------------- brackets, quotes - Alt GR modifier

~!^[::
	SetTitleMatchMode, 2														; launch brackets altgr script
	DetectHiddenWindows, On
	If !WinExist("brackets_altgr.ahk" . " ahk_class AutoHotkey")
		Run, %A_WorkingDir%\lib\brackets_altgr.ahk
Return

;----------------------------------- capslock modifier

!Capslock::
^Capslock::
+Capslock::
	clipboard =
	send ^c
	clipwait 1
	text := clipboard
	if text =
		return

menu, testmenu, add, upper, stateyourcase
menu, testmenu, add, title, stateyourcase
menu, testmenu, add, lower, stateyourcase
menu, testmenu, show  
return 


;------------------------------------- transparent    -  probably change key

!^NumpadDot::
	winget, trans, transparent, a
	if (trans="")
		Winset, Transparent, 128, A
	else
		Winset, Transparent, OFF, A
Return


;-----------------------------------windowspy hold Menu key

$AppsKey::
	; p := Morse()														
	run, C:\Program Files\AutoHotkey\WindowSpy.ahk		
Return

$Numpad0::
	page := pageacc(x)
	msgbox % page
Return



Numpad1::
		winactivate % d
	WinGet, hWnd, ID, A																
	oAcc := Acc_Get("Object", "4.2.2.3", 0, "ahk_id " hWnd)																
	if (oAcc.accState(0)=0)														
		page:= "edit"
		msgbox % page
Return