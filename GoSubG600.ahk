#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%				
#include %A_ScriptDir%\var.ahk			; Resolve variables
#include %A_ScriptDir%\lib\func.ahk  	; general function library
#include %A_ScriptDir%\lib\Acc.ahk 		; can be included for Acc functions
#include %A_ScriptDir%\resfunc.ahk  	; Resolve function library
#MaxHotkeysPerInterval 120				; mostly for FASTSCROLL
#SingleInstance Force

; DontRunGosubs() {
; return
; }

; o o o o o o o o o o o o o         GOSUB        GOTO        o o o o o o o o o o o o o o o o o 


underkill:													;be careful with this - can bug up overkill for some reason
	if WinActive("ahk_exe resolve.exe") {
	SetTitleMatchMode 2
	WinActivate %davinci%
	page:=pagecheck(calpix)
	coordmode tooltip screen
	tooltip % page, calpix.fux-50, 1, 2
	}
return


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


Scroll:															; FASTSCROLL
	if (xfastscroll=0) {
		t := A_TimeSincePriorHotkey
		if (A_PriorHotkey = A_ThisHotkey && t < timeout) {
			distance++													; Remember # of scrolls in current direction
			v := (t < 80 && t > 1) ? (250.0 / t) - 1 : 1				; Calculate acceleration using a 1/x curve
			if (boost > 1 && distance > boost) {						; Apply boost
				if (v > vmax)											; Hold top speed  achieved during this boost
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


movetoruler:
	skip := GetCursorPos()													;like mousegetpos - DLL get+setcursorpos less buggy than native ahk
	if (skip.x>2046)
		DllCall("SetCursorPos", "int", 10, "int", 54) 						;setcursorpos doesn't work properly from second screen
	if (page="edit" or page="") { 
		if (skip.x>2046)
			DllCall("SetCursorPos", "int", 1110, "int", ruler.edy) 			;dllcalls set on 27.04.21 - revert to earlier for mousemove
		else	
			DllCall("SetCursorPos", "int", skip.x, "int", ruler.edy)
		}
	else if (page="color") 
		DllCall("SetCursorPos", "int", ruler.cox, "int", ruler.coy)
	else if (page="fusion")
		DllCall("SetCursorPos", "int", ruler.fux, "int", ruler.fuy)
	else if (page="fairlight")
		DllCall("SetCursorPos", "int", skip.x, "int", ruler.fay)
	else if (page="render")
		DllCall("SetCursorPos", "int", skip.x, "int", ruler.rey)		
return


cursing:														;  cursor change
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


StateYourCase:													;  *Capslock mod
	If (A_ThisMenuItem = "Title") { 
		StringLower text, text, T   ; Title case
		}
	Else If (A_ThisMenuItem = "Upper") { ;       
		StringUpper text, text ; UpperCase
		}
	Else { ;       
		StringLower text, text ; LowerCase
		}
	Clipboard := text
	ClipWait 1
	Send ^v
Return 



Qboxes:	
	Box_Init()
	Gui, 96: Show, % "x" q.x-10 " y" q.y-10 " w" 20 " h" 20 " NA", Horizontal 1
	Gui, 97: Show, % "x" w.x-10 " y" w.y-10 " w" 20 " h" 20 " NA", Vertical 2
	Gui, 98: Show, % "x" e.x-10 " y" e.y-10 " w" 20 " h" 20 " NA", Horizontal 2
	Gui, 99: Show, % "x" r.x-10 " y" r.y-10 " w" 20 " h" 20 " NA", Vertical 2
	sleep 1000
Return		
		

Qpix:
	key:=A_ThisHotKey
	dif:=(A_tickcount-start)
	if (dif > 300){
		start:=A_TickCount
		skip := GetCursorPos()
		DllCall("SetCursorPos", "int", %key%.x, "int",%key%.y)
		scrollmod:=1
		Send {LButton down}
		Box_Centre(%key%.x, %key%.y, 30, 20, 2, 0)
		Keywait %key%
			{
			scrollmod:=0
			Send {LButton up}
			DllCall("SetCursorPos", "int", skip.x, "int", skip.y)
			Box_Hide()
			Gui, 96: Show, % "x" 1100 " y" 0 " w" 70 " h" 20 " NA"
			}
		}	
	else {
		DllCall("SetCursorPos", "int", %key%.x, "int",%key%.y)
		Send {LButton 2}
		DllCall("SetCursorPos", "int", skip.x, "int", skip.y)
		Keywait %key% 
		}
return

Qmove:
	Send {LButton up}
	dif:=(A_tickcount-start)
	if (dif > 2000)
		skip := GetCursorPos()
	DllCall("SetCursorPos", "int", %key%.x, "int",%key%.y)
	SetBatchLines, -1
	SetWinDelay, -1
	Loop {
		newpos := GetCursorPos()
		%key%.x := newpos.x, %key%.y := newpos.y
		Box_Centre(%key%.x, %key%.y, 20, 20, 2, 1)
		altstate := getkeystate("alt", p)
		if (altstate=0) {
			Box_Centre(%key%.x, %key%.y, 20, 20, 2, 1)
			DllCall("SetCursorPos", "int", skip.x, "int",skip.y)
			sleep 300
			Box_Hide()
			Gui, 96: Show, % "x" 1100 " y" 0 " w" 70 " h" 20 " NA"
			break
			}
	   }
	Keywait %key%
Return