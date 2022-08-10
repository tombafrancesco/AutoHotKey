#SingleInstance Force
SetWorkingDir %A_ScriptDir%				
#include %A_ScriptDir%\lib\FindTextFunc.ahk			

Menu, Tray, Icon, C:\Windows\system32\shell32.dll,147 ;Set custom Script icon

CoordMode, Screen

InputBox, FileNum, Reelsteady Batch, How many files?, ,60

;Variable Declaration

sleep, 1000

if (errorlevel = 0) 
	{
	msgbox, 4, screens, is second screen unplugged?
	IfMsgBox, No 
		Return
	
	InputBox, SSZZ, Smoothness, Input SSZZ where SS is smooothness and ZZ is zoom speed - default:2050, 180,60
	
	if ((errorlevel = 1) || SSZZ="")
		{
		SS:=20
		ZZ:=50
		}
	else 
		{
		SS := Floor(SSZZ/100)
		ZZ := SSZZ - SS*100
		}
	msgbox SS %SS%,  ZZ: %ZZ%  
	Uncheck := SS=ZZ ? 0 : 1
	
	pixSS:= 1652 + ((1919-1652)/50)*SS			; first pixel + proportion of bar
	pixZZ:= 1652 + ((1919-1652)/50)*ZZ
	
	if WinExist("ReelSteady GO Evaluation") 
		{
		Winactivate ReelSteady GO Evaluation
		send #{up}
		}
	else 
		{
		Run, C:\Program Files\ReelSteadyGoTrial\ReelSteadyGoTrial.exe
		sleep, 6000
		send #{up}
		}
	Loop {
		sleep, 1000
		DllCall("SetCursorPos", "int", 109, "int", 1012) 
		Click 								; Load video button
		sleep, 300
		Send +{TAB 2}
		Send {End} {Home}
		sleep, 300
		Send {Enter} 
		tooltip % FileNum
		sleep, 300
		Send {End} 
		FileNum--					; select the next file
		sleep, 100
		Send {Up %FileNum%} 
		sleep, 100
		Send {Enter}
		
		sleep 1000
		
		gosub bluecheck
		
		; ; ======== OTHER GENERAL SETTINGS TO BE CHANGED HERE ===========

		if SSZZ != 5050
			{
			DllCall("SetCursorPos", "int", 3770, "int", 2042)
			click								; Settings button
			sleep, 1000
			if ZZ != 50 
				{
				DllCall("SetCursorPos", "int", 1919, "int", 917)
				sleep 300			
				Send {LButton down}			; move smoothness bar
				sleep 300
				mousemove, %pixZZ%, 918, 8
				sleep 300
				Send {LButton up}
				sleep, 1000
				}
			if Uncheck=1
				{
				DllCall("SetCursorPos", "int", 1500, "int", 1106)
				click 				; lock smooth with speed untick
				DllCall("SetCursorPos", "int", pixZZ, "int", 917)
				sleep 300			; move smoothness bar again
				Send {LButton down}
				sleep 300
				mousemove, %pixSS%, 918, 8
				sleep 300
				Send {LButton up}
				sleep, 1000
				}
			

			DllCall("SetCursorPos", "int", 1885, "int", 1280)
			sleep 500					; confirm setting
			click								
			}
		; ; =====================   RENDER   ===========================
		
		sleep 1000
		gosub bluecheck
		
		DllCall("SetCursorPos", "int", 3733, "int", 1008)
		click								; Save Button
		
		Loop{
			sleep 4000
		
			 t1:=A_TickCount, X:=Y:=""

			Text:="|<>*117$71.zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzbzzzzzzzzzzzDzzzzzzzzzzyTzzzzzzzzzzwzzzzzzzzzzztzzzzzzzzzzzkTy0yDyDUTz1UDk0SDsy0Ds00D00wTls0DU0QSDkszXVwD7kssTlsyD7wQDlzzzXlwQTsszVzzs7VssTklzUTs0DXXk01Xz0D00T77U037y0C3sz4T7zyDwsMTly8yDzwTtslz3wFwDssTXlXy7w7wTlsz733kDsDsC3kw0D00TkTs0Dk00z0Mzlzs0zk4DzbzzzzyDzwz"

			 if (ok:=FindText(1822-250, 1066-150, 1822+250, 1066+150, 0.04, 0.04, Text))
			 {
			   CoordMode, Mouse
			   X:=ok.1.x, Y:=ok.1.y, Comment:=ok.1.id
			 }


			 for i,v in ok
			   if (i<=2)
				 FindText.MouseTip(ok[i].x, ok[i].y)
			
			tooltip, working,,,2

				if (X>1 && Y>1)	
					advance:=1
			 } until advance=1
			 
			 advance:=0

			tooltip, ,,,2
		
		
		} Until (FileNum = 0) ;Change this number to n+1 where n is the number of files in the folder
		
		MsgBox, Done
		Msgbox, 1, Clean folders, run smoothed.ahk?
		IfMsgBox OK
			run %A_ScriptDir%\smoothed.ahk
		
		exitapp
	}


x::
esc::
	Reload
return



bluecheck:
	sleep 4000
	loop {
		sleep 2000
		DllCall("SetCursorPos", "int", 3733, "int", 1000)
		 t1:=A_TickCount, X:=Y:=""

		Text:="|<>0x4FB2FF@1.00$2.y"

		 if (ok:=FindText(3784-2, 996-2, 3784+2, 996+2, 0, 0, Text))
		 {
		   CoordMode, Mouse
		   X:=ok.1.x, Y:=ok.1.y, Comment:=ok.1.id
		   ; Click, %X%, %Y%
		 }

		 if (Round(ok.MaxIndex()) > 1)
			advance:=1

		 ; for i,v in ok
		   ; if (i<=2)
			 ; FindText.MouseTip(ok[i].x, ok[i].y)
		} until advance=1
		advance:=0
		CoordMode, window
return

