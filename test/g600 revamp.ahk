#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


#SingleInstance Force

; o o o o o o o o o o o o o o o INITIAL VALUE VARIABLES o o o o o o o o o o o o o o o o 

;------------------------------ Resolve Variables -------------------------------------

davinci:= "DaVinci Resolve by Blackmagic Design - 17.1.0"
pixpicker := false
i:=0
rulery:=140
colrulery:=710
fusrulery:=550
fairrulery:=160
renrulery:=780
Coordmode pixel screen
coordmode mouse screen
calibratepix:={mediax:700,mediay:1140,cutx:820,editx:940,fusionx:1060,colorx:1180,fairlightx:1300,renderx:1420}


; o o o o o o o o o o o o o o o FUNCTIONS o o o o o o o o o o o o o o o o o o o o o o o


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


!AppsKey::																				; should be in Resolve section but useful here for troubleshooting?

	rule:= yvalruler(page,rulery,colrulery,fusrulery,fairrulery,renrulery)

gui +LastFound +OwnDialogs +AlwaysOnTop
Gui, new, ,VAR																			;
gui, show, w274 h300 ,																	; makes gui exist + size, if wanna add position, can add x y before size
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
gui, add, text, x20 y46, % "media:	 " calibratepix.mediax " ," calibratepix.mediay		; first line of text at x,y
gui, add, text, y+2, % "cut:	 " calibratepix.cutx									; more text relative to first (stays in same area)
gui, add, text, y+2, % "edit:	 " calibratepix.editx 									
gui, add, text, y+2, % "fusion:	" calibratepix.fusionx
gui, add, text, y+2, % "color:	" calibratepix.colorx
gui, add, text, y+2, % "fairlight:	" calibratepix.fairlightx
gui, add, text, y+2, % "render:	" calibratepix.renderx "," calibratepix.mediay
Gui, Add, GroupBox, x+30 y29 w120 h130, rulers
gui, add, text, x152 y46, % "media:	 	  -" 		
gui, add, text, y+2, % "cut:	 	  -" 							
gui, add, text, y+2, % "edit:		" rulery							
gui, add, text, y+2, % "fusion:		" fusrulery
gui, add, text, y+2, % "color:		" colrulery
gui, add, text, y+2, % "fairlight:		" fairrulery
gui, add, text, y+2, % "render:		" renrulery
gui +LastFound +OwnDialogs +AlwaysOnTop

return
	
	
	
; o o o o o o o o o o o o o o o GOSUBS, GOTOS  o o o o o o o o o o o o o o o o o 

; o o o o o o o o o o o o o o o MOUSE TOP BUTTONS o o o o o o o o o o o o o o o o o o o o o

;------------------------------------------------------------ knuckle button select hold

Scrolllock::																					;MUST BE FIXED!
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
					tooltip < - - >
					}
				Else {
					scrollmod := 2
					tooltip ^`n |`nv
					}
				}
			Else if (scrollmod = 0) {
				Scrollmod := 1
				tooltip <-  ->
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
		tooltip ^`n |`nv	
		}
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

;---------------------------------------------------------- mouse wheel L,R
$home::
if WinActive("ahk_exe Spotify.exe") 
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


; o o o o o o o o o o o o o o o MOUSE SIDE BUTTONS o o o o o o o o o o o o o o o o o o o o o


;------------------------------------------------------------ g9: opens new tab in chrome, new sheet in Notepad++ 
;------------------------------------------------------------ g9 + wheel: cycles tabs

$f1::
	if WinActive("ahk_exe chrome.exe") {
		keywait f1	;don't open a million tabs
		Sendinput ^t
		}
	else {
		keywait f1		;don't open a million tabs
		Sendinput ^n
		}
Return

;;;;;;;;;;;;f1 wheels at bottom of GENERAL

;------------------------------------------------------------ !g9 mouse: close current tab
$!f1::
	Sendinput ^w
Return




;------------------------------------------------------------ g10  selects title bar in chrome, up one folder windows exp
$f20::
	if WinActive("ahk_exe chrome.exe") 
		Sendinput {f6}
	else if WinActive("ahk_exe explorer.exe") 
		Sendinput !{up}
