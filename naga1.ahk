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



;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo


;           00                        00  
;            0                         0  
;   000  000 00000    0000    0000     0  
;    0    0  00  00  0    0  0    0    0  
;    0 00 0  0    0  000000  000000    0   
;    0 0000  0    0  0       0         0  
;     00 0   0    0  00      00        0   
;     0  0  000  000  00000   00000  00000 



#if (!WinActive("ahk_exe Resolve.exe") && !WinActive("ahk_exe googleearth.exe"))

Process, Priority, , H

WheelUp::    
	wheelarrow=true
	Goto Scroll
WheelDown::  Goto Scroll

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



;--------------------------------------------------	 		Wheel L & R


#if

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

; 	 0000 000   00000   00  00    00000    00000 
; 	  0  0  0  0     0   0   0   0     0  0     0
; 	  0  0  0  0     0   0   0    00000   0000000
; 	  0  0  0  0     0   0   0         0  0      
; 	  0  0  0  0     0   0  00   00    0  00    0
; 	 000 0 000  00000    0000000  00000    00000 
;                                                                    /


;------------------------------------------------------------						|   x  888 888 888
;------------------------------------------------------------						|   x  888 888 888
;------------------------------------------------------------						|   x  888 888 888
;------------------------------------------------------------						|   x  888 888 888



;--------------------------------------------------------	Naga1    	mouse: new tab in chrome, new sheet in Notepad++ 

;-------------------------------------------------------		    double press for Razor blade tool
$XButton2::
	if (WinActive("ahk_exe chrome.exe") || WinActive("ahk_exe vivaldi.exe") || WinActive("ahk_exe notepad++.exe")) {
		p := Morse()
		If (p = "0"){
			if WinActive("ahk_exe notepad++.exe")
				send ^n
			else 
				Sendinput ^t
			}
		If (p = "00")
		{
			Sendinput ^w
		}
		}
	else if WinActive("ahk_exe resolve.exe") {
		if (page="cut") {
			}
		send a
		Keywait, XButton2, t0.3
			if errorlevel {		
				tooltip movetoruler still need to create
		
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




;-------------------------------------------------------	Naga2           held = vol control; click is full screen in browser, folder up in exp, slip mode resolve  

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


		
;-------------------------------------------------------	Naga3     mouse: Launch Resolve / switch to Edit page

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

			}		
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

;------------------------------------------------------------ !G11 mouse: Resolve switch to Edit page 

$!f21::
	if WinActive("ahk_exe Resolve.exe") {
		Sendinput +4
		}
	else
		Sendinput {esc}
Return




;------------------------------------------------------------						|	888  x  888 888
;------------------------------------------------------------						|	888  x  888 888
;------------------------------------------------------------						|	888  x  888 888
;------------------------------------------------------------						|	888  x  888 888



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



;------------------------------------------------------------				

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

XButton1 up::
	wheelarrow:=false
	tooltip
return


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




;------------------------------------------------------------ !G20 mouse launch Vivaldi 
!Ins::

	IfWinNotExist, ahk_exe vivaldi.exe
		Run, vivaldi.exe
	if WinActive("ahk_exe vivaldi.exe")
		WinMinimize, a
	else
		WinActivate ahk_exe vivaldi.exe
Return
