#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


#SingleInstance Force

; o o o o o o o o o o o o o o o INITIAL VALUE VARIABLES o o o o o o o o o o o o o o o o 
Coordmode pixel screen
coordmode mouse screen


davinci:= "DaVinci Resolve by Blackmagic Design - 17.1.0 ahk_class Qt5QWindow"


ruler  :=  {edx:0, 	edy:140, cox:600, coy:652, fux:770, fuy:480, fay:0, fay:160, rex:0, rey:780}						;ruler pos
kf     :=  {edx:1990, edy:178, cox:1000, coy:10, fux:1000, fuy:10, fax:1000, fay:10, rex:1000, rey:10}					;keyframe buttons
calpix :=  {mex:700, mey:1140, cutx:820, edx:940, fux:1060, cox:1180, fax:1300, rex:1420} 								;calibrate buttons                  									


cal := 			0											;calibrate - appskey, !f1
pixpicker := 	0											;calibrate - appskey
cursed := 		0											;cursor, g19
scrollmod := 	0											;g7, tweak button modifier
heldf1 := 		0											;timeline ruler
heldf20 :=		0											;switch davinci page
pagescroll :=	0											;!g17 pgup pgdn scroll
wheelarrow :=	0											;!g18 scroll windows
undoscroll :=	0											;g19 undo-redo scroll
highlight :=	0											;g13 color page
xfastscroll :=	0											;pause fastscroll
		

		;FASTSCROLL:
timeout := 	600												; length of a scrolling session. time to accumulate boost. Default: 500. Recommended 400 - 1000.
boost := 	30												; add boost factor. the higher the value, the slower to activate, and accumulate. disabled:0 Default: 20.															
limit := 	60												; maximum number of scrolls sent per click, so doesn't overwhelm (ie max velocity) Default: 60.
distance := 0												; Runtime variables. Do not modify.
vmax := 	1





; o o o o o o o o o o o o o o o FUNCTIONS o o o o o o o o o o o o o o o o 


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



pagecheck(x) {
	Coordmode pixel screen																	
	pixelgetcolor, editbutt, x.edx, x.mey
	pixelgetcolor, cutbutt, x.cutx, x.mey
	if (editbutt="0x000000" || cutbutt="0x000000")
		pagevar := "edit"
	else {
		pixelgetcolor, colorbutt, x.cox, x.mey
		if (colorbutt="0x000000")
			pagevar := "color"
		else {
			pixelgetcolor, fusionbutt, x.fux, x.mey
			if (fusionbutt="0x000000")
			pagevar := "fusion"
			else {
				pixelgetcolor, fairlightbutt, x.fax, x.mey
				if (fairlightbutt="0x000000")
				pagevar := "fairlight"
				else {
					pixelgetcolor, mediabutt, x.mex, x.mey
					if (mediabutt="0x000000")
					pagevar := "media"
					else {
						pixelgetcolor, renderbutt, x.rex, x.mey
						if (renderbutt="0x000000")
						pagevar := "render"
						}
					}
				}
			}
		}
	tooltip % pagevar, x.fux-50, 1,2
	return pagevar
}

yvalruler(pg,ed,col,fus,fair,ren) {														; return current ruler value
	if (pg="edit")
		rule:=ed	
	if (pg="color")
		rule:=col
	if (pg="fusion")
		rule:=fus
	if (pg="fairlight")
		rule:=fair
	if (pg="render")
		rule:=ren
	return rule
}

keyframe(p,ex,ey,cx,cy,fx,fy,frx,fry,rx,ry) {
	if (p="edit")
		keyframe:={x:ex,y:ey}
	else if (p="color")
		keyframe:={x:cx,y:cy}
	else if (p="fusion")
		keyframe:={x:fx,y:fy}
	else if (p="fairlight")
		keyframe:={x:frx,y:fry}
	else if (p="render")
		keyframe:={x:rx,y:ry}
;	msgbox % keyframe.x " " keyframe.y
	
return keyframe
}


; o o o o o o o o o o o o o o o general gosubs, gotos  o o o o o o o o o o o o o o o o o 

