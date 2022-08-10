#NoEnv
SendMode Input
SetWorkingDir, C:\Users\tomba\OneDrive\Desktop\AutoHotKey			
#include C:\Users\tomba\OneDrive\Desktop\AutoHotKey\lib\func.ahk  	; general function library
#include C:\Users\tomba\OneDrive\Desktop\AutoHotKey\lib\Acc.ahk 		; can be included for Acc functions
#include C:\Users\tomba\OneDrive\Desktop\AutoHotKey\lib\resfunc.ahk  	; Resolve function library
#include C:\Users\tomba\OneDrive\Desktop\AutoHotKey\GoSub1.ahk
#MaxHotkeysPerInterval 120				; mostly for FASTSCROLL
#SingleInstance Force


; o o o o o o o o o o o o o o o           FUNCTIONS             o o o o o o o o o o o o o o o o 
Coordmode pixel screen
coordmode mouse screen


pagecheck(x) {
	; SetTitleMatchMode 2
	; WinActivate %davinci%
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
return keyframe
}
 
Box_Init(C="yellow") {
	loop, 6 {
		Gui, % A_Index + 93 ": +ToolWindow -Caption +AlwaysOnTop +LastFound"
		}
	; Gui, 94: Color, % C
	; Gui, 95: Color, % C
	Gui, 96: Color, % C
	Gui, 97: Color, % C
	Gui, 98: Color, % C
	Gui, 99: Color, % C
	; gui, 94: font, s14 w1000, Consolas
	; gui, 94: add, text, x4 y0, Q
	; gui, 95: font, s14 w1000, Consolas
	; gui, 95: add, text, x4 y0, W	
	gui, 96: font, s14 w1000, Consolas
	gui, 96: add, text, x4 y0, Q
	gui, 97: font, s14 w1000, Consolas
	gui, 97: add, text, x4 y0, W	
	gui, 98: font, s14 w1000, Consolas
	gui, 98: add, text, x4 y0, E
	gui, 99: font, s14 w1000, Consolas
	gui, 99: add, text, x4 y0, R							;Use Gui +LastFoundExist and then WinExist()
}
 

pageacc(d = "DaVinci Resolve by Blackmagic Design - 17.1.0")	{
	winactivate % d
	WinGet, hWnd, ID, A																
	oAcc := Acc_Get("Object", "4.2.2.3", 0, "ahk_id " hWnd)																
	if (oAcc.accState(0)=0)														
		page:= "edit"	
	else {
		oAcc := Acc_Get("Object", "4.2.2.6", 0, "ahk_id " hWnd)
		if (oAcc.accState(0)=0)	
			page:= "color"
		else {
			oAcc := Acc_Get("Object", "4.2.2.5", 0, "ahk_id " hWnd)
			if (oAcc.accState(0)=0)	
				page:= "fairlight"
			else {
				oAcc := Acc_Get("Object", "4.2.2.4", 0, "ahk_id " hWnd)
				if (oAcc.accState(0)=0)	
					page:= "fusion"
				else {
					oAcc := Acc_Get("Object", "4.2.2.2", 0, "ahk_id " hWnd)
					if (oAcc.accState(0)=0)	
						page:= "cut"
					else {
						oAcc := Acc_Get("Object", "4.2.2.7", 0, "ahk_id " hWnd)
						if (oAcc.accState(0)=0)	
							page:= "render"
						else {
							oAcc := Acc_Get("Object", "4.2.2.1", 0, "ahk_id " hWnd)
							if (oAcc.accState(0)=0)	
								page:= "media"
							}
						}
					}
				}
			}
		}
	return page
}


