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



; o o o o o o o o o o o o o o o KEYBOARD STUFF o o o o o o o o o o o o o o o o o o o o o

;----------------------------------- lock window on top

^!Numpad0:: Winset, Alwaysontop, , A 
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
		Run, %A_ScriptDir%\brackets_altgr.ahk
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



;-------------------------------------Qmode

; $\::
	; if Winactive("ahk_exe resolve.exe") {
	; page := pageacc()
	; coordmode tooltip screen
	; tooltip % page, calpix.fux-50, 1,2
	; Keywait, \, t0.3
	; if errorlevel {
		; gosub Qboxes
		; keywait \
		; Box_Hide()
		; Gui, 96: Show, % "x" 1100 " y" 0 " w" 70 " h" 20 " NA"
		; }
	; else {
		; Qmode:= (1-Qmode)**2
		; if (Qmode=1){
			; gosub Qboxes
			; Box_Hide()
			; Gui, 96: Show, % "x" 1080 " y" 0 " w" 70 " h" 20 " NA", Qbox
			; }
		; else {
		; Box_Destroy()
		; }
	; }
	; if (Qmode=0)
		; Box_Destroy()
		; }
	; else 
		; send \
; Return

; $+\::
	; if Winactive("ahk_exe resolve.exe") {
		; Box_Destroy()
		; gosub Qreset
		; Qmode:=0
		; }
	; else 
		; send +\
; Return



;----------------------------------- fix Insert!

#delete::
	send {insert}
Return

;-----------------------------------windowspy hold Menu key

$AppsKey::
	p := Morse()
	if WinActive("ahk_exe resolve.exe") {
		If (p = "0") {													
			scrollmod := 0
			heldf1:=0
			tooltip
			if (Qmode=1)
				Gui, 96: Show
			page := pagecheck(calpix)
			if (page = "") 
				gosub underkill
			if (page = "") 
				gosub overkill
			}
		Else If (p = "00") { 										
			page := pagecheck(calpix)										;pagecheck still relies on mousemove... but works 99%+
			if WinActive("Secondary Screen")								;for tooltip pos reasons
				gosub overkill												
			start := GetCursorPos()											
			DllCall("SetCursorPos", "int", 10, "int", 54) 					;setcursorpos doesn't work properly from second screen
			DllCall("SetCursorPos", "int", calpix.mex, "int", calpix.mey)
			pixpicker := true
			tooltip, -- MEDIA -- , calpix.mex-80, calpix.mey-50
			}
		Else If (p = "01") { 												; short long
			reload, C:\Users\tomba\OneDrive\Desktop\AutoHotKey\G600_Aero.ahk
			}
		Else { 																; long
			run, C:\Program Files\AutoHotkey\WindowSpy.ahk
			}
		}
	else 
		If (p = "0") 	{
			Gui, 96:  Hide
			tooltip,,,,2
			
			}
		Else  																
			run, C:\Program Files\AutoHotkey\WindowSpy.ahk		
Return

;------------------------------------- + appskey: fix weird window on opening
+AppsKey::
	page :=	pageacc()
	WinGet, hWnd, ID, A
	oAcc := Acc_Get("Object", "4.1.13", 0, "ahk_id " hWnd)
	oAcc.accDoDefaultAction(0)
	oAcc := Acc_Get("Object", "4.1.13.1.17", 0, "ahk_id " hWnd)
	oAcc.accDoDefaultAction(0)
	oAcc := ""
	coordmode tooltip screen
	tooltip % page, calpix.fux-50, 1,2
return

;------------------------------------- appskey number select prim monitor

AppsKey & Numpad1::
	page :=	pageacc()
	WinGet, hWnd, ID, A
	oAcc := Acc_Get("Object", "4.1.13", 0, "ahk_id " hWnd)
	oAcc.accDoDefaultAction(0)
	oAcc := Acc_Get("Object", "4.1.13.1.9", 0, "ahk_id " hWnd)
	oAcc.accDoDefaultAction(0)	
	oAcc := Acc_Get("Object", "4.1.13.1.9.1.1", 0, "ahk_id " hWnd)
	oAcc.accDoDefaultAction(0)	
	oAcc := ""
return

AppsKey & Numpad2::
	page :=	pageacc()
	WinGet, hWnd, ID, A
	oAcc := Acc_Get("Object", "4.1.13", 0, "ahk_id " hWnd)
	oAcc.accDoDefaultAction(0)
	oAcc := Acc_Get("Object", "4.1.13.1.9", 0, "ahk_id " hWnd)
	oAcc.accDoDefaultAction(0)	
	oAcc := Acc_Get("Object", "4.1.13.1.9.1.2", 0, "ahk_id " hWnd)
	oAcc.accDoDefaultAction(0)	
	oAcc := ""
return


;------------------------------------- transparent    -  probably change key

!^Appskey::
	winget, trans, transparent, a
	if (trans="")
		Winset, Transparent, 128, A
	else
		Winset, Transparent, OFF, A
Return



; o o o o o o o o o o o o o o o o o o o VAR GUI o o o o o o o o o o o o o o o o o o o o


!AppsKey::
	rule:= yvalruler(page, ruler.edy, ruler.coy, ruler.fuy, ruler.fay, ruler.rey)
	keyframe := keyframe(page, kf.edx, kf.edy, kf.cox, kf.coy, kf.fux, kf.fuy, kf.fax, kf.fay, kfrex, kf.rey)
	goto makethegui
Return


;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo


;           00                        00  
;            0                         0  
;   000  000 00000    0000    0000     0  
;    0    0  00  00  0    0  0    0    0  
;    0 00 0  0    0  000000  000000    0   
;    0 0000  0    0  0       0         0  
;     00 0   0    0  00      00        0   
;     0  0  000  000  00000   00000  00000 




; o o o o o o o o o o o o o o o o o o o FASTSCROLL o o o o o o o o o o o o o o o o o o o o


#if (!WinActive("ahk_exe Resolve.exe") && !WinActive("ahk_exe googleearth.exe"))

Process, Priority, , H

WheelUp::  
	if (cursed=0 && scrollmod=0 && heldf1=0 && heldf20=0 && pagescroll=0 && wheelarrow=0 && undoscroll=0 && cursed=0)
		Goto Scroll
	else if (wheelarrow=true)
		send {left}
	else
		Send {wheelup}
return
  
WheelDown::  
	if (cursed=0 && scrollmod=0 && heldf1=0 && heldf20=0 && pagescroll=0 && wheelarrow=0 && undoscroll=0 && cursed=0)
		Goto Scroll
	else if (wheelarrow=true)
		send {right}
	else 
		Send {wheeldown}
return



+^0::												; reset vars and toggle fast scroll 	
	start:=A_TickCount
	diff=5000										; reset all (except qmod?)
	scrollmod=:0
	heldf1:=0
	heldf20:=0
	pagescroll:=0
	wheelarrow:=0
	undoscroll:=0
	cursed:=0
	distance:=0										; Runtime variable
	vmax:= 1										; Runtime variable
	t:=0
	v:=0
	xfastscroll:=(xfastscroll-1)**2					; pause unpause
	if (xfastscroll=1)
		tooltip ■												
	else 
		tooltip ▶									;play ►
	sleep 1000
	tooltip
return


#if (WinActive("ahk_exe Resolve.exe") && (page="cut"))

WheelUp:: 
	send {pgup}
Return

WheelDown:: 
	send {pgdn}
Return

end::
	send !{end}
Return

#if


;-------------------------------------------------------	 ! Wheel 			skips ahead youtube

$!WheelUp::
	if WinActive("ahk_exe chrome.exe") 
		Sendinput {left}
	else if WinActive("ahk_exe spotify.exe")
		send +{left}	
	else if winactive("ahk_exe notepad++.exe") 
		Send ^{f2}
	else
		Sendinput !{WheelUp}
Return


