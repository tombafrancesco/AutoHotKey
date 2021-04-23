#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


#SingleInstance Force

; o o o o o o o o o o o o o o o INITIAL VALUE VARIABLES o o o o o o o o o o o o o o o o 

davinci:= "DaVinci Resolve by Blackmagic Design - 17.1.0 ahk_class Qt5QWindow"
pixpicker := false
i:=0
cursed:=0
rulery:=140
colrulerx:=600
colrulery:=652
fusrulerx:=770
fusrulery:=480
fairrulery:=160
renrulery:=780
Coordmode pixel screen
coordmode mouse screen
calibratepix:={mediax:700,mediay:1140,cutx:820,editx:940,fusionx:1060,colorx:1180,fairlightx:1300,renderx:1420}                      									
kf:= {edx:1990, edy:178, cox:1000, coy:10, fux:1000, fuy:10, fax:1000, fay:10, rex:1000, rey:10}				;keyframe buttons


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
	pixelgetcolor, editbutt, x.editx, x.mediay
	pixelgetcolor, cutbutt, x.cutx, x.mediay
	if (editbutt="0x000000" || cutbutt="0x000000")
		pagevar := "edit"
	else {
		pixelgetcolor, colorbutt, x.colorx, x.mediay
		if (colorbutt="0x000000")
			pagevar := "color"
		else {
			pixelgetcolor, fusionbutt, x.fusionx, x.mediay
			if (fusionbutt="0x000000")
			pagevar := "fusion"
			else {
				pixelgetcolor, fairlightbutt, x.fairlightx, x.mediay
				if (fairlightbutt="0x000000")
				pagevar := "fairlight"
				else {
					pixelgetcolor, mediabutt, x.mediax, x.mediay
					if (mediabutt="0x000000")
					pagevar := "media"
					else {
						pixelgetcolor, renderbutt, x.renderx, x.mediay
						if (renderbutt="0x000000")
						pagevar := "render"
						}
					}
				}
			}
		}
	tooltip % pagevar, x.fusionx-50, 1,2
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
	page := pagecheck(calibratepix)
	if (page = "") {
		DllCall("SetCursorPos", "int", 1860, "int", 14) 
		mouseclick
		sleep 20
		DllCall("SetCursorPos", "int", 300, "int", 1140) 
		mouseclick
		page := pagecheck(calibratepix)
		if (page = "") {
			winactivate davinci
			sleep 50
			DllCall("SetCursorPos", "int", 1860, "int", 14) 
			mouseclick
			sleep 50
			DllCall("SetCursorPos", "int", 300, "int", 1140) 
			mouseclick
			page := pagecheck(calibratepix)
			}
		}
	mousemove 1000,500
	tooltip % page, calibratepix.fusionx-50, 1,2
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
		Mousemove skipx, rulery
	else if (page="color") 
		Mousemove colrulerx, colrulery	
	else if (page="fusion")
		Mousemove fusrulerx, fusrulery	
	else if (page="fairlight")
		Mousemove skipx, fairrulery	
	else if (page="render")
		Mousemove skipx, renrulery
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
			page := pagecheck(calibratepix)
			if (page = "") 
				gosub overkill
			}
		Else If (p = "00") { 												; double press
			page := pagecheck(calibratepix)
			if WinActive("Secondary Screen")
				gosub overkill
			coordmode mouse screen
			mousegetpos startx, starty
			mousemove calibratepix.mediax, calibratepix.mediay
			pixpicker := true
			tooltip, -- MEDIA -- , calibratepix.mediax-80, calibratepix.mediay-50
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



!AppsKey::

	rule:= yvalruler(page,rulery,colrulery,fusrulery,fairrulery,renrulery)
	
	keyframe := keyframe(page, kf.edx, kf.edy, kf.cox, kf.coy, kf.fux, kf.fuy, kf.fax, kf.fay, kfrex, kf.rey)

gui +LastFound +OwnDialogs +AlwaysOnTop
Gui, new, ,VAR																			;
gui, show, w274 h340 ,																	; makes gui exist + size, if wanna add position, can add x y before size
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
Gui, Add, GroupBox, x10 y+6 w120 h130, calibratepix												; adds box 
gui, add, text, x20 y46, % "media:	 " calibratepix.mediax " 	" calibratepix.mediay		; first line of text at x,y
gui, add, text, y+2, % "cut:	 " calibratepix.cutx									
gui, add, text, y+2, % "edit:	 " calibratepix.editx 									
gui, add, text, y+2, % "fusion:	" calibratepix.fusionx
gui, add, text, y+2, % "color:	" calibratepix.colorx
gui, add, text, y+2, % "fairlight:	" calibratepix.fairlightx
gui, add, text, y+2, % "render:	" calibratepix.renderx " 	" calibratepix.mediay
Gui, Add, GroupBox, x+20 y29 w120 h130, rulers
gui, add, text, x152 y46, % "media:	 	  -" 		
gui, add, text, y+2, % "cut:	 	  -" 							
gui, add, text, y+2, % "edit:		" rulery							
gui, add, text, y+2, % "fusion:	     " fusrulerx "	"fusrulery
gui, add, text, y+2, % "color:	     " colrulerx "	"colrulery
gui, add, text, y+2, % "fairlight:		" fairrulery 
gui, add, text, y+2, % "render:		" renrulery
gui, font, w600
gui, add, text, x10 y170, % "keyframe:	" keyframe.x "	" keyframe.y
gui, font, w400
Gui, Add, GroupBox,  y+6 w120 h130, keyframe buttons
gui, add, text, x20 y210, % "media:	     "
gui, add, text, y+2, % "cut:	     "
gui, add, text, y+2, % "edit:	     " kf.edx "	" kf.edy	
gui, add, text, y+2, % "fusion:	     " kf.fux "	" kf.fuy
gui, add, text, y+2, % "color:	     " kf.cox "	" kf.coy
gui, add, text, y+2, % "fairlight:	     " kf.fax "	" kf.fay
gui, add, text, y+2, % "render:	     " kf.rex "	" kf.rey
gui +LastFound +OwnDialogs +AlwaysOnTop


return





;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo




;------------------------------------------------------------							| x  888 888 888
;------------------------------------------------------------							| x  888 888 888
;------------------------------------------------------------							| x  888 888 888
;------------------------------------------------------------							| x  888 888 888



;------------------------------------------------------------ g9 mouse: opens new tab in chrome, new sheet in Notepad++ 
;------------------------------------------------------------ double press for Razor blade tool



$f1::
	if WinActive("ahk_exe chrome.exe") {
		keywait f1	;don't open a million tabs
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
					Mousemove skipx, rulery
				else if (page="color") 
					Mousemove colrulerx, colrulery	
				else if (page="fusion")
					Mousemove fusrulerx, fusrulery	
				else if (page="fairlight")
					Mousemove skipx, fairrulery	
				else if (page="render")
					Mousemove skipx, renrulery							
				Send {lbutton down}
				heldf1 := 1
				scrollmod := 1
				tooltip ◀ ◈ ▶ 						; ◀ ◈ ▶  or  ◀ ◆ ▶  
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
		i:=2
		mousegetpos startx, starty
		gosub movetoruler
		tooltip -- PIXPICKER --
		}
	else
		Sendinput ^w
Return

/*
f1 & Lbutton::
	Sendinput ^e
	sleep 10
	click
	sleep 10
	Sendinput {f1}
Return

f1 & Scrolllock::
	Scrollmod := 1
	tooltip <-  ->
return			

*/

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
				Mousemove calibratepix.fairlightx, calibratepix.mediay		
				heldf20 := 1
				choosepage:=true
				buttonskipper := (calibratepix.renderx - calibratepix.mediax)/6
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
			page := pagecheck(calibratepix)
			sleep 800
			page := pagecheck(calibratepix)
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
				held21:=2
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
		tooltip % page, calibratepix.fusionx-50, 1, 2
		}
