#NoEnv
SendMode Input
SetWorkingDir, C:\Users\tomba\OneDrive\Desktop\AutoHotKey				
#include C:\Users\tomba\OneDrive\Desktop\AutoHotKey\Var.ahk			; Resolve variables
#include C:\Users\tomba\OneDrive\Desktop\AutoHotKey\lib\func.ahk  	; general function library
; #include C:\Users\tomba\OneDrive\Desktop\AutoHotKey\lib\Acc.ahk 		; can be included for Acc functions
; #include C:\Users\tomba\OneDrive\Desktop\AutoHotKey\lib\resfunc.ahk  	; Resolve function library
#include C:\Users\tomba\OneDrive\Desktop\AutoHotKey\GoSub1.ahk
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



SC079:: 												; 2,1
 ; MsgBox, %A_ThisHotkey% was pressed.
	IfWinNotExist, ahk_exe Telegram.exe
			Run, "C:\Users\tomba\OneDrive\Desktop\Telegram.lnk"
		else if WinActive("ahk_exe Telegram.exe")
			WinMinimize, a
		else
			WinActivate ahk_exe Telegram.exe
return

#if !winactive("ahk_exe RESOLVE.EXE")

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
		send {Media_Play_Pause}
return

SC07D:: 												; 1,3
; MsgBox, %A_ThisHotkey% was pressed.
	if winactive("Netflix - Vivaldi")
		send {a}
	else 
		send {left}
return



SC07B:: 												; 2,2
; MsgBox, %A_ThisHotkey% was pressed.
	SetTitleMatchMode, 2
	if (winactive("Netflix - Vivaldi") || winactive("YouTube - Vivaldi"))
		send f
return

SC05C::  												; 2,3
	send {space} 
return



;-----------------------
;-----------------------
;-----------------------
;-----------------------
;-----------------------
;-----------------------



#if winactive("ahk_exe RESOLVE.EXE")

SC073:: 												; 1,1
; MsgBox, %A_ThisHotkey% was pressed, %A_PriorHotkey% before.	
	Keywait, SC073, T.3
	{
		if errorlevel 
		{
			DllCall("SetCursorPos", "int", XZoom+176, "int", YZoom)
			click
		}
	}
	Keywait SC073
	
	 t1:=A_TickCount, X:=Y:="" 							; Find Zoom X on pg

	Text:="|<>*105$52.zzzzzzzzy1zzzzzzzzjzzzzzwvwswQ8zzvTrRiqPzzlyxmtRjzzDnr/ZqzzwzTRirPzzZs6D7Rjzyrzzzzzzznjzzzzzzzzs"

	 if (ok:=FindText(3147-150000, -1256-150000, 3147+150000, -1256+150000, 0, 0, Text))
	 {
	   CoordMode, Mouse
	   X:=ok.1.x, Y:=ok.1.y, Comment:=ok.1.id
	   XZoom := X+60 
	   YZoom := Y
	    click, %X%, %Y%
		Mousemove, %XZoom%, %Y%
		Exit
	 }

return

SC070:: 												; 1,2
		t1:=A_TickCount, X:=Y:=""

	Text:="|<>*106$62.zzzzzzzzzzkzzrvzzzzzzbzzjzzzzwvtXVEiC3zzhyrHqvRazzwQBmRir/jzzDzQtPhmvzznzrTKvRizztTyABWsvjzyrzzzzzzzzzCzzzzzzzzzzy"

	 if (ok:=FindText(3142-150000, -1231-150000, 3142+150000, -1231+150000, 0, 0, Text))
	 {
	   CoordMode, Mouse
	   X:=ok.1.x, Y:=ok.1.y, Comment:=ok.1.id
	   XPositionY := X+190 
	   YPosition := Y
		click, %X%, %Y%
		Mousemove, %XPositionY%, %Y%
		Exit
	 }


return

SC07D:: 												; 1,3
	t1:=A_TickCount, Text:=X:=Y:=""

	Text:="|<>*109$70.zzzxzzzrzzrzzTxzzzyDzzTwMEVQQ7usA5lirvRinTdaqqmtQBqtRwqvPM/ZarPZrkPgBjiqPRirTQirqz74AL7Rvuv3QTzzzzzzzztrzzzzzzzzzziTzzzzzzzzzz3zs"

	if (ok:=FindText(X, Y, 3117-150000, -1205-150000, 3117+150000, -1205+150000, 0, 0, Text))
	{
		FindText().Click(X+220, Y, "L")
	}
return

SC079:: 												; 2,1
 	
	t1:=A_TickCount, Text:=X:=Y:=""

	Text:="|<>*130$62.zzzzzyDzzzk7zzzzDzzzzjzzzznzzzzvoUoQ8MR+8SwzgnTAnCNrjTvCrnSraRvrUriArZvbSxvhvtBvStrjSnSyHAriRvrUrgAsRvbM"

	if (ok:=FindText(X, Y, 3102-150000, -1287-150000, 3102+150000, -1287+150000, 0, 0, Text))
	{
		FindText().Click(X+281, Y, "L")
	}

return

SC07B:: 												; 2,2
; MsgBox, %A_ThisHotkey% was pressed.
	Keywait, SC073, T.3
	{
		if errorlevel 
		{
			DllCall("SetCursorPos", "int", XPosition+176, "int", YPosition)
			click
		}
	}
	Keywait SC073
	
	t1:=A_TickCount, X:=Y:=""

	Text:="|<>*106$62.zzzzzzzzzzkzzrvzzzzzzbzzjzzzzwvtXVEiC3zzhyrHqvRazzwQBmRir/jzzDzQtPhmvzznzrTKvRizztTyABWsvjzyrzzzzzzzzzCzzzzzzzzzzy"

	 if (ok:=FindText(3142-150000, -1231-150000, 3142+150000, -1231+150000, 0, 0, Text))
	 {
	   CoordMode, Mouse
	   X:=ok.1.x, Y:=ok.1.y, Comment:=ok.1.id
	   XPosition := X+60 
	   YPosition := Y
		click, %X%, %Y%
		Mousemove, %XPosition%, %Y%
		Exit
	 }
return

SC05C::  												; 2,3
		t1:=A_TickCount, Text:=X:=Y:=""

	Text:="|<>*106$20.zzzs/TyyzzjhUvvNi2qtjhiPvNiyq3zzjzzvzzyzzzzs"

	if (ok:=FindText(X, Y, 3143-150000, -1105-150000, 3143+150000, -1105+150000, 0, 0, Text))
	
	Keywait, SC05C, T.2

	if errorlevel = 0
		{
		  FindText().Click(X+32, Y, "L")
		}
	else 
		{
			FindText().Click(X+66, Y, "L")
		}
	Keywait, SC05C

return


;-----------------------



#if