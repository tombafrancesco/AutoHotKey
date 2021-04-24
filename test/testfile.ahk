#NoEnv
#MaxHotkeysPerInterval 120
#SingleInstance force

Process, Priority, , H
SendMode Input





#if !WinActive("ahk_exe Resolve.exe")

 
; tooltips := 1												; 1 or 0: on or off

timeout := 600												; The length of a scrolling session. time to accumulate boost.
															; Default: 500. Recommended between 400 and 1000.

boost := 30													; additional boost factor. the higher the value, the longer it takes to activate, and the slower it accumulates.
															; Set to zero to disable completely. Default: 20.
															
limit := 60													; maximum number of scrolls sent per click, so it doesn't overwhelm i.e. max velocity. Default: 60.

distance := 0												; Runtime variables. Do not modify.
vmax := 1


; ~^!0:: reload


WheelUp::    Goto Scroll
WheelDown::  Goto Scroll

Scroll:
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
		; if (v > 1 && tooltips)
			; QuickToolTip("x"v, timeout)
		MouseClick, %A_ThisHotkey%, , , v
		}
	else  {
		distance := 0												; Combo broken, so reset session variables
		vmax := 1
		MouseClick %A_ThisHotkey%
		}
return

; QuickToolTip(text, delay)
; {
	; ToolTip, %text%
	; SetTimer ToolTipOff, %delay%
	; return

	; ToolTipOff:
	; SetTimer ToolTipOff, Off
	; ToolTip
	; return
; }

; Quit:
	; QuickToolTip("Exiting Accelerated Scrolling...", 1000)
	; Sleep 1000
	; ExitApp

; ~f1 & wheelup::
; ~f1 & wheeldown::
; return

; #if 

; ~f1::
	; Suspend
; return

; ~f1 up::
	; if !WinActive("ahk_exe Resolve.exe")
	; Reload
; return

; ~^!0:: 
	; if WinActive("ahk_exe Resolve.exe")
	; Suspend
; return

; ~f20::
	; if WinActive("ahk_exe Resolve.exe")
	; Suspend
; return


; ~f21::
	; keywait, f21, t.2
	; Suspend
; return
