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

; dontrungosubs() {
; return
; }

; ; o o o o o o o o o o o o o         GOSUB        GOTO        o o o o o o o o o o o o o o o o o 


; underkill:													;be careful with this - can bug up overkill for some reason
	; if WinActive("ahk_exe resolve.exe") {
	; SetTitleMatchMode 2
	; WinActivate %davinci%
	; page:=pagecheck(calpix)
	; coordmode tooltip screen
	; tooltip % page, calpix.fux-50, 1, 2
	; }
; return


; overkill:													;sometimes pagecheck fails. this should fix problem 99%. 
	; if WinActive("ahk_exe resolve.exe") {
	; DllCall("SetCursorPos", "int", 1860, "int", 14) 
	; mouseclick
	; page := pagecheck(calpix)
	; if (page = "") {
		; DllCall("SetCursorPos", "int", 1860, "int", 14) 
		; mouseclick
		; sleep 20
		; DllCall("SetCursorPos", "int", 300, "int", 1140) 
		; mouseclick
		; page := pagecheck(calpix)
		; if (page = "") {
			; winactivate davinci
			; sleep 50
			; DllCall("SetCursorPos", "int", 1860, "int", 14) 
			; mouseclick
			; sleep 50
			; DllCall("SetCursorPos", "int", 300, "int", 1140) 
			; mouseclick
			; page := pagecheck(calpix)
			; }
		; }
	; mousemove 1000,500
	; tooltip % page, calpix.fux-50, 1,2
	; if (page = "")
		; msgbox problem
	; }
; return


; Scroll:															; FASTSCROLL
	; if (xfastscroll=0) {
		; t := A_TimeSincePriorHotkey
		; if (A_PriorHotkey = A_ThisHotkey && t < timeout) {
			; distance++													; Remember # of scrolls in current direction
			; v := (t < 80 && t > 1) ? (250.0 / t) - 1 : 1				; Calculate acceleration using a 1/x curve
			; if (boost > 1 && distance > boost) {						; Apply boost
				; if (v > vmax)											; Hold top speed  achieved during this boost
					; vmax := v
				; else
					; v := vmax
				; v *= distance / boost
				; }
			; v := (v > 1) ? ((v > limit) ? limit : Floor(v)) : 1			; Validate

			; MouseClick, %A_ThisHotkey%, , , v
			; }
		; else  {
			; distance := 0												; Combo broken, so reset session variables
			; vmax := 1
			; MouseClick %A_ThisHotkey%
			; }
		; }
	; else  {
	; distance := 0												; Combo broken, so reset session variables
	; vmax := 1
	; MouseClick %A_ThisHotkey%
	; }
; return


; movetoruler:
	; skip := GetCursorPos()													;like mousegetpos - DLL get+setcursorpos less buggy than native ahk
	; if (skip.x>2046)
		; DllCall("SetCursorPos", "int", 10, "int", 54) 						;setcursorpos doesn't work properly from second screen
	; if (page="edit" or page="") { 
		; if (skip.x>2046)
			; DllCall("SetCursorPos", "int", 1110, "int", ruler.edy) 			;dllcalls set on 27.04.21 - revert to earlier for mousemove
		; else	
			; DllCall("SetCursorPos", "int", skip.x, "int", ruler.edy)
		; }
	; else if (page="color") 
		; DllCall("SetCursorPos", "int", ruler.cox, "int", ruler.coy)
	; else if (page="fusion")
		; DllCall("SetCursorPos", "int", ruler.fux, "int", ruler.fuy)
	; else if (page="fairlight")
		; DllCall("SetCursorPos", "int", skip.x, "int", ruler.fay)
	; else if (page="render")
		; DllCall("SetCursorPos", "int", skip.x, "int", ruler.rey)		
; return