Return
	
	
;------------------------------------------------------------G11 mouse: long press Launch Resolve 
;------------------------------------------------------------ short press UNASSIGNED
$f21::
		keywait, f21, t.2
		if errorlevel {
			IfWinNotExist, ahk_exe Resolve.exe
				Run, C:\Program Files\Blackmagic Design\DaVinci Resolve\Resolve.exe
			else
				WinActivate ahk_exe Resolve.exe
				held21:=2									; check if i need this and delete if unnecessary. try to kill edit page switch when reactivating resolve!
			}
		else
			msgbox something fun here
		keywait, f21

Return

$!f21::
	Sendinput ^{tab}
Return

;------------------------------------------------------------ g12: back
$f22::
	Sendinput !{left}
Return

;------------------------------------------------------------ !G12 close tab
$!f22::
	if WinActive("ahk_exe chrome.exe")
		Sendinput j
	Else
		Sendinput !{f22}
Return

;------------------------------------------------------------ g13: reload, stop load
;------------------------------------------------------------ g13: save and run notepad ++
$f23::
	if ((A_PriorHotkey = A_ThisHotKey || A_PriorHotkey = "f22") && A_TimeSincePriorHotkey < 300) {
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
Return

;------------------------------------------------------------ g14: forward
$f24::
	Sendinput !{right}
Return

;------------------------------------------------------------ !G14 close tab
$!f24::
	if WinActive("ahk_exe chrome.exe")
		Sendinput l												; essentially useless
Return




;------------------------------------------------------------ G15:ctrl
;------------------------------------------------------------ G16:shift

;------------------------------------------------------------ G17 speedy scroll


#if !WinActive("ahk_exe Resolve.exe")

~^Ralt::
	tooltip |
Return

~RAlt & WheelUp::
		Send {PgUp}
Return

~RAlt & WheelDown::
		Send {PgDn}
Return

~^Ralt up::
	tooltip
Return


#if


;------------------------------------------------------------ !G17


;------------------------------------------------------------ G18:start



;------------------------------------------------------------ hold !G18 shutdown computer
$^!esc::
	Sendinput #{d}
	Keywait, ctrl, t.5
	Keywait, alt, t.5
	Keywait, esc, t.5
		If (ErrorLevel)
		run, C:\Users\tomba\OneDrive\Documents\Commands AHK\shutdown.lnk
	Keywait, ctrl
	Keywait, alt
	Keywait, esc
Return


;------------------------------------------------------------ G19:see open windows
$!#tab::												;hack to get wheel to work to select through open windows (move mouse onto window selector)
	Send !#{tab}
	coordmode mouse screen
	mousemove, 1020, 480
Return


;------------------------------------------------------------ G20 mouse launch Explorer / cycle Explorer tabs

Ins:: ;---------------------------------------- change back to manual?
	p := Morse()
	If (p = "0"){
		IfWinNotExist, ahk_class CabinetWClass 
			Run, explorer.exe
		
		if WinActive("ahk_exe explorer.exe") 
			Sendinput #e
			
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
IfWinNotExist, ahk_exe chrome.exe
	Run, chrome.exe

if WinActive("ahk_exe chrome.exe")
	Sendinput ^{tab}
else
	WinActivate ahk_exe chrome.exe
Return



;-----------------------------------------------------------zoom consistent in chrome
;-----------------------------------------annoying as it disables reset zoom (ctrl0)


^WheelUp::
	if WinActive("ahk_exe Chrome.exe")
		Send ^{+}
	else
		send ^{wheelup}
return

^WheelDown::
	if WinActive("ahk_exe Chrome.exe")
		Send ^-
	else
		send ^{wheeldown}
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

; o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o
; o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o
; o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o
; o o         o o o           o o o o       o o o       o o o   o o o o   o o o o   o o           o o o o o o o o o o o o o o o o o o o o o
; o o   o o o   o o   o o o o o o     o o o o o   o o o   o o   o o o o   o o o o   o o   o o o o o o o o o o o o o o o o o o o o o o o o o 
; o o   o o o   o o   o o o o o o   o o o o o o   o o o   o o   o o o o   o o o o   o o   o o o o o o o o o o o o o o o o o o o o o o o o o 
; o o   o o o   o o   o o o o o o   o o o o o o   o o o   o o   o o o o   o o o o   o o   o o o o o o o o o o o o o o o o o o o o o o o o o 
; o o   o o o   o o   o o o o o o o   o o o o o   o o o   o o   o o o o o   o o   o o o   o o o o o o o o o o o o o o o o o o o o o o o o o 
; o o         o o o       o o o o o o     o o o   o o o   o o   o o o o o   o o   o o o       o o o o o o o o o o o o o o o o o o o o o o o 
; o o   o o o o o o   o o o o o o o o o o   o o   o o o   o o   o o o o o   o o   o o o   o o o o o o o o o o o o o o o o o o o o o o o o o 
; o o   o o o   o o   o o o o o o o o o o   o o   o o o   o o   o o o o o o     o o o o   o o o o o o o o o o o o o o o o o o o o o o o o o 
; o o   o o o   o o   o o o o o o o o o     o o   o o o   o o   o o o o o o     o o o o   o o o o o o o o o o o o o o o o o o o o o o o o o 
; o o   o o o   o o           o o       o o o o o       o o o           o o     o o o o           o o o o o o o o o o o o o o o o o o o o o 
; o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o 
; o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o 
; o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o 


#if WinActive("ahk_exe Resolve.exe")



; o o o o o o o o o o o o o o o FUNCTIONS o o o o o o o o o o o o o o o o o o o o o o o

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





; o o o o o o o o o o o o o o o GOSUBS, GOTOS  o o o o o o o o o o o o o o o o o 



overkill:																	; sometimes pagecheck fails. this should fix problem 99%. 
	if WinActive("ahk_exe resolve.exe") {
	DllCall("SetCursorPos", "int", 1860, "int", 145) 
	mouseclick
	page := pagecheck(calibratepix)
	if (page = "") {
		DllCall("SetCursorPos", "int", 1860, "int", 145) 
		mouseclick
		sleep 20
		DllCall("SetCursorPos", "int", 300, "int", 1140) 
		mouseclick
		page := pagecheck(calibratepix)
		if (page = "") {
			winactivate davinci
			sleep 50
			DllCall("SetCursorPos", "int", 1860, "int", 145) 
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
	If (p = "0") {														; single
		winactivate davinci
		mousemove 1000,500
		page := pagecheck(calibratepix)
		if (page = "") 
			gosub overkill
		}
	Else If (p = "00") { 												; double press
		pixpicker := true
		tooltip -- CALIBRATE --
		}
	Else If (p = "01") { 												; short long
		reload, C:\Users\tomba\OneDrive\Desktop\AutoHotKey\G600_Aero.ahk
		}
	Else { 																; long
		run, C:\Program Files\AutoHotkey\WindowSpy.ahk
		}
Return





; o o o o o o o o o o o o o o o MOUSE TOP BUTTONS o o o o o o o o o o o o o o o o o o o o o




; o o o o o o o o o o o o o o o MOUSE SIDE BUTTONS o o o o o o o o o o o o o o o o o o o o o


;------------------------------------------------------ normal selection mode, or hold to access ruler mode. recalibrate: ^!f1. in ruler mode mousewheel moves cursor 1px


$f1::
	send {f1}
	Keywait, f1, t0.3
		if errorlevel {	
			Coordmode mouse screen
			Mousegetpos skipx, skipy
			if (page="edit" or page="")
				Mousemove skipx, rulery
			else if (page="color")
				Mousemove skipx, colrulery		
			else if (page="fusion")
				Mousemove skipx, fusrulery	
			else if (page="fairlight")
				Mousemove skipx, fairrulery	
			else if (page="render")
				Mousemove skipx, renrulery							
			Send {lbutton down}
			heldf1 := 1
			scrollmod := 1
			tooltip < - - >
			}
	keywait f1
		
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




^!f1::																	; recalibrate ruler for selected page
	tooltip -- PIXPICKER --
	pixpicker := true
	i:=2
Return




;------------------------------------------------------------ !g9 : STILL EMPTY!
$!f1::
		Sendinput ^{f1}
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

;------------------------------------------------------------ g10 trim edit mode
$f20::
	Sendinput {f20}									; up to here we're safe
	Keywait, f20, t0.3
	if errorlevel {
		Coordmode mouse screen
		Mousegetpos skipx, skipy
		Mousemove calibratepix.colorx, calibratepix.mediay		
		heldf20 := 1
		choosepage:=true
		buttonskipper := (calibratepix.renderx - calibratepix.mediax)/6
		}
	Keywait f20	
Return

f20 up::
	if (heldf20=1) {
		MouseClick 
		mouseclick,,1000,3
		Mousemove, skipx, skipy
		heldf20:=0
		choosepage:=false
		sleep 200
		page := pagecheck(calibratepix)
		tooltip % page, calibratepix.fusionx-50, 1,2
		sleep 800
		page := pagecheck(calibratepix)
		tooltip % page, calibratepix.fusionx-50, 1,2
		if (page = "") 
			gosub overkill 
	}
return	



;------------------------------------------------------------click switch to blade tool 
;------------------------------------------------------------hold for temp blade tool
$f21::
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
Return

f21 up::
	if (heldf21=1) {
		Send {f1}
		heldf21:=0
		}
	else if (held21=2) {										;does this do anything?
		sleep 300												;KILL KILL KILL KILL KILL
		heldf21:=0
		}
return	


;------------------------------------------------------------ !G11 mouse: Resolve switch to Edit page / otherwise cycle back tab 
$!f21::
	Sendinput +4
	page := "color"
	coordmode tooltip screen
	tooltip % page, calibratepix.fusionx-50, 1, 2
Return

;------------------------------------------------------------ g12: back
$f22::
	Sendinput {f22}
Return

;------------------------------------------------------------ !G12 close tab
$!f22::
	Sendinput !{f22}
Return


;------------------------------------------------------------ g13: reload
$f23::
	Sendinput {f23}
Return
	
;------------------------------------------------------------ g14: forward
$f24::
	Sendinput {f24}
Return

;------------------------------------------------------------ !G14 close tab
$!f24::
		Sendinput !{f24}
Return



;------------------------------------------------------------ G15:ctrl

;------------------------------------------------------------ G16:shift

;------------------------------------------------------------ G17:ctrl alt, + speedy scroll wheel


;------------------------------------------------------------ !G17


;------------------------------------------------------------ G18:start





;------------------------------------------------------------ G19:see open windows

;------------------------------------------------------------ G19:see open windows

;------------------------------------------------------------ G20 mouse launch Explorer / cycle Explorer tabs

;------------------------------------------------------------ !G20 mouse launch Chrome / cycle Chrome tabs






; o o o o o o o o o o o o o o o TWEAK BUTTON MODIFIER o o o o o o o o o o o o o o

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
					tooltip < - - >
					}
				Else {
					scrollmod := 2
					tooltip ^`n |`nv
					}
				}
			Else if (scrollmod = 0) {
				Scrollmod := 1
				tooltip <-  ->
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
		tooltip ^`n |`nv	
		}
	}
Return

!Scrolllock::
	Send {Alt down}{LButton}{alt up}
	Sleep 500
	Send {Lbutton down}
	scrollmod := 2
	tooltip ^`n |`nv	
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

$wheelup::
	If (scrollmod = 1)
	mousemove, -1,0,,R 
	else if (scrollmod = 2)
	mousemove, 0,-1,,R
	Else
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



; o o o o o o o o o o o o o o o o o o o CALIBRATE PIXPICKER o o o o o o o o o o o o o o o o 

#if pixpicker


Mbutton::
	Coordmode pixel screen											; screen coordinates
	coordmode mouse screen
	if (i=0) {														; set new coords for media button
		Mousegetpos, medx, medy
		calibratepix.mediax:=medx
		calibratepix.mediay:=medy
		tooltip -- MEDIA --
		}
	if (i=1) {
		Mousegetpos, renx, reny										; set new coord for render button
		calibratepix.renderx:=renx
		tooltip -- RENDER --
		calibratepix.cutx:= medx + (renx-medx)/6					; set coords of other buttons relatively
		calibratepix.editx:= medx + 2*(renx-medx)/6
		calibratepix.fusionx:= medx + 3*(renx-medx)/6
		calibratepix.colorx:= medx + 4*(renx-medx)/6
		calibratepix.fairlightx:= medx + 5*(renx-medx)/6
		}
	i++																; not i++ at the end so as to reset it cleanly
	if (i=3) {
		if (page="edit")
			Mousegetpos, rulerx, rulery									; set edit timeline ruler position
		else if (page="color")
			Mousegetpos, rulerx, colrulery
		else if (page="fusion")
			Mousegetpos, rulerx, fusrulery		
		else if (page="fairlight")
			Mousegetpos, rulerx, fairrulery
		else if (page="render")
			Mousegetpos, rulerx, renrulery			
		i:=0
		pixpicker := false
		tooltip -- RULER --
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