Return

f21 up::
	if (heldf21=1) {
		Send {f1}
		heldf21:=0
		}
	else if (held21=2) {
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
		tooltip % page, calibratepix.fusionx-50, 1, 2
		}
	else
		Sendinput ^{tab}
Return


;------------------------------------------------------------							888  x  888 888
;------------------------------------------------------------							888  x  888 888
;------------------------------------------------------------							888  x  888 888
;------------------------------------------------------------							888  x  888 888



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


;------------------------------------------------------------							888 888  x  888
;------------------------------------------------------------							888 888  x  888
;------------------------------------------------------------							888 888  x  888
;------------------------------------------------------------							888 888  x  888


;------------------------------------------------------------ G15:ctrl
;------------------------------------------------------------ G16:shift





;------------------------------------------------------------ G17 speedy scroll




#if !WinActive("ahk_exe Resolve.exe")								;still horrible - Ralt does not play ball. pgup,dn often want to switch tabs

^Ralt::
	if !WinActive("ahk_exe Resolve.exe") {
	send {ralt down}
	fastscroll:=true
	tooltip ▲`n▼
	}
Return

#if fastscroll

^!WheelUp::
		Send {pgup}
Return

^!WheelDown::
		Send {pgdn}
Return


^Ralt up::
	send {ralt up}
	fastscroll:=false
	tooltip
Return

#if

;------------------------------------------------------------ !G17



;------------------------------------------------------------							888 888 888  x
;------------------------------------------------------------							888 888 888  x
;------------------------------------------------------------							888 888 888  x
;------------------------------------------------------------							888 888 888  x


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
	keywait, c, t.25 
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
	cursed:=0
	gosub cursing
return

lbutton::
	tooltip
	undoscroll:=false
	cursed:=0
	gosub cursing
return

#if


;------------------------------------------------------------ G20 mouse launch Explorer / cycle Explorer tabs

Ins:: 
	p := Morse()
	DetectHiddenWindows On  ; Allows a script's hidden main window to be detected.
	SetTitleMatchMode 2  ; Avoids the need to specify the full path of the file below.
	PostMessage, 0x0111, 65303,,, fastscroll.ahk - AutoHotkey
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
	DetectHiddenWindows On  ; Allows a script's hidden main window to be detected.
	SetTitleMatchMode 2  ; Avoids the need to specify the full path of the file below.
	PostMessage, 0x0111, 65303,,, fastscroll.ahk - AutoHotkey
IfWinNotExist, ahk_exe chrome.exe
	Run, chrome.exe
if WinActive("ahk_exe chrome.exe")
	Sendinput ^{tab}
else
	WinActivate ahk_exe chrome.exe
Return



;------------------------------------------------------------							88888888
;------------------------------------------------------------							88    88
;------------------------------------------------------------							88    88
;------------------------------------------------------------							88888888

;---------------------------------------------------------- mouse wheel
$home::
if WinActive("ahk_exe Spotify.exe") 						; CAN I USE WINEXIST AND MEDIA BUTTONS???? OTHERWISE KINDA USELESS
	Sendinput ^{left}
else 
	Send {home}
Return
	
$end::
if WinActive("ahk_exe Spotify.exe")
	Sendinput ^{right}
else 
	Send {end}
Return	


~^!0:: 
	if !WinActive("ahk_exe Resolve.exe")
	DetectHiddenWindows On  ; Allows a script's hidden main window to be detected.
	SetTitleMatchMode 2  ; Avoids the need to specify the full path of the file below.
	PostMessage, 0x0111, 65303,,, fastscroll.ahk - AutoHotkey
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


Ralt & q::
	if (scrollmod>=1)
	mousemove, -5,-5,,R
	sleep 10
return

Ralt & e::
	if (scrollmod>=1)
	mousemove, 5,-5,,R
	sleep 10
return

Ralt & z::
	if (scrollmod>=1)
	mousemove, -5,5,,R
	sleep 10
return

Ralt & c::
	if (scrollmod>=1)
	mousemove, 5,5,,R
	sleep 10
return

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


altstate:
	state := getkeystate("alt")
	if (A_Priorhotkey= "$!#tab" && state=1)
		wheelarrow:=1
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
	Else if (wheelarrow = 0)
	gosub altstate
	if (wheelarrow = 1)
	send {right}
	Else
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
	if (i=0) {														; set new coords for media button
		Mousegetpos, medx, medy
		calibratepix.mediax:=medx
		calibratepix.mediay:=medy
		tooltip -- RENDER --,calibratepix.renderx-80, calibratepix.mediay-50
		mousemove calibratepix.renderx, calibratepix.mediay		
		}
	if (i=1) {
		Mousegetpos, renx, reny										; set new coord for render button
		calibratepix.renderx:=renx
		calibratepix.cutx:= medx + (renx-medx)/6					; set coords of other buttons relatively
		calibratepix.editx:= medx + 2*(renx-medx)/6
		calibratepix.fusionx:= medx + 3*(renx-medx)/6
		calibratepix.colorx:= medx + 4*(renx-medx)/6
		calibratepix.fairlightx:= medx + 5*(renx-medx)/6
		gosub movetoruler	
		tooltip -- RULER --
		}
	i++																; not i++ at the end so as to reset it cleanly
	if (i=3) {
		if (page="edit")
			Mousegetpos, rulerx, rulery									; set edit timeline ruler position
		else if (page="color")
			Mousegetpos, colrulerx, colrulery
		else if (page="fusion")
			Mousegetpos, fusrulerx, fusrulery		
		else if (page="fairlight")
			Mousegetpos, rulerx, fairrulery
		else if (page="render")
			Mousegetpos, rulerx, renrulery			
		i:=0
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
	if (buttx > calibratepix.mediax+20)
		mousemove buttx-buttonskipper, butty
return

$wheeldown::
	Coordmode mouse screen
	Mousegetpos buttx, butty
	if (buttx < calibratepix.renderx-20)
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






