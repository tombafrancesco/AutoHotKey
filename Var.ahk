#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


; o o o o o o o o o o o o o o o INITIAL VALUE VARIABLES o o o o o o o o o o o o o o o o 

davinci := "DaVinci Resolve by Blackmagic Design - 17.1.0"

ruler  :=  	{edx:0, 	edy:140, cox:600, coy:640, fux:770, fuy:480, fay:0, fay:160, rex:0, rey:780}						;ruler pos
kf     :=  	{edx:1990, edy:178, cox:1000, coy:10, fux:1000, fuy:10, fax:1000, fay:10, rex:1000, rey:10}					;keyframe buttons
calpix :=  	{mex:700, mey:1140, cutx:820, edx:940, fux:1060, cox:1180, fax:1300, rex:1420} 								;calibrate buttons                  									

inspector:=	{x: 1970, y: 34}								;f3 tart
mask   :=  	{x:1078,y:796}									;g10 mouse, color page tools

toolskipper := 70											;(1358-868)/7

cal :=			0											;calibrate - appskey, !f1
pixpicker := 	0											;calibrate - appskey
cursed :=		0											;cursor, g19
scrollmod := 	0											;g7, tweak button modifier
heldf1 :=		0											;timeline ruler
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
vmax := 	1												; Runtime variables. Do not modify.

				;QMODE
Qmode:=0
Qreset:
start:=A_TickCount
q:={x:480,y:1130}
w:={x:540,y:1130}
e:={x:1500,y:1130}
r:={x:1095,y:988}
return

		
