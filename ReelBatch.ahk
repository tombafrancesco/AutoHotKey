#SingleInstance Force
CoordMode, Screen

InputBox, FileNum, Reelsteady Batch, How many files?, ,60

;Variable Declaration
i = 1
LongestLength = 60 ;length of longest clip to process, in seconds
ScrollAmount := (i - 1) * 2
RenderTime := LongestLength*3*1000


sleep, 1000

if (errorlevel = 0){
	msgbox, 4, screens, is second screen unplugged?
	IfMsgBox, No 
		Return
	coordmode mouse screen
	InputBox, LongestLength, Reelsteady Batch, Longest file mins - roundup, ,60
		if (errorlevel = 0){
		RenderTime := LongestLength*60*1000*2.5
		ProcessTime1 := 16000+LongestLength*60*1000/5
		ProcessTime2 := 10000+LongestLength*60*1000/10
		Run, C:\Program Files\ReelSteadyGoTrial\ReelSteadyGoTrial.exe
		Loop {
			sleep, 6000
			sleep, 1000
			Click 109,1012						; Load video button
			Click 109,1012
			sleep, 1000
			Send +{TAB 2}
			Send {End} 
			sleep, 1000
			Send {Enter} 
			tooltip % i
			sleep, 1000
			Send {End} {Home}
			ScrollAmount := (i - 1)*2			; select the next file
			sleep, 1000
			Send {Down %ScrollAmount%} {Enter}
			sleep, ProcessTime1 				; Sync Time Wait
			click, 3770,2042					; Settings button
			sleep, 1000
			click, 1510, 1116					; lock smooth with speed untick
			sleep, 1000
			MouseClickDrag, left, 1921, 912, 1794, 918, 4	; 15% smooth
			sleep, 1000
			click, 1870, 1285					; change setting
			sleep, ProcessTime2
			click, 3733, 1012					; Save Button
			sleep, RenderTime
			i := i + 1
		} Until i = (FileNum + 1) ;Change this number to n+1 where n is the number of files in the folder
		
		MsgBox, Done
		Msgbox, 1, Clean folders, run smoothed.ahk?
		IfMsgBox OK
			run %A_ScriptDir%\smoothed.ahk
	}
}