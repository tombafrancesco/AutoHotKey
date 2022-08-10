#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%				
#include %A_ScriptDir%\var.ahk			; Resolve variables
#include %A_ScriptDir%\lib\func.ahk  	; general function library
#include %A_ScriptDir%\lib\Acc.ahk 		; can be included for Acc functions
#include %A_ScriptDir%\resfunc.ahk  	; Resolve function library
#include %A_ScriptDir%\GoSubG600.ahk
#MaxHotkeysPerInterval 120				; mostly for FASTSCROLL
#SingleInstance Force
#InstallKeybdHook

;         00         00                    00                            
;          0                0               0                            
; 000  000 00000    000    00000    0000    0 0000  0000   00  000  00000
;  0    0  00  00    00     0      0    0   0 00   0    0   0   0  00   0
;  0 00 0  0    0    00     0      000000   000    000000   0   0   0000 
;  0 00 0  0    0    00     0      0        000    0         0 0        0
;   0  0   0    0    00     0   0  00       0  0   00        000   0    0
;   0  0  000  000 000000    000    00000  00 0000  00000     0    00000 
;                                                             0          
;                                                          0000          


SC073:: 												; 1,1
; MsgBox, %A_ThisHotkey% was pressed.	
	if winactive("Netflix - Vivaldi")
		send {d} 
	else 
		send {right}
return

SC070:: 												; 1,2
; MsgBox, %A_ThisHotkey% was pressed.
	if winactive("Netflix - Vivaldi")
		send {s}
	else 
		send {space}
return

SC07D:: 												; 1,3
; MsgBox, %A_ThisHotkey% was pressed.
	if winactive("Netflix - Vivaldi")
		send {a}
	else 
		send {left}
return

SC079:: 												; 2,1
 ; MsgBox, %A_ThisHotkey% was pressed.
	IfWinNotExist, ahk_exe Telegram.exe
			Run, "C:\Users\tomba\OneDrive\Desktop\Telegram.lnk"
		else if WinActive("ahk_exe Telegram.exe")
			WinMinimize, a
		else
			WinActivate ahk_exe Telegram.exe
return

SC07B:: 												; 2,2
 ; ; MsgBox, %A_ThisHotkey% was pressed.
	; ; IfWinNotExist, ahk_exe Telegram.exe
			; ; Run, "C:\Users\tomba\OneDrive\Desktop\Telegram.lnk"
		; ; else if WinActive("ahk_exe Telegram.exe")
			; ; WinMinimize, a
		; ; else
			; ; WinActivate ahk_exe Telegram.exe
		
			
	MouseClickDrag, l, 0, 0, -400, 0 , 100, R
return

SC05C::  												; 2,3
	send {space} 
return


;-----------------------