overkill:													;sometimes pagecheck fails. this should fix problem 99%. 
	if WinActive("ahk_exe resolve.exe") {
	DllCall("SetCursorPos", "int", 1860, "int", 14) 
	mouseclick
	page := pagecheck(calpix)
	if (page = "") {
		DllCall("SetCursorPos", "int", 1860, "int", 14) 
		mouseclick
		sleep 20
		DllCall("SetCursorPos", "int", 300, "int", 1140) 
		mouseclick
		page := pagecheck(calpix)
		if (page = "") {
			winactivate davinci
			sleep 50
			DllCall("SetCursorPos", "int", 1860, "int", 14) 
			mouseclick
			sleep 50
			DllCall("SetCursorPos", "int", 300, "int", 1140) 
			mouseclick
			page := pagecheck(calpix)
			}
		}
	mousemove 1000,500
	tooltip % page, calpix.fux-50, 1,2
	if (page = "")
		msgbox problem
	}
return

movetoruler:
	if WinActive("Secondary Screen")
		gosub overkill
	Coordmode mouse screen
	Mousegetpos skipx, skipy
	if (page="edit")
		Mousemove skipx, ruler.edy
	else if (page="color") 
		Mousemove ruler.cox, ruler.coy	
	else if (page="fusion")
		Mousemove ruler.fux, ruler.fuy	
	else if (page="fairlight")
		Mousemove skipx, ruler.fay	
	else if (page="render")
		Mousemove skipx, ruler.fuy
Return		

