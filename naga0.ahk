#NoEnv
SendMode Input
SetWorkingDir, C:\Users\tomba\OneDrive\Desktop\AutoHotKey				
#include %A_WorkingDir%\Var.ahk			; Resolve variables
#include %A_WorkingDir%\lib\func.ahk  	; general function library
#include %A_WorkingDir%\lib\Acc.ahk 		; can be included for Acc functions
#include %A_WorkingDir%\lib\resfunc.ahk  	; Resolve function library
#include %A_WorkingDir%\lib\GoSubG600.ahk
#MaxHotkeysPerInterval 120				; mostly for FASTSCROLL
#SingleInstance Force
#InstallKeybdHook



; o o o o o o o o o o o o o o o KEYBOARD STUFF o o o o o o o o o o o o o o o o o o o o o



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
	if (WinActive("ahk_exe chrome.exe") || WinActive("ahk_exe vivaldi.exe")) 
		Sendinput {left}
	else if WinActive("ahk_exe spotify.exe")
		send +{left}	
	else if winactive("ahk_exe notepad++.exe") 
		Send ^{f2}
	else
		Sendinput !{WheelUp}
Return


$!WheelDown::
	if (WinActive("ahk_exe chrome.exe") || WinActive("ahk_exe vivaldi.exe")) 
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
	else if (WinActive("ahk_exe chrome.exe") || WinActive("ahk_exe vivaldi.exe") || WinActive("ahk_exe rawtherapee.exe")) 
		send +{wheelup}
	else
		send {wheelleft}
Return


$+wheeldown::
	if WinActive("ahk_exe resolve.exe")
		send +{wheeldown}
	else if (WinActive("ahk_exe chrome.exe") || WinActive("ahk_exe vivaldi.exe") || WinActive("ahk_exe rawtherapee.exe"))
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




^home::														; switch monitors back
	send ^#w
return

^end::														; switch monitors forward
	send ^#x
return

!home::
if WinActive("ahk_exe notepad++.exe") 
	send +{f7}
return

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

#if WinActive("ahk_exe vivaldi.exe")
													;     tab stack in Vivaldi with !Mclick
!Mbutton::
	send {Mbutton}
	sleep 100
	send ^,        	; shortcut for a command chain in viv
return
	
	