$!WheelDown::
	if WinActive("ahk_exe chrome.exe") 
		Sendinput {right}
	else if WinActive("ahk_exe spotify.exe")
		send +{right}
	else if winactive("ahk_exe notepad++.exe") 
		Send ^{f3}
	else
		Sendinput !{WheelDown}
Return


;----------------------------------------------------		+ Wheel


$+wheelup::
	if WinActive("ahk_exe resolve.exe") 
		send +{wheelup}
	else if (WinActive("ahk_exe chrome.exe") || WinActive("ahk_exe rawtherapee.exe")) 
		send +{wheelup}
	else
		send {wheelleft}
Return


$+wheeldown::
	if WinActive("ahk_exe resolve.exe")
		send +{wheeldown}
	else if (WinActive("ahk_exe chrome.exe") || WinActive("ahk_exe rawtherapee.exe"))
		send +{wheeldown}
	else
		send {wheelright}
Return




;-----------------------------------------------------		^! Wheel   ( Alt Gr )




#if !WinActive("ahk_exe Resolve.exe")							;needs this to play ball with resolve

^!WheelUp::
	if winactive("ahk_exe notepad++.exe") 
		Send ^{f2}
	else
		Send {left}
Return

^!WheelDown::
	if winactive("ahk_exe notepad++.exe") 
		Send ^{f3}
	else
		Send {right}
Return

#if WinActive("ahk_exe Resolve.exe") && (page="fusion")

^!WheelUp:: 
	send !+{Wheelup}
Return

^!WheelDown:: 
	send !+{WheelDown}
Return

!WheelUp:: 
	send {WheelRight}
Return

!WheelDown:: 
	send {WheelLeft}
Return
#if




;--------------------------------------------------	 		Wheel L & R

$home::
if !WinActive("ahk_exe resolve.exe") 						
	Sendinput {Media_Prev}
else 
	Send {home}
Return
	
!home::
if WinActive("ahk_exe notepad++.exe") 
	send +{f7}
return

$end::
	keywait end, t.5
	
	if errorlevel {
		SendMessage,0x112,0xF170,2,,Program Manager
		DllCall("LockWorkStation")
		Sleep 1000
		SendMessage,0x112,0xF170,2,,Program Manager
		}
	else if !WinActive("ahk_exe resolve.exe")
		Sendinput {Media_Next}
	else
		send {end}
	keywait end
Return

!end::
if WinActive("ahk_exe notepad++.exe") 
	send +{f8}
return

<!<^0::
	if WinActive("ahk_exe rawtherapee.exe") 
		send z
	else
		send !^0
return

; WheelRight::
	; send {f5}
; Return

; WheelLeft::
	; send {f6}
; Return


; o o o o o o o o o o o o o o o        SCROLLMOD        	G7       o o o o o o o o o o o o o o o