cursing:
    cursed :=!cursed
    If (cursed=0)
    {
        Cursor1 = Red_Pointer.cur
        CursorHandle1 := DllCall("LoadCursorFromFile", Str, Cursor1)
        Cursors = 32512,
        Loop, Parse, Cursors, `, 
        { 
            DllCall("SetSystemCursor", Uint, CursorHandle1, Int, A_Loopfield) 
        }
    }
    Else If (cursed=1)
    {
        SPI_SETCURSORS := 0x57
        DllCall( "SystemParametersInfo", UInt,SPI_SETCURSORS, UInt,0, UInt,0, UInt,0 )
    }
Return

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo


; o o o o o o o o o o o o o o o KEYBOARD STUFF o o o o o o o o o o o o o o o o o o o o o

;-----------------------------------undo button; exists here for scrollmod reasons
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

;-----------------------------------windowspy hold Menu key
$AppsKey::
	p := Morse()
	if WinActive("ahk_exe resolve.exe") {
		If (p = "0") {														; single
			winactivate davinci
			scrollmod := 0
			heldf1:=0
			tooltip
			page := pagecheck(calpix)
			if (page = "") 
				gosub overkill
			}
		Else If (p = "00") { 												; double press
			page := pagecheck(calpix)
			if WinActive("Secondary Screen")
				gosub overkill
			coordmode mouse screen
			mousegetpos startx, starty
			mousemove calpix.mex, calpix.mey
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
			tooltip,,,,2
			; send {appskey}
			}
		Else  																
			run, C:\Program Files\AutoHotkey\WindowSpy.ahk
			
Return

*AppsKey::																			;almost certainly doesn't work. supposed to kill glitchbug
sleep 1000
Send {ctrl up}{shift up}{rwin up}{lwin up}{ralt up}{lalt up}
return

; o o o o o o o o o o o o o o o o o o o VAR GUI o o o o o o o o o o o o o o o o o o o o


!AppsKey::

	rule:= yvalruler(page, ruler.edy, ruler.coy, ruler.fuy, ruler.fay, ruler.rey)
	
	keyframe := keyframe(page, kf.edx, kf.edy, kf.cox, kf.coy, kf.fux, kf.fuy, kf.fax, kf.fay, kfrex, kf.rey)


gui +LastFound +OwnDialogs +AlwaysOnTop
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
; gui, add, text, y+2, % timeout 											
; gui, add, text, y+2, % boost 																									
; gui, add, text, y+2, % limit 												


gui +LastFound +OwnDialogs +AlwaysOnTop


return


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

Scroll:
	if (xfastscroll=0) {
		t := A_TimeSincePriorHotkey
		if (A_PriorHotkey = A_ThisHotkey && t < timeout) {
			distance++													; Remember how many times we've scrolled in the current direction
			v := (t < 80 && t > 1) ? (250.0 / t) - 1 : 1				; Calculate acceleration factor using a 1/x curve
			if (boost > 1 && distance > boost) {						; Apply boost
				if (v > vmax)											; Hold onto the highest speed we've achieved during this boost
					vmax := v
				else
					v := vmax
				v *= distance / boost
				}
			v := (v > 1) ? ((v > limit) ? limit : Floor(v)) : 1			; Validate

			MouseClick, %A_ThisHotkey%, , , v
			}
		else  {
			distance := 0												; Combo broken, so reset session variables
			vmax := 1
			MouseClick %A_ThisHotkey%
			}
		}
	else  {
	distance := 0												; Combo broken, so reset session variables
	vmax := 1
	MouseClick %A_ThisHotkey%
	}
return

+^0::
	keywait, 0, t.3
	if errorlevel {												; reset fastscroll
		scrollmod=:0
		heldf1:=0
		heldf20:=0
		pagescroll:=0
		wheelarrow:=0
		undoscroll:=0
		cursed:=0
		distance:=0												; Runtime variable
		vmax:= 1												; Runtime variable
		t:=0
		v:=0
		xfastscroll:=0
		tooltip RESET
		}
	else{
		xfastscroll:=(xfastscroll-1)**2									; pause unpause
		if (xfastscroll=1)
			tooltip ■												
		else 
			tooltip ▶													;play ►
			}
	sleep 500
	tooltip
return





#if


;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo






;------------------------------------------------------------						|  x  888 888 888
;------------------------------------------------------------						|  x  888 888 888
;------------------------------------------------------------						|  x  888 888 888
;------------------------------------------------------------						|  x  888 888 888



;------------------------------------------------------------ g9 mouse: new tab in chrome, new sheet in Notepad++ 
;------------------------------------------------------------ double press for Razor blade tool



$f1::
	if WinActive("ahk_exe chrome.exe") {
		Sendinput ^t
		}
	else if WinActive("ahk_exe resolve.exe") {
		send {f1}
		Keywait, f1, t0.3
			if errorlevel {	
				Coordmode mouse screen
				Mousegetpos skipx, skipy
				if WinActive("Secondary Screen")
					gosub overkill
				if (page="edit" or page="")
					Mousemove skipx, ruler.edy
				else if (page="color") 
					Mousemove ruler.cox, ruler.coy	
				else if (page="fusion")
					Mousemove ruler.fux, ruler.fuy	
				else if (page="fairlight")
					Mousemove skipx, ruler.fay	
				else if (page="render")
					Mousemove skipx, ruler.rey							
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
		mousegetpos skippedx, skippedy
		if (page="edit")
			Mousemove, skippedx, skipy
		else
			Mousemove, skipx, skipy
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



;------------------------------------------------------------ !g9 mouse: cycle back tab 

$^!f1::
	if WinActive("ahk_exe Resolve.exe") {
		pixpicker := true
		i:=2
		mousegetpos startx, starty
		gosub movetoruler
		tooltip -- PIXPICKER --
	}
Return

$!f1::
	if WinActive("ahk_exe Resolve.exe") 
		{
		pixpicker := true
		cal:=2
		mousegetpos startx, starty
		gosub movetoruler
		tooltip -- PIXPICKER --
		}
	else
		Sendinput ^w
Return


;------------------------------------------------------------ g10 mouse: selects title bar in chrome, up one folder windows exp
$f20::
	if WinActive("ahk_exe chrome.exe") 
		Sendinput {f6}
	else if WinActive("ahk_exe explorer.exe") 
		Sendinput !{up}
	else if WinActive("ahk_exe resolve.exe") {
			Sendinput {f20}									; up to here we're safe
			Keywait, f20, t0.3
			if errorlevel {
				if WinActive("Secondary Screen")
					gosub overkill
				Coordmode mouse screen
				Mousegetpos skipx, skipy
				Mousemove calpix.fax, calpix.mey		
				heldf20 := 1
				choosepage:=true
				buttonskipper := (calpix.rex - calpix.mex)/6
				}
			Keywait f20
			}
	
Return

f20 up::
	if WinActive("ahk_exe resolve.exe") {
		if (heldf20=1) {
			MouseClick 
			mouseclick,,1000,3
			Mousemove, skipx, skipy
			heldf20:=0
			choosepage:=false
			sleep 200
			page := pagecheck(calpix)
			sleep 800
			page := pagecheck(calpix)
			if (page = "") 
				gosub overkill 
			}
		}
return	


;------------------------------------------------------------G11 mouse: Launch Resolve / switch to Edit page
;------------------------------------------------------------long press for blade tool
$f21::
	If !WinActive("ahk_exe Resolve.exe") {
		keywait, f21, t.2
		if errorlevel {
			IfWinNotExist, ahk_exe Resolve.exe
				Run, C:\Program Files\Blackmagic Design\DaVinci Resolve\Resolve.exe
			else
				WinActivate ahk_exe Resolve.exe
				heldf21:=2
			}
		else
			send ^f
		keywait, f21
		}
	if WinActive("ahk_exe Resolve.exe") {
		keywait, f21, t.2
		send +q 
		sleep 10
		send +3
		if errorlevel {
			heldf21:=1
			}
		keywait f21
		page := "edit"
		coordmode tooltip screen
		tooltip % page, calpix.fux-50, 1, 2
		}
Return

f21 up::
	if (heldf21=1) {
		Send {f1}
		heldf21:=0
		}
	else if (heldf21=2) {
		sleep 300
		heldf21:=0
		}
return	


;------------------------------------------------------------ !G11 mouse: Resolve switch to Edit page / otherwise cycle back tab 
$!f21::
	if WinActive("ahk_exe Resolve.exe") {
		Sendinput +4
		page := "color"
		coordmode tooltip screen
		tooltip % page, calpix.fux-50, 1, 2
		}
	else
		Sendinput ^{tab}
Return


;------------------------------------------------------------						888  x  888 888
;------------------------------------------------------------						888  x  888 888
;------------------------------------------------------------						888  x  888 888
;------------------------------------------------------------						888  x  888 888



;------------------------------------------------------------ g12: back
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
	else if (WinActive("ahk_exe chrome.exe") || WinActive("ahk_exe explorer.exe")) 
			Sendinput !{left}
Return



;------------------------------------------------------------ !G12 add keyframe
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

;------------------------------------------------------------ g13: reload
$f23::
	if WinActive("ahk_exe Resolve.exe") {
		Sendinput {f23}
		 keywait, f23, t.3
		 if errorlevel {
			 highlight:=1
			 tooltip bam
			 }
		 keywait f23
		 }
	else {
		  if ((A_PriorHotkey = "f23 up" || A_PriorHotkey = "$f22") && A_TimeSincePriorHotkey < 500) {			
			if WinActive("ahk_exe Notepad++.exe") 
				Send {enter}
			else
				Sendinput {esc}
			}
		else {
			if WinActive("ahk_exe Notepad++.exe") {
				send ^s
				sleep 30
				Send {f5}
				}
			else
				Sendinput ^{f5}	
			}
		}	
Return

	
f23 up::
	if (highlight=1)
		send {f23}
	highlight:=0
	tooltip
Return

;------------------------------------------------------------ g14: forward
$f24::
	if WinActive("ahk_exe Resolve.exe") 
		Sendinput {f24}
	else if WinActive("ahk_exe notepad++.exe")	
		sendinput ^q
	else 
		Sendinput !{right}
Return

;------------------------------------------------------------ !G14 close tab
$!f24::
	if WinActive("ahk_exe chrome.exe")
		Sendinput l
	Else
		Sendinput !{f24}
Return


;------------------------------------------------------------						888 888  x  888
;------------------------------------------------------------						888 888  x  888
;------------------------------------------------------------						888 888  x  888
;------------------------------------------------------------						888 888  x  888


;------------------------------------------------------------ G15:ctrl
;------------------------------------------------------------ G16:shift





;------------------------------------------------------------ G17 speedy scroll




#if !WinActive("ahk_exe Resolve.exe")								;still horrible - Ralt does not play ball. pgup,dn often want to switch tabs

^Ralt::
	if !WinActive("ahk_exe Resolve.exe") {
	send {ralt down}
	pagescroll:=true
	tooltip ▲`n▼
	}
