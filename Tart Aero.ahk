#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
#include C:\Users\tomba\OneDrive\Desktop\AutoHotKey\lib\func.ahk

davinci := "DaVinci Resolve by Blackmagic Design - 17.1.0"

inspector:={x: 1970, y: 34}








; ~^!0:: reload

;------------------------------------------------------------RESOLVE---------------------------
;#ifWinActive ahk_exe Resolve.exe
*/

^+Delete::														; fix insert when it goes wrong
	send {insert}
return

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
	; oAcc := ""				     2.2.3.1.1.1.2.1.3	
; Return

; $f3::												
	; skip := GetCursorPos()	
	; DllCall("SetCursorPos", "int", inspector.x, "int", inspector.y)
	; click
	; DllCall("SetCursorPos", "int", skip.x, "int", skip.y)
; Return



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

;-----------------------------------G07 -7,8,9,Del are different - action happens immediately on Deep press
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

;-----------------------------------G08 -7,8,9,Del are different - action happens immediately on Deep press
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

;-----------------------------------G09 -7,8,9,Del are different - action happens immediately on Deep press
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
$!Numpad1::  ;             if it ain't broke? registers as !num1 in resolve 
return

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
$!Numpad2::              if it ain't broke? registers as !num2 in resolve 
return

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

;-----------------------------------G15 (immediate press)



$f15::
Send +y						;select edit point
Send {f15}					;cycle edit point types

KeyWait, f15
tooltip
Return

$!Numpad5::
return

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



;-----------------------------------G16



;-----------------------------------G17
$Numpad7::
KeyWait, Numpad7, T.1
tooltip, lah
If ErrorLevel {
	Send c
	Sleep 100
	tooltip	
	}
KeyWait, Numpad7,
tooltip	
Return

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
$Numpad8::
KeyWait, Numpad8, T.1
tooltip, lah
If ErrorLevel {
	Send x
	Sleep 100
	tooltip	
	}
KeyWait, Numpad8,
tooltip	
Return

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
$Numpad9::
KeyWait, Numpad9, T.1
tooltip, lah
If ErrorLevel {
	Send v
	Sleep 100
	tooltip	
	}
KeyWait, Numpad9,
tooltip	
Return

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

$^Numpad9::
return

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



#If timer ; o o o o o o o o o o o o o o  SPEED CONTROL SUBWORLD  o o o o o o o o o o o o o o o 

backspace::
Insert::
PrintScreen::
NumpadEnter::
AppsKey::
Numpaddiv::
Numpadsub::
Pause::
Numpadadd::
Numpadmult::
Numpad1::
Numpad2::
; Numpad3::
Numpad4::
Numpad5::
Numpad6::
Numpad7::
Numpad8::
Numpad9::
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


Insert::
PrintScreen::
NumpadEnter::
AppsKey::
Numpaddiv::
Numpadsub::
Pause::
Numpadadd::
Numpadmult::
Numpad1::
Numpad2::
; Numpad3::
Numpad4::
Numpad5::
Numpad7::
Numpad8::
Numpad9::
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