#if


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
	if (WinActive("ahk_exe chrome.exe") || WinActive("ahk_exe vivaldi.exe")) {
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


;-------------------------------------------------------	button2           held = vol control; click is full screen in browser, folder up in exp, slip mode resolve  

$f20 up::
	if (cancelf20 = 1)
		cancelf20 := 0
	else 
	{	
		if (WinActive("ahk_exe chrome.exe") || WinActive("ahk_exe vivaldi.exe")) {
			send {f11}
			}
		else if WinActive("ahk_exe explorer.exe") 
			Sendinput !{up}
		else if WinActive("ahk_exe notepad++.exe") 	
			Send {f11}
		else if WinActive("ahk_exe resolve.exe") 							
			Sendinput {f20}
	}
Return

f20 & wheelup::
	SoundSet, +10
	cancelf20 := 1
return

f20 & wheeldown::
	SoundSet, -10
	cancelf20 := 1
return


;-------------------------------------------------------	g10     DEPR      mouse: selects title bar in chrome, up one folder windows exp, broken something in resolve

; $f20::
	; if (WinActive("ahk_exe chrome.exe") || WinActive("ahk_exe vivaldi.exe")) {
		; Keywait, f20, t0.25
		; if errorlevel {
			; heldf20 := 1
			; choosebook := true
			; send {f6 3}
			; }
		; else
			; send {f11}
		; Keywait, f20
		; }
	; else if WinActive("ahk_exe explorer.exe") 
		; Sendinput !{up}
	; else if WinActive("ahk_exe notepad++.exe") 	
		; Send {f11}
	; else if WinActive("ahk_exe resolve.exe") {							
			; Keywait, f20, t0.3
			; if errorlevel {
				; skip := GetCursorPos()												;seems to work better than MouseGetPos
				; if WinActive("Secondary Screen") 
					; gosub overkill
				; DllCall("SetCursorPos", "int", 10, "int", 54) 						;setcursorpos doesn't work properly from second screen
				; DllCall("SetCursorPos", "int", calpix.fax, "int", calpix.mey) 
				; ; Mousemove calpix.fax, calpix.mey		
				; heldf20 := 1
				; choosepage:=true
				; buttonskipper := (calpix.rex - calpix.mex)/6
				; }
			; else	
				; Sendinput {f20}		
			; Keywait f20
			; }
	
; Return

; f20 up::
	; if WinActive("ahk_exe resolve.exe") {
		; if (heldf20=1) {
			; MouseClick 
			; mouseclick,,1000,3
			; Mousemove, skip.x, skip.y
			; heldf20:=0
			; choosepage:=false
			; SetTitleMatchMode 2
			; sleep 100
			; WinActivate %davinci%
			; page := pagecheck(calpix)
			; if (page = "") 
				; gosub overkill
			; sleep 200
			; if WinActive("Secondary Screen")
				; gosub underkill	
			; }
		; }
; return	

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
			if errorlevel 
			{
				send +3

			}
			else 
			{
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
	else if (WinActive("ahk_exe chrome.exe") || WinActive("ahk_exe vivaldi.exe") || WinActive("ahk_exe explorer.exe")) 
	{
		Sendinput !{left}
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
	if (WinActive("ahk_exe chrome.exe") || WinActive("ahk_exe vivaldi.exe"))
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
		else if (a_thishotkey=a_priorhotkey && a_timesincepriorhotkey<500)
			send #d
		else
			Send {rwin}
	keywait XButton1
	send {alt up}
	tooltip
return


;------------------------------------------------------		!g18yu	 !click:scroll through windows;  long !click: see available windows    

^XButton1::
	send #d
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

f15 & wheelup::
	send ^z
return

f15 & wheeldown::
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





; ;------------------------------------------------------------ !G20 mouse launch Chrome 
; !Ins::
	; ; DetectHiddenWindows On  ; Allows a script's hidden main window to be detected.
	; ; SetTitleMatchMode 2  ; Avoids the need to specify the full path of the file below.
	; ; PostMessage, 0x0111, 65303,,, fastscroll.ahk - AutoHotkey
	; IfWinNotExist, ahk_exe chrome.exe
		; Run, chrome.exe
	; if WinActive("ahk_exe chrome.exe")
		; WinMinimize, a
	; else
		; WinActivate ahk_exe chrome.exe
; Return

;------------------------------------------------------------ !G20 mouse launch Vivaldi 
!Ins::
	; DetectHiddenWindows On  ; Allows a script's hidden main window to be detected.
	; SetTitleMatchMode 2  ; Avoids the need to specify the full path of the file below.
	; PostMessage, 0x0111, 65303,,, fastscroll.ahk - AutoHotkey
	IfWinNotExist, ahk_exe vivaldi.exe
		Run, vivaldi.exe
	if WinActive("ahk_exe vivaldi.exe")
		WinMinimize, a
	else
		WinActivate ahk_exe vivaldi.exe
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
		if (WinActive("ahk_exe chrome.exe") || WinActive("ahk_exe vivaldi.exe"))
			send {enter}
		}
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

; ---------------------------------------------- GENERAL CASE

; ---------------------------------------------- DAVINCI RESOLVE

#if winactive("ahk_exe RESOLVE.EXE")

SC07E::							; , Comma on via
								; Left Dial press
	if (A_ThisHotkey = A_PriorHotkey)
		Send !u 
	else 
	{
		Send ^{u 2}
	}
Return

f17::											;1,1
	send {del}
Return

!f17::								
^f17::
+f17::
	send {backspace}
Return

$f18::											;1,2
	send !d
Return

$Pause::										;1,3
	send !i
Return

!Pause::
	 t1:=A_TickCount, X:=Y:=""

	Text:="|<>*104$63.zzzzzzzzzzw3zzzzzzzzzyzzzzzznjzzb7XV7zzPzzxrPhazzwTzzStQirzzbzznr/ZqzzwzzyyvRirzz/zzUMwRqzzvTzzzzzzzzyRzzzzzzzzzzzzw"

	 if (ok:=FindText(5712-150000, -1258-150000, 5712+150000, -1258+150000, 0, 0, Text))
	 {
	   CoordMode, Mouse
	   X:=ok.1.x, Y:=ok.1.y, Comment:=ok.1.id
	   X2:=X+234
	   Y2:=Y+24
	   DllCall("SetCursorPos", "int", X2, "int", Y)
	   Click, 
	   Sleep 10
		DllCall("SetCursorPos", "int", X2, "int", Y2)
		Click,	
	 }

	 ; MsgBox, 4096, Tip, % "Found:`t" Round(ok.MaxIndex())
	   ; . "`n`nTime:`t" (A_TickCount-t1) " ms"
	   ; . "`n`nPos:`t" X ", " Y
	   ; . "`n`nResult:`t" (ok ? "Success !" : "Failed !")

	 for i,v in ok
	   if (i<=2)
		 FindText.MouseTip(ok[i].x, ok[i].y)
										  
	 ; MsgBox, %A_ThisHotkey% was pressed.
Return

$Browser_Stop::									;1,4
	send !t
Return

$Browser_Search::								;1,5
	send !n
Return

$f16::											;1,6
		p := Morse()									
	If (p = "0")
	{
		send +6
	}
	Else If (p = "00") 
	{
		send +5
	}
	Else If (p = "01") 	
	{
		send +8
	}
	Else 
	{
		send +7
	}
Return

$Browser_Home::									;2,1
	if (a_thishotkey=a_priorhotkey && a_timesincepriorhotkey<200) {
		send ^f
	}
	else {
		send !f
	}
Return

; ---------- 								HERE ARE JKL 
$k::
	send k
	Keywait, k, t.2
	if errorlevel 
	{
		send !k
	}
return


 
$f13::											;2,5
	send +p
Return

!f13::
^f13::									
	send !p
Return
 
; $f14::											;2,6
	; send ^u
; Return
 
$f15::											;3,1
	keywait, f15, t.2 
	if errorlevel {
		undoscroll:=true
		cursed:=1
		gosub cursing
		tooltip ☻
		}
	else {
			send ^z
		}
return

 
$Media_Stop::									;3,2
	send ^c
Return
 
$Launch_Mail::									;3,3
	send ^x
Return
 
$Launch_Media::									;3,4
	send ^v
Return

!Launch_Media::	
^Launch_Media::									
	send !v
Return
 
$Launch_App1::									;3,5
	send +c
Return
 
>^Launch_App1::	
	send l
return	

; ~RCtrl::
	; Keywait, RCtrl, T.2
	; if errorlevel 
		; {
		; }
	; else 
		; send {space}
	; Keywait, RCtrl
; return
		
; >^WheelDown::
	; send ^!{WheelDown}
; Return

; >^WheelUp::
	; send ^!{WheelUp}
; Return

								; CENTRE DIALS

$Browser_Favorites::								;LR dial
	send !h
Return

$Launch_App2::										;UD dial
	MsgBox, %A_ThisHotkey% was pressed.
Return

>^up::
	send !{up}
return

>^down::
	send !{down}
return


								; BLUE LEFT DIAL
 
$Media_Prev::									
	MsgBox, %A_ThisHotkey% was pressed.
Return

$Media_Next::									
	MsgBox, %A_ThisHotkey% was pressed.
Return
 
$Media_Play_Pause::								
	MsgBox, %A_ThisHotkey% was pressed.
Return


								; RED LEFT DIAL
								
; $Volume_Mute::									
	; MsgBox, %A_ThisHotkey% was pressed.
; Return

; $Volume_Down::									
	; MsgBox, A %A_ThisHotkey% was pressed.
; Return

; $Volume_Up::									
	; MsgBox, %A_ThisHotkey% was pressed.
; Return


								; RED RIGHT DIAL
								
$Browser_Back::									
	send [
Return

$Browser_Forward::								
	send ]
Return

$Browser_Refresh::								
	send ^q
Return



								; BLUE RIGHT DIAL
								
VKE9 up::						;Hanja/kanji 				
	send +[
Return 
					
SC072 up::						;Hangul on Via -  careful this double presses on via once on down, once up
	send +]
Return

SC15E::							;power OSX on Via
	sendraw :
Return 



!PgUp::
+PgUp::
^PgUp::
	Send {f16}
Return

!PgDn::
+PgDn::
^PgDn::
	Send {f19}
Return





$WheelLeft::
	Send ^!{wheelup}
Return

^WheelLeft::
!WheelLeft::
	Send !{home}
Return

$WheelRight::
	Send ^!{wheeldown}
Return

^WheelRight::
!WheelRight::
	Send !{end}
Return


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

SC07D:: 												; 1,3
	; Keywait, SC07D, T.3
	; {
		; if errorlevel 
		; {
			; DllCall("SetCursorPos", "int", XPosition+176, "int", YZoom)
			; click
		; }
	; }
	; Keywait, SC07D
	
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

; SC079:: 												; 2,1
 ; MsgBox, %A_ThisHotkey% was pressed.
; return

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