Return

#if pagescroll

^!WheelUp::
		Send {pgup}
Return

^!WheelDown::
		Send {pgdn}
Return


^Ralt up::
	send {ralt up}
	pagescroll:=false
	tooltip
Return

#if

;------------------------------------------------------------ !G17



;------------------------------------------------------------						888 888 888  x   |
;------------------------------------------------------------						888 888 888  x   |
;------------------------------------------------------------						888 888 888  x   |
;------------------------------------------------------------						888 888 888  x   |



;------------------------------------------------------------ G18: click:start; long click:show desktop
;------------------------------------------------------------ !G18: !click:scroll through windows;  long !click: see available windows    

rwin::
	keywait, rwin, t.3
		if errorlevel
			send #{d}
		else
			Send {rwin}
	keywait rwin
return

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

;------------------------------------------------------------ G19:see open windows


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


;------------------------------------------------------------ G20 mouse launch Explorer / cycle Explorer tabs

Ins:: 
	p := Morse()
	; DetectHiddenWindows On  ; Allows a script's hidden main window to be detected.
	; SetTitleMatchMode 2  ; Avoids the need to specify the full path of the file below.
	; PostMessage, 0x0111, 65303,,, fastscroll.ahk - AutoHotkey
	If (p = "0"){
		IfWinNotExist, ahk_class CabinetWClass 
			Run, explorer.exe
		
		if WinActive("ahk_exe explorer.exe") 
			Sendinput ^{tab}
			
		else {
			WinActivatebottom ahk_class CabinetWClass 
			Sleep 10
			WinActivate explorer.exe
			}
		}
	Else If (p = "00") { 						; double press
		SetTitleMatchMode 2
		; If WinActive("WinTitle ahk_class WinClass", "WinText", "ExcludeTitle", "ExcludeText")
		IfWinNotExist OneNote for Windows 10 ahk_class ApplicationFrameWindow
			Run, %A_Desktop%\OneNote.lnk
		
		else if WinActive("OneNote for Windows 10 ahk_class ApplicationFrameWindow")
			Sendinput hello
		else
			WinActivate OneNote for Windows 10 ahk_class ApplicationFrameWindow
		}
	Else If (p = "01") 							; short + long presses
		{}												
		
	Else {										; long press
		IfWinNotExist, ahk_exe notepad++.exe
			Run, notepad++.exe
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
		Sendinput ^{tab}
	else
		WinActivate ahk_exe chrome.exe
Return



;------------------------------------------------------------							888°888888
;------------------------------------------------------------							888   °888
;------------------------------------------------------------							888   .o88
;------------------------------------------------------------							888.o88888

;---------------------------------------------------------- mouse wheel L,R
$home::
if !WinActive("ahk_exe resolve.exe") 						
	Sendinput {Media_Prev}
else 
	Send {home}
Return
	
$end::
if !WinActive("ahk_exe resolve.exe")
	Sendinput {Media_Next}
else 
	Send {end}
Return	


<!<^0::
	sendinput {Media_Play_Pause}
return


;  ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
;  ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
;  ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo

; o o o o o o o o o o o o o o o TWEAK BUTTON MODIFIER o o o o o o o o o o o o o o o

Scrolllock::
	if WinActive("ahk_exe chrome.exe") 
		Sendinput {f11}
	else {
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
	}
Return

!Scrolllock::
	Send {Alt down}{LButton}{alt up}
	Sleep 500
	Send {Lbutton down}
	scrollmod := 2
	tooltip ▲`n▼	
Return


; Ralt & q::														; WHAT IS ALL THIS???? thumbpad 8way. Delete??
	; if (scrollmod>=1)
	; mousemove, -5,-5,,R
	; sleep 10
; return

; Ralt & e::
	; if (scrollmod>=1)
	; mousemove, 5,-5,,R
	; sleep 10
; return

; Ralt & z::
	; if (scrollmod>=1)
	; mousemove, -5,5,,R
	; sleep 10
; return

; Ralt & c::
	; if (scrollmod>=1)
	; mousemove, 5,5,,R
	; sleep 10
; return

$up::
	if (scrollmod>=1) {
		mousemove, 0,-5,,R
		sleep 10
		}
	else
		Send {up}
return

$down::
	if (scrollmod>=1) {
		mousemove, 0,5,,R
		sleep 10
		}
	else
		Send {down}
return

$left::
	if (scrollmod>=1) {
		mousemove, -5,0,,R
		sleep 10
		}
	else
		Send {left}
return

$right::
	if (scrollmod>=1) {
		mousemove, 5,0,,R
		sleep 10
		}
	else
		Send {right}
return



$wheelup::
	If (scrollmod = 1)
	mousemove, -1,0,,R 
	else if (scrollmod = 2)
	mousemove, 0,-1,,R
	else
	send {wheelup}
Return

$^wheelup::
	If (scrollmod = 1)
	mousemove, -8,0,,R 
	else if (scrollmod = 2)
	mousemove, 0,-8,,R
	Else
	send ^{wheelup}
Return

		

$+wheelup::
	if WinActive("ahk_exe resolve.exe") {
	If (scrollmod = 1)
	mousemove, -30,0,,R 
	else if (scrollmod = 2)
	mousemove, 0,-30,,R
	Else
	send +{wheelup}
	}
	else if WinActive("ahk_exe chrome.exe")
		Sendinput +{Wheelup}
	else
		send {wheelleft}
Return

$wheeldown::
	If (scrollmod = 1)
	mousemove, 1,0,,R 
	else if (scrollmod = 2)
	mousemove, 0,1,,R
	Else
	send {wheeldown}
Return

$^wheeldown::
	If (scrollmod = 1)
	mousemove, 8,0,,R 
	else if (scrollmod = 2)
	mousemove, 0,8,,R
	else if (wheelarrow = 1)
	send {right}
	else
	send ^{wheeldown}
Return


$+wheeldown::
	if WinActive("ahk_exe resolve.exe")
	{
	If (scrollmod = 1)
	mousemove, 30,0,,R 
	else if (scrollmod = 2)
	mousemove, 0,30,,R
	Else
	send +{wheeldown}
	}
	else if WinActive("ahk_exe chrome.exe")
		Sendinput +{Wheeldown}
	else
		send {wheelright}
Return

~Lbutton::                      ; release TWEAK
	if (scrollmod!=0) {
		Scrollmod :=0
		tooltip 
		}
Return



;------------------------------------------------------------ Alt wheel skips ahead youtube

$!WheelDown::
	if WinActive("ahk_exe chrome.exe") 
		Sendinput {right}
	else if WinActive("ahk_exe spotify.exe")
		send +{right}
	else
		Sendinput !{WheelDown}
Return

$!WheelUp::
	if WinActive("ahk_exe chrome.exe") 
		Sendinput {left}
	else if WinActive("ahk_exe spotify.exe")
		send +{left}	
	else
		Sendinput !{WheelUp}
Return




; o o o o o o o o o o o o o o o o o o o CALIBRATE PIXPICKER o o o o o o o o o o o o o o o o 

#if pixpicker


Mbutton::
	coordmode pixel screen											; screen coordinates
	coordmode mouse screen
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
		mousemove startx, starty	
		sleep 500
		tooltip
		}
return

~lbutton::															; any L mouseclick exits recalibration
pixpicker := false
tooltip
return

#if

; o o o o o o o o o o o o o o o o o o o CHOOSE PAGE RESOLVE o o o o o o o o o o o o o o o o 

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

; o o o o o o o o o o o o o o o o o o o CHOOSE PAGE RESOLVE o o o o o o o o o o o o o o o o 

#if keyfredit

Mbutton::
	Coordmode pixel screen											; screen coordinates
	coordmode mouse screen
	Mousegetpos, x, y		; set edit timeline ruler position
	if (page="edit") {
		kf.edx:=x
		kf.edy:=y
		}
	else if (page="color") {
		kf.cox:=x
		kf.coy:=y
		}
	else if (page="fusion")	 {
		kf.fux:=x
		kf.fuy:=y
		}
	else if (page="fairlight") {
		kf.fax:=x
		kf.fay:=y
		}
	else if (page="render") {
		kf.rex:=x
		kf.rey:=y
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