Scrolllock::
	if (A_thishotkey!=A_priorhotkey || A_timesincepriorhotkey>400) {
		if (heldf21!=1)					;g11 trick: get rid of the click
			Send !{Lbutton down}
		Coordmode, mouse, screen
		If (scrollmod=0) 
			MouseGetPos, tweakx, tweaky
		KeyWait, Scrolllock, T.3
			If ErrorLevel {
				if (scrollmod = 2) {
					scrollmod := 1
					tooltip ◀  ▶										; ◀ ▶    bug▼ 
					}
				Else {
					scrollmod := 2
					tooltip ▲`n▼
					}
				}
			Else if (scrollmod = 0) {
				Scrollmod := 1
				tooltip ◀  ▶
				}
			else {
			Scrollmod := 0
			Send {Lbutton up}
			tooltip
			}
		KeyWait, Scrolllock
		}
	Else {					;double click
		Send {Lbutton up}
		Scrollmod := 2
		sleep 500
		Send !{Alt down}{LButton}{alt up}
		Sleep 500
		Send {Lbutton down}
		tooltip ▲`n▼	
		}
Return

!Scrolllock::
	Send {Alt down}{LButton}{alt up}
	Sleep 500
	Send {Lbutton down}
	scrollmod := 2
	tooltip ▲`n▼	
Return




;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo




; 	 0000 000   00000   00  00    00000    00000 
; 	  0  0  0  0     0   0   0   0     0  0     0
; 	  0  0  0  0     0   0   0    00000   0000000
; 	  0  0  0  0     0   0   0         0  0      
; 	  0  0  0  0     0   0  00   00    0  00    0
; 	 000 0 000  00000    0000000  00000    00000 
;                                                                    /


;------------------------------------------------------------						|  x  888 888 888
;------------------------------------------------------------						|  x  888 888 888
;------------------------------------------------------------						|  x  888 888 888
;------------------------------------------------------------						|  x  888 888 888



;--------------------------------------------------------	g9    	mouse: new tab in chrome, new sheet in Notepad++ 

;-------------------------------------------------------		    double press for Razor blade tool



$XButton2::
	if WinActive("ahk_exe chrome.exe") {
		p := Morse()
		If (p = "0"){
			Sendinput ^t
			}
		If (p = "00"){
			Sendinput ^w
			}
		}
	else if WinActive("ahk_exe resolve.exe") {
		if (page="cut") {
			mousegetpos skipx, skipy
			
			t1:=A_TickCount, X:=Y:=""

			Text:="|<>*60$22.zzzyGGGTzzzzzzy804SjzLubxTeTpyjbLuyBTfMpyjzLW017zzzzzzzYYYbzzzs"

			if (ok:=FindText(777-150000, 66-150000, 777+150000, 66+150000, 0, 0, Text))
				{
				CoordMode, Mouse
				X:=ok.1.x, Y:=ok.1.y, Comment:=ok.1.id
				Click, %X%, %Y%
				}
			mousemove skipx, skipy
			 for i,v in ok
			   if (i<=2)
				 FindText.MouseTip(ok[i].x, ok[i].y)
			
			}
		send a
		Keywait, XButton2, t0.3
			if errorlevel {		
				gosub movetoruler	
				Send {lbutton down}
				heldf1 := 1
				scrollmod := 1
				; mousegetpos x,y
				tooltip ◀ ◈ ▶, x-24, y+12				; ◀ ◈ ▶      or  ◀ ◆ ▶ ?
				}
		keywait XButton2
		}
	else {
		keywait XButton2		;don't open a million tabs
		Sendinput ^n
		}
Return

XButton2 up::
	if (heldf1=1) {
		Send {Lbutton up}
		if (page="edit") {
			skipped := GetCursorPos()
			DllCall("SetCursorPos", "int", skipped.x, "int", skip.y)
			; mousegetpos skippedx, skippedy
			; Mousemove, skippedx, skip.y
			}
		else {
			if (page="color") {
				mousegetpos skippedx, skippedy
				ruler.cox := skippedx
				}
			Mousemove, skip.x, skip.y
			}
		scrollmod := 0
		heldf1:=0
		tooltip	
		}
return	


#if !WinActive("ahk_exe resolve.exe")

XButton2 & WheelUp::
	if WinActive("ahk_exe explorer.exe")
		Send ^+{tab}
	else	
		Send ^{PgUp}
Return

XButton2 & WheelDown::
	if WinActive("ahk_exe explorer.exe")
		Send ^+{tab}
	else
		Send ^{PgDn}
Return

#if



;-------------------------------------------------------	!g9    mouse: cycle back tab 

; $^!f1::
	; if WinActive("ahk_exe Resolve.exe") {
		; pixpicker := true
		; i:=2
		; start := GetCursorPos()
		; gosub movetoruler
		; tooltip -- PIXPICKER --
	; }
; Return

; $!f1::
	; if WinActive("ahk_exe Resolve.exe") {
		; pixpicker := true
		; cal:=2
		; start := GetCursorPos()
		; gosub movetoruler
		; tooltip -- PIXPICKER --
		; }
	; else
		; Sendinput ^w
; Return


;-------------------------------------------------------	g10     mouse: selects title bar in chrome, up one folder windows exp

$f20::
	if WinActive("ahk_exe chrome.exe") {
		Keywait, f20, t0.25
		if errorlevel {
			heldf20 := 1
			choosebook := true
			send {f6 3}
			}
		else
			send {f11}
		Keywait, f20
		}
	else if WinActive("ahk_exe explorer.exe") 
		Sendinput !{up}
	else if WinActive("ahk_exe notepad++.exe") 	
		Send {f11}
	else if WinActive("ahk_exe resolve.exe") {							
			Keywait, f20, t0.3
			if errorlevel {
				skip := GetCursorPos()												;seems to work better than MouseGetPos
				if WinActive("Secondary Screen") 
					gosub overkill
				DllCall("SetCursorPos", "int", 10, "int", 54) 						;setcursorpos doesn't work properly from second screen
				DllCall("SetCursorPos", "int", calpix.fax, "int", calpix.mey) 
				; Mousemove calpix.fax, calpix.mey		
				heldf20 := 1
				choosepage:=true
				buttonskipper := (calpix.rex - calpix.mex)/6
				}
			else	
				Sendinput {f20}		
			Keywait f20
			}
	
Return

f20 up::
	if WinActive("ahk_exe resolve.exe") {
		if (heldf20=1) {
			MouseClick 
			mouseclick,,1000,3
			Mousemove, skip.x, skip.y
			heldf20:=0
			choosepage:=false
			SetTitleMatchMode 2
			sleep 100
			WinActivate %davinci%
			page := pagecheck(calpix)
			if (page = "") 
				gosub overkill
			sleep 200
			if WinActive("Secondary Screen")
				gosub underkill	
			}
		}
return	

;-------------------------------------------------------	!g10    cycle color tools

$!f20::
	if WinActive("ahk_exe resolve.exe") {
		if (page = "color"){
			keywait f20, t.05
				skip := GetCursorPos()												;seems to work better than MouseGetPos
				if WinActive("Secondary Screen") 
					gosub overkill
				DllCall("SetCursorPos", "int", 10, "int", 54) 						;setcursorpos doesn't work properly from second screen
				DllCall("SetCursorPos", "int", mask.x, "int", mask.y) 	
				choosetool:=true
			keywait alt 
				{
				choosetool:=false
				send {Lbutton}
				DllCall("SetCursorPos", "int", skip.x, "int", skip.y) 
			}
		}
	}
return			
		
;-------------------------------------------------------	g11     mouse: Launch Resolve / switch to Edit page

;------------------------------------------------------------      long press for blade tool
$f21::
	If !WinActive("ahk_exe Resolve.exe") {
		if (A_Priorhotkey="$f21" && A_timesincepriorhotkey<2500)						;this could go back to inside keywait if causes probs
			send {enter}
		else {
			keywait, f21, t.3
			if errorlevel {
				IfWinNotExist, ahk_exe Resolve.exe
					Run, C:\Program Files\Blackmagic Design\DaVinci Resolve\Resolve.exe
				else {
					SetTitleMatchMode 2
					WinActivate %davinci%
					coordmode tooltip screen
					tooltip % page, calpix.fux-50, 1, 2
					Gui, 94: Show
					sleep 200
					if (page="") {
						gosub underkill
						if (page="")
							gosub overkill
						}
					}
				}
			else 	
				send ^f														;find 
			keywait, f21
			}
		}
	else if WinActive("ahk_exe Resolve.exe") {
		keywait, f21, t.25
			if errorlevel {
			
				pagechoose := true
				
				menu, testmenu, add, Color, pagechooser
				menu, testmenu, add, Fusion, pagechooser
				menu, testmenu, add, Fairlight, pagechooser
				menu, testmenu, add, Cut, pagechooser
				menu, testmenu, add, Media, pagechooser
				menu, testmenu, add, Render, pagechooser
				menu, testmenu, show 
			
			}
			else {
				send +q 
				sleep 10
				send +4
				page := "edit"
				SetTitleMatchMode 2
				sleep 100
				WinActivate %davinci%
				coordmode tooltip screen
				tooltip % page, calpix.fux-50, 1, 2
				sleep 200
				if WinActive("Secondary Screen")
				gosub underkill	
			}		
		}	
Return

#if pagechoose

; a::
	; send {up}
; return

; s::
	; send {down}

; f21 up::
	; send {enter}
	; pagechoose := false
; return

#if

; +Capslock::
	; clipboard =
	; send ^c
	; clipwait 1
	; text := clipboard
	; if text =
		; return

; menu, testmenu, add, upper, stateyourcase
; menu, testmenu, add, title, stateyourcase
; menu, testmenu, add, lower, stateyourcase
; menu, testmenu, show  
; return 

Pagechooser:													;  *Capslock mod
	If (A_ThisMenuItem = "Color") { 
		Send +4
				page := "color"
				SetTitleMatchMode 2
				sleep 100
				WinActivate %davinci%
				coordmode tooltip screen
				tooltip % page, calpix.fux-50, 1, 2
				sleep 200
				if WinActive("Secondary Screen")
				gosub underkill	
		}
	Else If (A_ThisMenuItem = "Fusion") { ;       
		Send +5
				page := "fusion"
				SetTitleMatchMode 2
				sleep 100
				WinActivate %davinci%
				coordmode tooltip screen
				tooltip % page, calpix.fux-50, 1, 2
				sleep 200
				if WinActive("Secondary Screen")
				gosub underkill	
		}
	Else If (A_ThisMenuItem = "Fairlight") { ;       
		Send +6
				page := "fairlight"
				SetTitleMatchMode 2
				sleep 100
				WinActivate %davinci%
				coordmode tooltip screen
				tooltip % page, calpix.fux-50, 1, 2
				sleep 200
				if WinActive("Secondary Screen")
				gosub underkill	
		}
	Else If (A_ThisMenuItem = "Cut") { ;       
		Send +2
				page := "cut"
				SetTitleMatchMode 2
				sleep 100
				WinActivate %davinci%
				coordmode tooltip screen
				tooltip % page, calpix.fux-50, 1, 2
				sleep 200
				if WinActive("Secondary Screen")
				gosub underkill	
		}	
	Else If (A_ThisMenuItem = "Media") { ;       
		Send +1
				page := "media"
				SetTitleMatchMode 2
				sleep 100
				WinActivate %davinci%
				coordmode tooltip screen
				tooltip % page, calpix.fux-50, 1, 2
				sleep 200
				if WinActive("Secondary Screen")
				gosub underkill	
		}
	Else If (A_ThisMenuItem = "Render") { ;       
		Send +7
				page := "render"
				SetTitleMatchMode 2
				sleep 100
				WinActivate %davinci%
				coordmode tooltip screen
				tooltip % page, calpix.fux-50, 1, 2
				sleep 200
				if WinActive("Secondary Screen")
				gosub underkill	
		}		
Return 


#if WinActive("ahk_exe Resolve.exe")

f21 up::
	if (heldf21=1) {
		Send {f1}
		heldf21:=0
		}
return	


#if

;------------------------------------------------------------ !G11 mouse: Resolve switch to Edit page / otherwise cycle back tab 

$!f21::
	if WinActive("ahk_exe Resolve.exe") {
		Sendinput +4
		page := "color"
		sleep 100
		SetTitleMatchMode 2
		WinActivate %davinci%
		coordmode tooltip screen
		tooltip % page, calpix.fux-50, 1, 2
		sleep 200
		if WinActive("Secondary Screen")
			gosub underkill	
		}
	else
		Sendinput {esc}
Return


;------------------------------------------------------------						888  x  888 888
;------------------------------------------------------------						888  x  888 888
;------------------------------------------------------------						888  x  888 888
;------------------------------------------------------------						888  x  888 888



;------------------------------------------------------		g12      back

$f22::
	if WinActive("ahk_exe Resolve.exe") {											
		Sendinput {f22}
		keywait, f22, t.3 											;ripple delete during playback. not perfect
		if errorlevel {
			send ☻
			}
		}
	else if WinActive("ahk_exe notepad++.exe")	
		sendinput ^k
	else if (WinActive("ahk_exe chrome.exe") || WinActive("ahk_exe explorer.exe")) {
		keywait, f22, t.3 											;ripple delete during playback. not perfect
		if errorlevel {
			skip := GetCursorPos()
			WinGet, hWnd, ID, A
			oAcc := Acc_Get("Object", "4.1.2.1.2.1", 0, "ahk_id " hWnd)
			oRect := Acc_Location(oAcc)
			DllCall("SetCursorPos", "int", oRect.x + oRect.w/2 , "int", oRect.y+oRect.h/2)
			oAcc := ""
			Send {RButton}
			backhistory := true
			}
		else
			Sendinput !{left}
		keywait, f22
		if (backhistory=true) {
			send {Enter}
			backhistory := false
			DllCall("SetCursorPos", "int", skip.x, "int",  skip.y)
			}
		}
Return



;----------------------------------------------------		!g12     add keyframe
$!f22::
	MouseGetPos, xpos, ypos							
	keyframe := keyframe(page, kf.edx, kf.edy, kf.cox, kf.coy, kf.fux, kf.fuy, kf.fax, kf.fay, kf.rex, kf.rey)
	 DllCall("SetCursorPos", "int", keyframe.x, "int", keyframe.y ) 				
	 click
	 DllCall("SetCursorPos", "int", xpos, "int", ypos) 
Return

;------------------------------------------------------------- fix keyframe button position
!^f22::
	keyfredit:=true
	coordmode mouse screen
	mousegetpos xpos, ypos
	keyframe := keyframe(page, kf.edx, kf.edy, kf.cox, kf.coy, kf.fux, kf.fuy, kf.fax, kf.fay, kf.rex, kf.rey)
	mousemove keyframe.x, keyframe.y
	tooltip -- PIXPICKER --
Return

;-----------------------------------------------------		g13      cut, refresh, save


$f23:: 
	if WinActive("ahk_exe Resolve.exe") {
		send {f23}
		keywait, f23, t.3	
		if errorlevel {
			highlight:=1
			if (page="edit")
				Send {f12}
			}
		keywait f23
	}
	else {
	  if ((A_PriorHotkey = "f23 up" || A_PriorHotkey = "$f23" || A_PriorHotkey = "$f22") && A_TimeSincePriorHotkey < 500) {			
		if WinActive("ahk_exe Notepad++.exe") 
			Send ^+{f5}													;saved as RUN: $(FULL_CURRENT_PATH)
		else															
			Sendinput {esc}
		}
	else {
		if WinActive("ahk_exe Notepad++.exe") 
			send ^s
		else
			Sendinput ^{f5}	
		}
	}	
Return


f23 up::
	if (highlight=1) {
		send {f23}
	highlight:=0
	if (page="edit") {
		sleep 1000
		send {esc}
		}
	}
Return

$!f23::
	if WinActive("ahk_exe resolve.exe") {
		if (page="color")
			send !c
		else 
			send !{f23}
		}
	else
		send !{f23}
return
	


;----------------------------------------------------		g14    forward

$f24::
	if WinActive("ahk_exe Resolve.exe") {
		Sendinput {f24}
		}
	else if WinActive("ahk_exe notepad++.exe")	
		sendinput ^q
	else {
		keywait, f24, t.3
			if errorlevel {
			 Send, ^c
			 Sleep 50
			 Run, http://www.google.com/search?q=%clipboard%
			}
		keywait f24 	
		Sendinput !{right}
		}
Return

;---------------------------------------------------		!g14	 close tab
$!f24::
	if WinActive("ahk_exe chrome.exe")
		Sendinput l
	Else
		Sendinput !{f24}
Return



;------------------------------------------------------------						888 888 888  x   |
;------------------------------------------------------------						888 888 888  x   |
;------------------------------------------------------------						888 888 888  x   |
;------------------------------------------------------------						888 888 888  x   |



;------------------------------------------------------		g18  	 click:start;   long click:show desktop

XButton1::
	keywait, XButton1, t.3
		if errorlevel {
			Send #{alt down}{tab}
			wheelarrow:=true
			tooltip WIN	
			}
		else if (a_thishotkey=a_priorhotkey && a_timesincepriorhotkey<300)
			send #d
		else
			Send {rwin}
	keywait XButton1
	send {alt up}
return


;------------------------------------------------------		!g18yu	 !click:scroll through windows;  long !click: see available windows    

^XButton1::
	send !{f4}
return

#if wheelarrow

~lbutton::											;scaramanzia	
	wheelarrow:=false
	tooltip
return

#if

;----------------------------------------------------		g19 		UNDO    REDO    COPY    PASTE


>^c::
	keywait, c, t.2 
	if errorlevel {
		undoscroll:=true
		cursed:=1
		gosub cursing
		tooltip ☻
		}
	else {
		if (pastetime=1) {
			send ^v
			SetTimer, copytimer, off
			pastetime:=0
			}
		else {
			pastetime:=1
			SetTimer, copytimer, -250
		}
	}
return

copytimer:
	pastetime:=0
	send ^c
Return

>^+c::
	send ^x
return


#if undoscroll

c & wheelup::
	send ^z
return

c & wheeldown::
	send ^y
return

~lbutton::								;lclick also kills cursing
>^c up::
	tooltip
	undoscroll:=false
	gosub cursing
	cursed:=0
return


#if


;------------------------------------------------------		g20 	mouse launch Explorer / cycle Explorer tabs

Ins:: 
	p := Morse()									; how about unmorsing it??
	; SetTitleMatchMode 2  							; Avoids the need to specify the full path of the file below.
	If (p = "0"){
		IfWinNotExist, ahk_class CabinetWClass 
			Run, explorer.exe
		
		if WinActive("ahk_exe explorer.exe") 
			WinMinimize, a
			
		else {
			WinActivatebottom ahk_class CabinetWClass 
			Sleep 10
			WinActivate explorer.exe
			}
		}
	Else If (p = "00") { 						; double press
		SetTitleMatchMode 2
		IfWinNotExist Sticky Notes ahk_class ApplicationFrameWindow
			{
			Run, "C:\Users\tomba\OneDrive\Documents\AHK Shortcuts\Sticky Notes.lnk"
			Sleep 1500
			Winset, Alwaysontop, 1, Sticky Notes
			Sleep 500
			Winset, Alwaysontop, 1, Sticky Notes
			Sleep 200
			Winset, Alwaysontop, 1, Sticky Notes
			Sleep 200
			Winset, Alwaysontop, 1, Sticky Notes
			}
		
		else ;if WinActive("Sticky Notes ahk_class ApplicationFrameWindow")
			WinClose Sticky Notes ahk_class ApplicationFrameWindow
		; else
			; WinActivate Sticky Notes ahk_class ApplicationFrameWindow		
		}
	Else If (p = "01") 	{						; short + long presses
		SetTitleMatchMode 2
		IfWinNotExist OneNote for Windows 10 ahk_class ApplicationFrameWindow
			Run, "C:\Users\tomba\OneDrive\Documents\AHK Shortcuts\OneNote for Windows 10.lnk"
		
		else if WinActive("OneNote for Windows 10 ahk_class ApplicationFrameWindow")
			WinMinimize, a
		else
			WinActivate OneNote for Windows 10 ahk_class ApplicationFrameWindow
		}												
		
	Else {										; long press
		IfWinNotExist, ahk_exe notepad++.exe
			Run, notepad++.exe
		else if WinActive("ahk_exe notepad++.exe")
			WinMinimize, a
		else
			WinActivate ahk_exe notepad++.exe
		}
Return





;------------------------------------------------------------ !G20 mouse launch Chrome / cycle Chrome tabs
!Ins::
	; DetectHiddenWindows On  ; Allows a script's hidden main window to be detected.
	; SetTitleMatchMode 2  ; Avoids the need to specify the full path of the file below.
	; PostMessage, 0x0111, 65303,,, fastscroll.ahk - AutoHotkey
	IfWinNotExist, ahk_exe chrome.exe
		Run, chrome.exe
	if WinActive("ahk_exe chrome.exe")
		WinMinimize, a
	else
		WinActivate ahk_exe chrome.exe
Return





;  ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
;  ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
;  ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo7
;  ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo


; o o o o o o o o o o o o o o o      SCROLLMOD      o o o o o o o o o o o o o o o

#if (scrollmod!=0)
 

									;WHEEL UP
$wheelup::
	If (scrollmod = 1)
	mousemove, -1,0,,R 
	else if (scrollmod = 2)
	mousemove, 0,-1,,R
Return

$^wheelup::
	If (scrollmod = 1)
	mousemove, -8,0,,R 
	else if (scrollmod = 2)
	mousemove, 0,-8,,R
Return

$+wheelup::
	If (scrollmod = 1)
	mousemove, -30,0,,R 
	else if (scrollmod = 2)
	mousemove, 0,-30,,R
Return

									;WHEELDOWN
$wheeldown::
	If (scrollmod = 1)
	mousemove, 1,0,,R 
	else if (scrollmod = 2)
	mousemove, 0,1,,R
Return

$^wheeldown::
	If (scrollmod = 1)
	mousemove, 8,0,,R 
	else if (scrollmod = 2)
	mousemove, 0,8,,R
Return


$+wheeldown::
	If (scrollmod = 1)
	mousemove, 30,0,,R 
	else if (scrollmod = 2)
	mousemove, 0,30,,R
Return


$up::
		mousemove, 0,-5,,R
		sleep 10
return

$down::
		mousemove, 0,5,,R
		sleep 10
return

$left::
		mousemove, -5,0,,R
		sleep 10
return

$right::
		mousemove, 5,0,,R
		sleep 10
return


~Lbutton::                    				  ; exit TWEAK (scrollmod)
		Scrollmod :=0
		tooltip 
Return

; Ralt & q::														; WHAT IS ALL THIS???? thumbpad 8way. Delete?? - if you want it back go find it
	; if (scrollmod>=1)
	; mousemove, -5,-5,,R
	; sleep 10
; return

$Rbutton::															; TEST!! does this work???
	if (page="fusion")
		Send !{LButton up}
	else 
		send {RButton}
	Scrollmod :=0
	tooltip 
Return

#if


; o o o o o o o o o o o o o o o o       CALIBRATE PIXPICKER     o o o o o o o o o o o o o o o o 

#if pixpicker


Mbutton::
	coordmode pixel screen											; 
	coordmode mouse screen											; still works with slightly buggy mousemove etc... but works 99%+
	; coordmode tooltip screen
	if (cal=0) {														; set new coords for media button
		Mousegetpos, medx, medy
		calpix.mex:=medx
		calpix.mey:=medy
		tooltip -- RENDER --,calpix.rex-80, calpix.mey-50
		mousemove calpix.rex, calpix.mey		
		}
	if (cal=1) {
		Mousegetpos, renx, reny										; set new coord for render button
		calpix.rex:=renx
		calpix.cutx:= medx + (renx-medx)/6					; set coords of other buttons relatively
		calpix.edx:= medx + 2*(renx-medx)/6
		calpix.fux:= medx + 3*(renx-medx)/6
		calpix.cox:= medx + 4*(renx-medx)/6
		calpix.fax:= medx + 5*(renx-medx)/6
		gosub movetoruler	
		tooltip -- RULER --
		}
	cal++																; not i++ at the end so as to reset it cleanly
	if (cal=3) {
		if (page="edit") {
			Mousegetpos, edx, edy				; set edit timeline ruler position
			ruler.edy:=edy
			}
		else if (page="color") {
			Mousegetpos, cox, coy
			ruler.cox:=cox
			ruler.coy:=coy
			}
		else if (page="fusion") {
			Mousegetpos, fux, fuy
			ruler.fux:=fux
			ruler.fuy:=fuy
			}			
		else if (page="fairlight") {
			Mousegetpos, fax, fay
			ruler.fay:=fay
			}
		else if (page="render") {
			Mousegetpos, rex, rey	
			ruler.rey:=rey
			}
		cal:=0
		pixpicker := false
		tooltip -- SAVED --
		DllCall("SetCursorPos", "int", start.x, "int", start.y)
		sleep 500
		tooltip
		}
return

~lbutton::															; any L mouseclick exits recalibration
pixpicker := false
tooltip
return

#if

; o o o o o o o o o o o o o o o o o o   CHOOSE PAGE RESOLVE   o o o o o o o o o o o o o o o 

#if choosepage

$wheelup::
	Coordmode mouse screen
	Mousegetpos buttx, butty
	if (buttx > calpix.mex+20)
		mousemove buttx-buttonskipper, butty
return

$wheeldown::
	Coordmode mouse screen
	Mousegetpos buttx, butty
	if (buttx < calpix.rex-20)
		mousemove buttx+buttonskipper, butty
return

#if

#if choosetool

!wheelup::
f20 & wheelup::
	Coordmode mouse screen
	Mousegetpos toolx, tooly
	if (toolx > 900)
		mousemove toolx-toolskipper, tooly
return

!wheeldown::
f20 & wheeldown::
	Coordmode mouse screen
	Mousegetpos toolx, tooly
	if (toolx < 1300)
		mousemove toolx+toolskipper, tooly
return

#if


; o o o o o o o o o o o o o o o o   SELECT KEYFRAME BUTTON CLICK RESOLVE   o o o o o o o o o

#if keyfredit

Mbutton::
	; Coordmode pixel screen											; screen coordinates
	; coordmode mouse screen
	; Mousegetpos, x, y													; set edit timeline ruler position
		butt := GetCursorPos()
	if (page="edit") {
		kf.edx:=butt.x
		kf.edy:=butt.y
		}
	else if (page="color") {
		kf.cox:=butt.x
		kf.coy:=butt.y
		}
	else if (page="fusion")	 {
		kf.fux:=butt.x
		kf.fuy:=butt.y
		}
	else if (page="fairlight") {
		kf.fax:=butt.x
		kf.fay:=butt.y
		}
	else if (page="render") {
		kf.rex:=butt.x
		kf.rey:=butt.y
		}
	else if (buttcal=1) {									;if buttcal doesnt play out, kill this
	%k%.x:=butt.x
	%k%.y:=butt.y
	xpos:=butt.x
	ypos:=butt.y
	buttcal:=0
	}
	DllCall("SetCursorPos", "int", xpos, "int", ypos) 
	keyfredit := false
	tooltip
return		


~lbutton::															; any L mouseclick exits recalibration
keyfredit := false
tooltip
return

#if

; o o o o o o o o o o o o o o o o o     CHOOSE BOOKMARK CHROME    o o o o o o o o o o o o o o o 

#if choosebook

f20 & wheelup::
	if (a_thishotkey=a_priorhotkey && a_timesincepriorhotkey<100)			;make it faster
		send {left}
	send {left}
return

f20 & wheeldown::
	if (a_thishotkey=a_priorhotkey && a_timesincepriorhotkey<100)
		send {right}
	send {right}
return

~f20 up::																	;the tilde ~ is key!
	if (heldf20=1) {
		heldf20:=0
		choosebook:=false
		if WinActive("ahk_exe chrome.exe")
			send {enter}
		}
return	

#if

; o o o o o o o o o o o o o o o o o o o     BACK HISTORY       o o o o o o o o o o o o o o o o 

#if backhistory

f22 & wheelup::
	; if (a_thishotkey=a_priorhotkey && a_timesincepriorhotkey<100)			;make it faster
		; send {left}
	send {up}
return

f22 & wheeldown::
	; if (a_thishotkey=a_priorhotkey && a_timesincepriorhotkey<100)
		; send {right}
	send {down}
return

#if

; o o o o o o o o o o o o o o o o o o o     Q-Mode       o o o o o o o o o o o o o o o o 

#if (Qmode && winactive("ahk_exe resolve.exe"))

q::   
	goto Qpix
return

^!q::
	key:="q"
	goto Qmove
return

w::   
	goto Qpix
return

^!w::
	key:="w"
	goto Qmove
return

e::   
	goto Qpix
return

^!e::
	key:="e"
	goto Qmove
return

r::   
	goto Qpix
return

^!r::
	key:="r"
	goto Qmove
return


#if



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
  


; o o o o o o o o o o o o o o o o    D PAD   o o o o o o o o o o o o o o o o

#if highlight

up::
	send !{up}
return

down::
	send !{down}
return



#if (WinActive("ahk_exe Resolve.exe") && (page="cut"))

PgUp:: 
	send +{pgup}
Return

PgDn:: 
	send +{pgdn}
Return





#if

;                                                                                           ; BUTTON above D pad on Razer Tartarus

+^!=::
	if WinActive("ahk_exe chrome.exe") 
	{																						;Language Reactor tool to skip around captions. uses pgup,pgdn,appskey
		hwndChrome := WinExist("ahk_class Chrome_WidgetWin_1")								;magic that finds current url
		AccChrome := Acc_ObjectFromWindow(hwndChrome)
		AccAddressBar := GetElementByName(AccChrome, "Address and search bar")				;spits out current url
		; msgbox % AccAddressBar.accValue(0)
		ytpos := instr( AccAddressBar.accValue(0), "netflix.com")							;finds needle "netflix.com" in haystack "accaddress..."
		; msgbox % ytpos
		if (ytpos > 0)
		{	
			capwheel := 1
			Gui, 96: +ToolWindow -Caption +AlwaysOnTop +LastFound
			Gui, 96: Color, ff0000
			Gui, 96: Show, % "x" 0 " y" 1050 " w" 10 " h" 10 " NA"
		}
		else
		{
			capwheel := 0
			Gui, 96:  Hide
		}
	}
	else 
	{
		capwheel := 0
		Gui, 96:  Hide
	}
Return

#if (capwheel = 1) && WinActive("ahk_exe chrome.exe")

pgup::
	if (A_timesincepriorhotkey<500)
		send a
	else
		send s
return

pgdn::
	send d
return

#if

; o o o o o o o o o o o o o o o o    KEYS   o o o o o o o o o o o o o o o o

;-----------------------------------G01  -  Buggy with modifiers for some reason...
	
; $Backspace::
	; if WinActive("ahk_exe resolve.exe") {
	; KeyWait, backspace, T.07
	; If ErrorLevel {
		; sleepadd++											;equation to machinegun bs faster upon holding. still too slow... what holds it back? t0.7! fix with gosub??
		; sleepvar := 100/(sleepadd*sleepadd)
		; tooltip % sleepvar
		; Send {backspace}
		; Sleep % sleepvar
		; }
	; }
	; else 
		; send {backspace}
	
; Return

; Backspace up::
	; if WinActive("ahk_exe resolve.exe") {
	; KeyWait, backspace
	; sleepadd := 0
	; Sleep 100
	; tooltip
	; }
; return

$Delete::
	Send {delete}
	KeyWait, Delete, T.6
		If ErrorLevel {
			Send ^{Delete}	
			}
	KeyWait, Delete
	tooltip
Return

^+Delete::														; FIX INSERT!!!!! when it goes wrong
	send {insert}
return

;-----------------------------------G02

$f2::
	KeyWait, F2, T.4
		If ErrorLevel { 
			send q							;empty
			}
		Else {
			Send {f2}
			}
	KeyWait, F2
	tooltip,
Return

$!f2::
	KeyWait, f2, T.07
		Send !c
	KeyWait, f2
Return

;-----------------------------------G03; printscreen is a bit faulty i think (releases maybe?). this is a workaround


; $f3::												; open close inspector - only works with dual screen
	; winactivate % davinci
	; WinGet, hWnd, ID, A
	; oAcc := Acc_Get("Object", "4.2.2.3.1.1.1.3.1.3", 0, "ahk_id " hWnd)
	; oAcc.accDoDefaultAction(0)   2.2.3.1.1.1.1.2.5
	; oAcc := ""				   2.2.3.1.1.1.2.1.3	
; Return

$f3::												
	skip := GetCursorPos()	
	DllCall("SetCursorPos", "int", inspector.x, "int", inspector.y)
	click
	DllCall("SetCursorPos", "int", skip.x, "int", skip.y)
Return



$!f3::												;layer node, clip attributes
	KeyWait, f3, T.07
	Send !l								
	KeyWait, f3
Return



;-----------------------------------G04


$f4::
	KeyWait, F4, T.4
	If ErrorLevel { 
		SoundBeep, 1500, 40
		Send s										;this speed stuff needs lots of work or death
		timer := True
		Speed:=0
		X:=1
		SetFormat, IntegerFast, D
		SetTimer, Go, -8000
		}
	Else {
		Send {f4}
		}
	KeyWait, F4
	tooltip,
Return

Go:
	Send {x}			;WTF IS THIS? ENTER?
Reset:
	SoundBeep, 800, 40
	timer := False
Return					;Refer to speed control subworld 

!NumpadEnter::
^NumpadEnter::
return

$!f4::
	KeyWait, f4, T.07
	Send ^h
	KeyWait, f4
Return

	
;-----------------------------------G05
; $Appskey::
; KeyWait, Appskey, T.1
	; If ErrorLevel {
		                          ; ; still empty
		
		; tooltip, lah
		; Sleep 100
		; tooltip	
		; }
	; KeyWait, Appskey,
; Return

$f5::

	KeyWait, F5, T.4
	If ErrorLevel { 
		SoundBeep, 1500, 40
									;still empty
		}
	Else {
		Send {f5}
		}
	KeyWait, F5
	tooltip,
Return


;-----------------------------------G06
$Numpaddiv::
KeyWait, Numpaddiv, T.1
If ErrorLevel {
	Send {Numpaddiv}
	tooltip, lah
	Sleep 100
	tooltip	
	}
KeyWait, Numpaddiv
Return

$f6::

	KeyWait, F6, T.4
	If ErrorLevel { 
		SoundBeep, 1500, 40
									;still empty
		}
	Else {
		Send {f6}
		}
	KeyWait, F6
	tooltip,
Return

;-----------------------------------G07        -7,8,9,Del are different - action happens immediately on Deep press
$Numpadsub::
KeyWait, Numpadsub, T.07
tooltip, lah
If ErrorLevel {
	Send {Numpadsub}
	Sleep 100	
	}
KeyWait, Numpadsub
tooltip
Return


$f7::
Send {f7} ;             <- this
KeyWait, f7, T.4
If ErrorLevel {

	Send +{f7 3}
	tooltip	
	}
KeyWait, f7
Return

;-----------------------------------G08       -7,8,9,Del are different - action happens immediately on Deep press
$Pause::
KeyWait, Pause, T.07
tooltip, lah
If ErrorLevel {
	Send {Pause}
	Sleep 100	
	}
KeyWait, Pause
tooltip
Return


$f8::
Send {f8}
KeyWait, f8, T.3
If ErrorLevel {

	Send +y
	tooltip	
	}
KeyWait, f8
Return

;-----------------------------------G09        -7,8,9,Del are different - action happens immediately on Deep press
$Numpadadd::
KeyWait, Numpadadd, T.07
tooltip, lah
If ErrorLevel {
	Send {Numpadadd}
	Sleep 100	
	}
KeyWait, Numpadadd
tooltip
Return


$f9::
Send {f9}
KeyWait, f9, T.4
If ErrorLevel {

	Send +{f9 3}
	tooltip	
	}
KeyWait, f9
Return


;-----------------------------------G10
$Numpadmult::
KeyWait, Numpadmult, T.1
tooltip, lah
If ErrorLevel {
									;still empty
	Sleep 100
	tooltip	
	}
KeyWait, Numpadmult,
tooltip	
Return

$f10::

	KeyWait, f10, T.4
	If ErrorLevel { 
		SoundBeep, 1500, 40
									;still empty
		}
	Else {
		Send {f10}
		}
	KeyWait, f10
	tooltip,
Return

$!Numpadmult::
return

$!f10::
	KeyWait, f10, T.07
	Send !{o}
	KeyWait, f10
Return

;-----------------------------------G11

$f11::

	KeyWait, f11, T.4
	If ErrorLevel { 
		SoundBeep, 1500, 40
		                    ; still blank
		}
	Else 
		Send {f11}
	KeyWait, f11
	tooltip,
Return
/* 
; $!Numpad1::  ;             if it ain't broke? registers as !num1 in resolve 
; return

$!f11::
	KeyWait, f11, T.07
	Send !{f11}
	KeyWait, f11
Return
*/
;-----------------------------------G12


$f12::

	KeyWait, f12, T.4
	If ErrorLevel { 
		SoundBeep, 1500, 40
		                    ; still blank
		}
	Else {
		Send {f12}
		}
	KeyWait, f12
	tooltip,
Return
/*
; $!Numpad2::              if it ain't broke? registers as !num2 in resolve 
; return

$!f12::
	KeyWait, f12, T.07
	Send !{f12}
	KeyWait, f12
Return
*/
;-----------------------------------G13 (immediate press)
; $Numpad3::
; KeyWait, Numpad3, T.07
; tooltip, lah
; If ErrorLevel {
	; Send {esc}			;{deselect}
	; Sleep 100	
	; }
; KeyWait, Numpad3
; tooltip
; Return


$f13::
Send {f13}				;select clip at playhead

KeyWait, f13, T.2
If ErrorLevel {
	Send l
	Send {esc}			;selection follows playhead
	}
KeyWait, f13
tooltip
Return

; $!Numpad3::
; return

$!f13::
	KeyWait, f13, T.07
	Send !{f13}
	KeyWait, f13
Return

;-----------------------------------G14 


$f14::
Send {f14}
KeyWait, f14, T.2
If ErrorLevel {
				
	}
KeyWait, f14
tooltip
Return


$!f14::
	KeyWait, f14, T.07
	Send !{f14}		  ;toggle slip slide
	KeyWait, f14
Return


f14 & Pgup::
Send !{left}
Return

f14 & Pgdn::
Send !{right}
Return

f14 & up::
Send !{up}
Return

f14 & down::
Send !{down}
Return

f14 & left::
Send !{pgup}
Return

f14 & right::
Send !{pgdn}
Return

;-----------------------------------G15   (immediate press)



$f15::
Send +y						;select edit point
Send {f15}					;cycle edit point types

KeyWait, f15
tooltip
Return

; $!Numpad5::
; return

$!f15::
	KeyWait, f15, T.07
	Send !{f15}				;toggle slip slide
	KeyWait, f15
Return

f15 & Pgup::
Send !{pgup}
Return

f15 & Pgdn::
Send !{pgdn}
Return

^f15::
	Send ^{f15}
return

+f15::
	Send +{f15}
return

;-----------------------------------G16  undo button; 


$f16::
	if (scrollmod = 0)							;no long press for the moment....
		send {f16}
	else if (xnow = tweakx && ynow = tweaky) {
		click
		scrollmod := 0
		sleep 50
		send {f16}
		}
	else {
		Coordmode mouse screen  
		MouseGetPos xnow, ynow
		if (xnow != tweakx || ynow != tweaky)
			mousemove tweakx, tweaky
		}
Return


;-----------------------------------G17
; $Numpad7::
; KeyWait, Numpad7, T.1
; tooltip, lah
; If ErrorLevel {
	; Send c
	; Sleep 100
	; tooltip	
	; }
; KeyWait, Numpad7,
; tooltip	
; Return

$f17::
	tooltip, DOOOONG!
	KeyWait, f17, T.4
	If ErrorLevel { 
		SoundBeep, 1500, 40
		Send ???
		}
	Else {
		Sendinput {f17}
		}
	KeyWait, f17
	tooltip,
Return


;-----------------------------------G18
; $Numpad8::
; KeyWait, Numpad8, T.1
; tooltip, lah
; If ErrorLevel {
	; Send x
	; Sleep 100
	; tooltip	
	; }
; KeyWait, Numpad8,
; tooltip	
; Return

$f18::
	tooltip, DOOOONG!
	KeyWait, f18, T.4
	If ErrorLevel { 
		SoundBeep, 1500, 40
								;empty. modifier?
		}
	Else {
		Sendinput {f18}
		}
	KeyWait, f18
	tooltip,
Return





;-----------------------------------G19

; $Numpad9::
; KeyWait, Numpad9, T.1
; tooltip, lah
; If ErrorLevel {
	; Send v
	; Sleep 100
	; tooltip	
	; }
; KeyWait, Numpad9,
; tooltip	
; Return

$f19::
	tooltip, DOOOONG!
	KeyWait, f19, T.4
	If ErrorLevel { 
		SoundBeep, 1500, 40
								;empty. modifier?
		}
	Else {
		Sendinput {f19}
		}
	KeyWait, f19
	tooltip,
Return

; $^Numpad9::
; return

$^f19::
	KeyWait, f19, T.07
	Send ^{f19}
	KeyWait, f19
Return

;--------------------------------------------------scroll click + ctrl add vol keyframe

^+l::																
	MouseGetPos, xpos, ypos
	DllCall("SetCursorPos", "int", 1990, "int", 178 ) 				;
	sleep 10
	click
	DllCall("SetCursorPos", "int", xpos, "int", ypos) 
return

;--------------------------------------------------Flagland modifier

; Numpad6::
	; numpaddotfix := 1
	; flagland := true
	; if (A_priorhotkey="Numpad6 up" && A_timesincepriorhotkey<300) {
	; Num6toggle := 1
	; tooltip % chr(2) chr(2) chr(2)
	; }
	; else if (num6toggle = 1) {
		; num6toggle := 0
		; tooltip
		; }
	; else 
		; tooltip % chr(2) chr(2) chr(2)
; return

; Numpad6 up::
	; numpaddotfix := 0
	; if (Num6toggle != 1) {
	; flagland := false
	; tooltip
	; }
	; else 
; return


; / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / /


; o o o o o o o o o o o o o o  SPEED CONTROL SUBWORLD  o o o o o o o o o o o o o o o 


#If timer 

backspace::

PrintScreen::
NumpadEnter::
AppsKey::
Numpaddiv::
Numpadsub::
Pause::
Numpadadd::
Numpadmult::
Return

f7::										;reduce speed
	KeyWait, %A_Thishotkey%, T.08
	If ErrorLevel {
		If (speed>100 or speed=0 or speed<=-100)
			Speed:=Speed-100
		Else if (speed>0 && speed<=100) {
			X:=X+1
			Speed:= Speed*((X-1)/X)
			}
		Else if (speed>-100 && speed<0) {
			X:=X-1
			Speed:= Speed*((X+1)/X)
			}
		Sleep 200
		Sendinput {Shift down}{Left 5}{Shift up}
		Sleep 40
		Shortspeed:= Substr(Speed, 1, 5)
		Send %Shortspeed%
		}
	KeyWait, %A_Thishotkey%

pgup::										;reduce speed
	If (speed>100 or speed=0 or speed<=-100)
		Speed:=Speed-100
	Else if (speed>0 && speed<=100) {
		X:=X+1
		Speed:= Speed*((X-1)/X)
		}
	Else if (speed>-100 && speed<0) {
		X:=X-1
		Speed:= Speed*((X+1)/X)
		}
	Sleep 200
	Sendinput {Shift down}{Left 5}{Shift up}
	Sleep 40
	Shortspeed:= Substr(Speed, 1, 5)
	Send %Shortspeed%
Return

f8::										;flip sign
	KeyWait, %A_Thishotkey%, T.08
	If ErrorLevel {
		If (speed!=0) { 
		Speed:=-Speed
		}
		Else if (speed=0) {
		Speed:=33.3333
		}
		Shortspeed:= Substr(Speed, 1, 5)
		Sendinput {Shift down}{Left 5}{Shift up}
		Send %Shortspeed%
		}
	KeyWait, %A_Thishotkey%

^l::										;flip sign

	If (speed!=0) { 
	Speed:=-Speed
	}
	Else if (speed=0) {
	Speed:=33.3333
	}
	Shortspeed:= Substr(Speed, 1, 5)
	Sendinput {Shift down}{Left 5}{Shift up}
	Send %Shortspeed%
Return



f9::										;increase speed
	KeyWait, %A_Thishotkey%, T.08
	If ErrorLevel {
		If (speed>=100 or speed=0 or speed<-100)
			Speed:=Speed+100
		Else if (speed>0 && speed<100) {
			X:=X-1
			Speed:= Speed*((X+1)/X)
			}
		Else if (speed>=-100 && speed<0) {
			X:=X+1
			Speed:= Speed*((X-1)/X)
			}
		Sleep 200
		Sendinput {Shift down}{Left 5}{Shift up}
		Sleep 40
		Shortspeed:= Substr(Speed, 1, 5)
		Send %Shortspeed%
		}
	KeyWait, %A_Thishotkey%
return

pgdn::										;increase speed
	If (speed>=100 or speed=0 or speed<-100)
		Speed:=Speed+100
	Else if (speed>0 && speed<100) {
		X:=X-1
		Speed:= Speed*((X+1)/X)
		}
	Else if (speed>=-100 && speed<0) {
		X:=X+1
		Speed:= Speed*((X-1)/X)
		}
	Sleep 200
	Sendinput {Shift down}{Left 5}{Shift up}
	Sleep 40
	Shortspeed:= Substr(Speed, 1, 5)
	Send %Shortspeed%	
return

f11::										;set -600
	KeyWait, %A_Thishotkey%, T.08
	If ErrorLevel {
		Speed:=-600
		Sendinput {Shift down}{Left 5}{Shift up}
		Send %Speed%
		}
	KeyWait, %A_Thishotkey%
return

f12::										;set -100
	KeyWait, %A_Thishotkey%, T.08
	If ErrorLevel {
		Speed:=-100
		Sendinput {Shift down}{Left 5}{Shift up}
		Send %Speed%
		}
	KeyWait, %A_Thishotkey%
return

f13::										;set 0
	KeyWait, %A_Thishotkey%, T.08
	If ErrorLevel {
		Speed:=0
		Sendinput {Shift down}{Left 5}{Shift up}
		Send %Speed%
		}
	KeyWait, %A_Thishotkey%
return


f14::										;set 100
	KeyWait, %A_Thishotkey%, T.08
	If ErrorLevel {
		Speed:=100
		Sendinput {Shift down}{Left 5}{Shift up}
		Send %Speed%
		}
	KeyWait, %A_Thishotkey%
return


f15::										;set 600
	KeyWait, %A_Thishotkey%, T.08
	If ErrorLevel {
		Speed:=800
		Sendinput {Shift down}{Left 5}{Shift up}
		Send %Speed%
		}
	KeyWait, %A_Thishotkey%
return


Delete::
	KeyWait, %A_Thishotkey%, T.08
	If ErrorLevel {
		Send X
		}
	KeyWait, %A_Thishotkey%
	SetTimer, Go, Off
	Gosub, Reset
Return

Space::
	Send {Enter}
	SetTimer, Go, Off
	Gosub, Reset
Return

#If ;---------------------------------------------End of Speed control



#If flagland ; o o o o o o o o o o o o o  FLAGLAND SUBWORLD  o o o o o o work out the buttons that must stay... g13?



PrintScreen::
NumpadEnter::
AppsKey::
Numpaddiv::
Numpadsub::
Pause::
Numpadadd::
Numpadmult::

Return



f2:: 						;clip colour
Send W
KeyWait, f2, t.3
if errorlevel
send q
KeyWait, f2
tooltip % chr(24) chr(24) chr(24)
return

f3:: 
Send E
KeyWait, f3, t.1
KeyWait, f3
tooltip % chr(24) chr(24) chr(24)
return

f4:: 
Send R
KeyWait, f4, t.1
KeyWait, f4
tooltip % chr(24) chr(24) chr(24)
return

f5:: 
Send T
KeyWait, f5, t.1
KeyWait, f5
tooltip % chr(24) chr(24) chr(24)
return


f11:: 						;flags
	keywait, f11, t.1
	if (clearflags=1) {
		send ^O
		clearflags:=0
		}
	else {
		Send ^o
		clearflags:=1
		}
	keywait f11
return


f12:: 						
	keywait, f12, t.1
	if (clearflags=2) {
		send ^O
		clearflags:=0
		}
	else {
		Send ^p
		clearflags:=2
		}
	keywait f12
return

f14:: 						;markers edit to toggle
Send ^w
KeyWait, f14, t.1
KeyWait, f14
tooltip % chr(24) chr(24) chr(24)
return

f15:: 
Send ^q
KeyWait, f15, t.1
KeyWait, f15
tooltip % chr(24) chr(24) chr(24)
return

#if


#if (page="fusion")

pgup::
	send {left 5}
return

pgdn::
	send {right 5}
return



^pgup::
	send {left}
return

^pgdn::
	send {right}
return

#if


; ------								----	 CONTROLS    RawTherapee	----

#if !WinActive("ahk_exe resolve.exe")

f16::
	send ^z
return

#if

#if WinActive("ahk_exe rawtherapee.exe")

!WheelDown::
	if (A_thishotkey!=A_priorhotkey || A_timesincepriorhotkey>300)
		Send +{WheelDown}
	else
		Send +{WheelDown 3}
Return

!WheelUp::
	if (A_thishotkey!=A_priorhotkey || A_timesincepriorhotkey>300)
		Send +{WheelUp}
	else
		Send +{WheelUp 3}
Return

f1:: 
	send +l
return

f22::
	send l
return

f20::
	send !e
Return
	
!f20::
	send !c
return

f23::
	send !s
return
	
^0::
	send f
Return

f6::
	KeyWait, F6
	send <
return

f10::
	KeyWait, F10
	send >
return

^pgup::
!pgup::
	send {pgup 5}
Return

^pgdn::
!pgdn::
	send {pgdn 5}
Return

!f16::
	send ^+z
return

home::
	send {f3}
return

end::
	send {f4}
return

f21:: 
	send ^{f4}
return

!f21:: 
	send ^{f2}
return

#if

#if WinActive("ahk_exe xnviewmp.exe")

f10::
	KeyWait, F10
	send ^5
return

f15::
	KeyWait, F15
	send ^1
return

#if

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


SC073:: 												; 1
; MsgBox, %A_ThisHotkey% was pressed.	
return

SC070:: 												; 2
; MsgBox, %A_ThisHotkey% was pressed.
return

SC07D:: 												; 3
; MsgBox, %A_ThisHotkey% was pressed.
return

SC079:: 												; 4
; MsgBox, %A_ThisHotkey% was pressed.
return

SC07B:: 												; 5
; MsgBox, %A_ThisHotkey% was pressed.
	IfWinNotExist, ahk_exe Telegram.exe
			Run, "C:\Users\tomba\OneDrive\Desktop\Telegram.lnk"
		else if WinActive("ahk_exe Telegram.exe")
			WinMinimize, a
		else
			WinActivate ahk_exe Telegram.exe
return

SC05C::  												; 6
	IfWinNotExist, ahk_exe vivaldi.exe
			Run, vivaldi.exe
		else if WinActive("ahk_exe vivaldi.exe")
			WinMinimize, a
		else
			WinActivate ahk_exe vivaldi.exe
return