; cursing:														;  cursor change
    ; cursed :=!cursed
    ; If (cursed=0)
    ; {
        ; Cursor1 = Red_Pointer.cur
        ; CursorHandle1 := DllCall("LoadCursorFromFile", Str, Cursor1)
        ; Cursors = 32512,
        ; Loop, Parse, Cursors, `, 
        ; { 
            ; DllCall("SetSystemCursor", Uint, CursorHandle1, Int, A_Loopfield) 
        ; }
    ; }
    ; Else If (cursed=1)
    ; {
        ; SPI_SETCURSORS := 0x57
        ; DllCall( "SystemParametersInfo", UInt,SPI_SETCURSORS, UInt,0, UInt,0, UInt,0 )
    ; }
; Return


; StateYourCase:													;  *Capslock mod
	; If (A_ThisMenuItem = "Title") { 
		; StringLower text, text, T   ; Title case
		; }
	; Else If (A_ThisMenuItem = "Upper") { ;       
		; StringUpper text, text ; UpperCase
		; }
	; Else { ;       
		; StringLower text, text ; LowerCase
		; }
	; Clipboard := text
	; ClipWait 1
	; Send ^v
; Return 



; Qboxes:	
	; Box_Init()
	; Gui, 96: Show, % "x" q.x-10 " y" q.y-10 " w" 20 " h" 20 " NA", Horizontal 1
	; Gui, 97: Show, % "x" w.x-10 " y" w.y-10 " w" 20 " h" 20 " NA", Vertical 2
	; Gui, 98: Show, % "x" e.x-10 " y" e.y-10 " w" 20 " h" 20 " NA", Horizontal 2
	; Gui, 99: Show, % "x" r.x-10 " y" r.y-10 " w" 20 " h" 20 " NA", Vertical 2
	; sleep 1000
; Return		
		

; Qpix:
	; key:=A_ThisHotKey
	; dif:=(A_tickcount-start)
	; if (dif > 300){
		; start:=A_TickCount
		; skip := GetCursorPos()
		; DllCall("SetCursorPos", "int", %key%.x, "int",%key%.y)
		; scrollmod:=1
		; Send {LButton down}
		; Box_Centre(%key%.x, %key%.y, 30, 20, 2, 0)
		; Keywait %key%
			; {
			; scrollmod:=0
			; Send {LButton up}
			; DllCall("SetCursorPos", "int", skip.x, "int", skip.y)
			; Box_Hide()
			; Gui, 96: Show, % "x" 1100 " y" 0 " w" 70 " h" 20 " NA"
			; }
		; }	
	; else {
		; DllCall("SetCursorPos", "int", %key%.x, "int",%key%.y)
		; Send {LButton 2}
		; DllCall("SetCursorPos", "int", skip.x, "int", skip.y)
		; Keywait %key% 
		; }
; return

; Qmove:
	; Send {LButton up}
	; dif:=(A_tickcount-start)
	; if (dif > 2000)
		; skip := GetCursorPos()
	; DllCall("SetCursorPos", "int", %key%.x, "int",%key%.y)
	; SetBatchLines, -1
	; SetWinDelay, -1
	; Loop {
		; newpos := GetCursorPos()
		; %key%.x := newpos.x, %key%.y := newpos.y
		; Box_Centre(%key%.x, %key%.y, 20, 20, 2, 1)
		; altstate := getkeystate("alt", p)
		; if (altstate=0) {
			; Box_Centre(%key%.x, %key%.y, 20, 20, 2, 1)
			; DllCall("SetCursorPos", "int", skip.x, "int",skip.y)
			; sleep 300
			; Box_Hide()
			; Gui, 96: Show, % "x" 1100 " y" 0 " w" 70 " h" 20 " NA"
			; break
			; }
	   ; }
	; Keywait %key%
; Return




;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo


; o o o o o o o o o o o o o o o KEYBOARD STUFF o o o o o o o o o o o o o o o o o o o o o

;----------------------------------- lock window on top

^space:: Winset, Alwaysontop, , A 
Return

;----------------------------------- plain text paste, file path

!^v::
	send % clipboard
return

;----------------------------------- brackets, quotes - Alt GR modifier

~!^[::
	SetTitleMatchMode, 2														; launch brackets altgr script
	DetectHiddenWindows, On
	If !WinExist("brackets_altgr.ahk" . " ahk_class AutoHotkey")
		Run, C:\Users\tomba\OneDrive\Desktop\AutoHotKey\brackets_altgr.ahk
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



;------------------------------------- transparent

!^Appskey::
	winget, trans, transparent, a
	if (trans="")
		Winset, Transparent, 128, A
	else
		Winset, Transparent, OFF, A
Return


;-------------------------------------Qmode

$\::
	if Winactive("ahk_exe resolve.exe") {
	Keywait, \, t0.3
	if errorlevel {
		gosub Qboxes
		keywait \
		Box_Hide()
		Gui, 96: Show, % "x" 1100 " y" 0 " w" 70 " h" 20 " NA"
		}
	else {
		Qmode:= (1-Qmode)**2
		if (Qmode=1){
			gosub Qboxes
			Box_Hide()
			Gui, 96: Show, % "x" 1080 " y" 0 " w" 70 " h" 20 " NA", Qbox
			}
		else {
		Box_Destroy()
		}
	}
	if (Qmode=0)
		Box_Destroy()
		}
	else 
		send \
Return

$+\::
	if Winactive("ahk_exe resolve.exe") {
		Box_Destroy()
		; Gui, 94: destroy
		gosub Qreset
		Qmode:=0
		}
	else 
		send +\
Return


;-----------------------------------windowspy hold Menu key

$AppsKey::
	p := Morse()
	if WinActive("ahk_exe resolve.exe") {
		If (p = "0") {														; single
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
		Else If (p = "00") { 												; double press
			page := pagecheck(calpix)
			if WinActive("Secondary Screen")
				gosub overkill
			start := GetCursorPos()											;still works with slightly buggy mousemove etc... but works 99%+
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


#delete::
	send {insert}
Return


; o o o o o o o o o o o o o o o o o o o VAR GUI o o o o o o o o o o o o o o o o o o o o


!AppsKey::

	rule:= yvalruler(page, ruler.edy, ruler.coy, ruler.fuy, ruler.fay, ruler.rey)
	
	keyframe := keyframe(page, kf.edx, kf.edy, kf.cox, kf.coy, kf.fux, kf.fuy, kf.fax, kf.fay, kfrex, kf.rey)


Gui, new, ,VAR																			;
gui, show, w274 h370 ,																	; makes gui exist + size, if wanna add position, can add x y before size
gui, color, 292928,																		; background
gui, font, cBABABA																		; overall font style, cHEX color
gui, add, text, x10 y10, % "page calibration:"
gui, font, w600
gui, add, text, x100 y10, % page
gui, font, w400
gui, add, text, x150 y10, % "ruler y val:"
gui, font, w600
gui, add, text, x230 y10, % rule
gui, font, w400
Gui, Add, GroupBox, x10 y+6 w120 h130, calpix												; adds box 
gui, add, text, x20 y46, % "media:	 " calpix.mex " 	" calpix.mey		; first line of text at x,y
gui, add, text, y+2, % "cut:	 " calpix.cutx									
gui, add, text, y+2, % "edit:	 " calpix.edx 									
gui, add, text, y+2, % "fusion:	" calpix.fux
gui, add, text, y+2, % "color:	" calpix.cox
gui, add, text, y+2, % "fairlight:	" calpix.fax
gui, add, text, y+2, % "render:	" calpix.rex " 	" calpix.mey
Gui, Add, GroupBox, x+20 y29 w120 h130, rulers
gui, add, text, x152 y46, % "media:	 	  -" 		
gui, add, text, y+2, % "cut:	 	  -" 							
gui, add, text, y+2, % "edit:		" ruler.edy							
gui, add, text, y+2, % "fusion:	     " ruler.fux "	"ruler.fuy
gui, add, text, y+2, % "color:	     " ruler.cox "	"ruler.coy
gui, add, text, y+2, % "fairlight:		" ruler.fay
gui, add, text, y+2, % "render:		" ruler.rey
gui, font, w600
gui, add, text, x10 y170, % "keyframe:	" keyframe.x "	" keyframe.y
gui, font, w400
Gui, Add, GroupBox,  y+6 w120 h130, keyframe buttons
gui, add, text, x20 y210, % "media:	    	- "
gui, add, text, y+2, % "cut:	    	- "
gui, add, text, y+2, % "edit:	     " kf.edx "	" kf.edy	
gui, add, text, y+2, % "fusion:	     " kf.fux "	" kf.fuy
gui, add, text, y+2, % "color:	     " kf.cox "	" kf.coy
gui, add, text, y+2, % "fairlight:	     " kf.fax "	" kf.fay
gui, add, text, y+2, % "render:	     " kf.rex "	" kf.rey
gui, add, text, x152 y180, % "scrollmod: " scrollmod
gui, add, text, y+2, % "heldf1: " heldf1
gui, add, text, y+2, % "cursed: " cursed
gui, add, text, y+2, % "heldf20: " heldf20
gui, add, text, y+2, % "pagescroll: " pagescroll
gui, add, text, y+2, % "wheelarrow: " wheelarrow
gui, add, text, y+2, % "undoscroll: " undoscroll
gui, add, text, y+2, % "highlight: " highlight
gui, add, text, y+2, % "distance: " distance 											
gui, add, text, y+2, % "vmax: " vmax 
Gui, Add, Button, x100 y+20 Default w80 gKillVAR, OK
gui +LastFound +OwnDialogs +AlwaysOnTop -caption
return

KillVAR:
	Gui destroy
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


#if !WinActive("ahk_exe Resolve.exe")

Process, Priority, , H

WheelUp::  
	if (cursed=0 && scrollmod=0 && heldf1=0 && heldf20=0 && pagescroll=0 && wheelarrow=0 && undoscroll=0 && cursed=0)
		Goto Scroll
	else 
		Send {wheelup}
return
  
WheelDown::  
	if (cursed=0 && scrollmod=0 && heldf1=0 && heldf20=0 && pagescroll=0 && wheelarrow=0 && undoscroll=0 && cursed=0)
		Goto Scroll
	else 
		Send {wheeldown}
return



+^0::
	keywait, 0, t.3												; 
	if errorlevel {		
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
		xfastscroll:=0
		tooltip RESET
		}
	else{
		xfastscroll:=(xfastscroll-1)**2					; pause unpause
		if (xfastscroll=1)
			tooltip ■												
		else 
			tooltip ▶									;play ►
			}
	sleep 500
	tooltip
return


#if


;-------------------------------------------------------	 ! Wheel 			skips ahead youtube

$!WheelUp::
	if WinActive("ahk_exe chrome.exe") 
		Sendinput {up}
	else if WinActive("ahk_exe spotify.exe")
		send +{left}	
	else
		Sendinput !{WheelUp}
Return


$!WheelDown::
	if WinActive("ahk_exe chrome.exe") 
		Sendinput {down}
	else if WinActive("ahk_exe spotify.exe")
		send +{right}
	else
		Sendinput !{WheelDown}
Return


;----------------------------------------------------		+ Wheel


$+wheelup::
	if WinActive("ahk_exe resolve.exe") 
		send +{wheelup}
	else if WinActive("ahk_exe chrome.exe") 
		send +{wheelup}
	else
		send {wheelleft}
Return


$+wheeldown::
	if WinActive("ahk_exe resolve.exe")
		send +{wheeldown}
	else if WinActive("ahk_exe chrome.exe") 
		send +{wheeldown}
	else
		send {wheelright}
Return


;----------------------------------------------------		^ Wheel - still unused in most pages in resolve!
 	
; $^wheelup::
	; if WinActive("ahk_exe resolve.exe" && page=edit)
; Return

; $^wheeldown::
	; if WinActive("ahk_exe resolve.exe" && page=edit)
; Return

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
	send ^1
return

$end::
	keywait end, t.3
	
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
	send ^2
return

<!<^0::
	sendinput {Media_Play_Pause}
return


; o o o o o o o o o o o o o o o        SCROLLMOD        	G7       o o o o o o o o o o o o o o o

Scrolllock::
	if (A_thishotkey!=A_priorhotkey || A_timesincepriorhotkey>300) {
		if (heldf21!=1)					;g11 trick: get rid of the click
			Send {Lbutton down}
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



;--------------------------------------------------------	g9    mouse: new tab in chrome, new sheet in Notepad++ 

;------------------------------------------------------------     double press for Razor blade tool



$f1::
	if WinActive("ahk_exe chrome.exe") {
		Sendinput ^t
		}
	else if WinActive("ahk_exe resolve.exe") {
		send {f1}
		Keywait, f1, t0.3
			if errorlevel {		
				gosub movetoruler		
				Send {lbutton down}
				heldf1 := 1
				scrollmod := 1
				mousegetpos x,y
				tooltip ◀ ◈ ▶, x-24, y+12				; ◀ ◈ ▶      or  ◀ ◆ ▶ ?
				}
		keywait f1
		}
	else {
		keywait f1		;don't open a million tabs
		Sendinput ^n
		}
Return

f1 up::
	if (heldf1=1) {
		Send {Lbutton up}
		if (page="edit") {
			mousegetpos skippedx, skippedy
			Mousemove, skippedx, skip.y
			}
		else 
			if (page="color") {
			mousegetpos skippedx, skippedy
			ruler.cox := skippedx
			}
		Mousemove, skip.x, skip.y
		scrollmod := 0
		heldf1:=0
		tooltip
		}
return	


#if !WinActive("ahk_exe resolve.exe")

f1 & WheelUp::
	if WinActive("ahk_exe explorer.exe")
		Send ^+{tab}
	else	
		Send ^{PgUp}
Return

f1 & WheelDown::
	if WinActive("ahk_exe explorer.exe")
		Send ^+{tab}
	else
		Send ^{PgDn}
Return

#if



;-------------------------------------------------------	!g9    mouse: cycle back tab 

$^!f1::
	if WinActive("ahk_exe Resolve.exe") {
		pixpicker := true
		i:=2
		start := GetCursorPos()
		gosub movetoruler
		tooltip -- PIXPICKER --
	}
Return

$!f1::
	if WinActive("ahk_exe Resolve.exe") 
		{
		pixpicker := true
		cal:=2
		start := GetCursorPos()
		gosub movetoruler
		tooltip -- PIXPICKER --
		}
	else
		Sendinput ^w
Return


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
			}
		}
return	

;-------------------------------------------------------	!g10    cycle color tools

$!f20::
	if WinActive("ahk_exe resolve.exe") {
		if (page:="color"){
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
					}
				}
			else 	
				send ^f														;find 
			keywait, f21
			}
		}
	else if WinActive("ahk_exe Resolve.exe") {
		keywait, f21, t.2
		send +q 
		sleep 10
		send +3
		if errorlevel {
			heldf21:=1
			}
		keywait f21
		page := "edit"
		SetTitleMatchMode 2
		sleep 100
		WinActivate %davinci%
		coordmode tooltip screen
		tooltip % page, calpix.fux-50, 1, 2
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

;-----------------------------------------------------		g13      reload

$f23::
	if WinActive("ahk_exe Resolve.exe") {
		send {f12}
		Sendinput {f23}
		keywait, f23, t.3
			if errorlevel {
				Send {f12}
				highlight:=1
				tooltip bam
				}
			sleep 1000
			send {esc}
		 keywait f23
		 }
	else {
		  if ((A_PriorHotkey = "f23 up" || A_PriorHotkey = "$f22") && A_TimeSincePriorHotkey < 500) {			
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
	tooltip  
	sleep 1000
	send {esc}
	}
Return

;----------------------------------------------------		g14    forward

$f24::
	if WinActive("ahk_exe Resolve.exe") {
		send {f12}
		Sendinput {f24}
		sleep 1000
		send {esc}
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



;------------------------------------------------------		g18  	 click:start; long click:show desktop

rwin::
	keywait, rwin, t.3
		if errorlevel
			send #{d}
		else
			Send {rwin}
	keywait rwin
return


;------------------------------------------------------		!g18	 !click:scroll through windows;  long !click: see available windows    

$!rwin::
	Send !#{tab}
	wheelarrow:=true
	tooltip WIN		
	keywait, rwin, t.3		
	if errorlevel
		send #{tab}
	keywait rwin
Return

^rwin::
	send !{f4}
return

#if wheelarrow

!wheelup::
	send {alt down}{left}
return
	
	
!wheeldown::
	send {alt down}{right}
return
	
alt up::
	wheelarrow:=false
	tooltip
return

~lbutton::											;scaramanzia
	wheelarrow:=false
	tooltip
return

#if

;----------------------------------------------------		g19 		see open windows


>^c::
	keywait, c, t.2 
	if errorlevel {
		undoscroll:=true
		cursed:=1
		gosub cursing
		tooltip ☻
		}
	else if (A_priorhotkey= ">^c" && A_timesincepriorhotkey < 400)
		send ^x
	else
		send ^c
	keywait c
return


>^!c::
	if WinActive("ahk_exe resolve.exe")
		send ^v
	else {
		keywait, alt, t.5
		if errorlevel
			send #v
		else 
			send ^v
	}
return


#if undoscroll

c & wheelup::
	send ^z
return

c & wheeldown::
	send ^y
return

>^c up::
	tooltip
	undoscroll:=false
	gosub cursing
	cursed:=0
return

lbutton::
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


; o o o o o o o o o o o o o o o TWEAK SCROLLMOD o o o o o o o o o o o o o o o

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
  

    


;-----------------------------------G01  -  Buggy with modifiers for some reason...
	
$Backspace::
	if WinActive("ahk_exe resolve.exe") {
	KeyWait, backspace, T.07
	If ErrorLevel {
		sleepadd++											;equation to machinegun bs faster upon holding. still too slow... what holds it back? t0.7! fix with gosub??
		sleepvar := 100/(sleepadd*sleepadd)
		tooltip % sleepvar
		Send {backspace}
		Sleep % sleepvar
		}
	}
	else 
		send {backspace}
	
Return

Backspace up::
	if WinActive("ahk_exe resolve.exe") {
	KeyWait, backspace
	sleepadd := 0
	Sleep 100
	tooltip
	}
return

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


