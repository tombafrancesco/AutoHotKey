        #SingleInstance Force
        CoordMode, Screen

        InputBox, FileNum, Reelsteady Batch, How many files?, ,60    ; how many files are in the sd card? 
																	; note this will convert all the video files in the card

         ;Variable Declaration
        i = 1
        LongestLength = 60  							;length of longest clip to process, in seconds
        ScrollAmount := (i - 1) * 2

        sleep, 1000

        if (errorlevel = 0){
	        msgbox, 4, screens, is second screen unplugged? 	; multiple screens can mess up pixel positions
	        IfMsgBox, No 										; unplug second screen and relaunch script
		        Return
	        InputBox, LongestLength, Reelsteady Batch, Longest file mins - roundup, ,60    ; how long is the longest clip in the card in mins?
		        if (errorlevel = 0){
		        RenderTime := LongestLength*60*2.5				; these threee equations work for my system. adjust as you see fit
		        ProcessTime1 := 16+LongestLength*60/5
		        ProcessTime2 := 10+LongestLength*60/10
		        Run, C:\Program Files\ReelSteadyGo\ReelSteadyGo.exe
		        sleep, 6000
		        send #{up}										;maximise window - keeps pixels in right places
		        Loop {
			        sleep, 1000
			          Winactivate ReelSteady GO
			        Click 109,1012						  ;Load video button - change to appropriate pixel position
			        sleep 1000
			        Click 115,1012
			        sleep, 1000
			        Send +{TAB 2}
			        Send {End} 
			        sleep, 1000
			        Send {Enter} 
			        tooltip % i
			        sleep, 1000
			        Send {End} {Home}
			        ScrollAmount := (i - 1)*2			  ;select the next file
			        sleep, 1000
			        Send {Down %ScrollAmount%} {Enter}
			        keywait, a, d t%ProcessTime1% 		  ;Wait %ProcessingTime1% seconds or until the user presses "a"
			        ; click, 3770,2042					  ;Settings button
			        ; sleep, 1000
			        ; click, 1510, 1116					  ;lock smooth with speed untick
			        ; sleep, 1000
			        ; MouseClickDrag, left, 1921, 912, 1794, 918, 4	  ;20% smooth
			        ; sleep, 1000
			        ; click, 1870, 1285					  ;change setting
			        ; keywait, a, d t%ProcessTime2%
			        ; click, 3733, 1012					  ;Save Button
			        sleep 1000
			        keywait, a, d t%RenderTime%
			        i := i + 1
		        } Until i = (FileNum + 1)  				;Change this number to n+1 where n is the number of files in the folder
		
		        MsgBox, Done
		        Msgbox, 1, Clean folders, run smoothed.ahk?
		        IfMsgBox OK
			        run %A_ScriptDir%\smoothed.ahk
	        }
        }

        #SingleInstance Force

        Run powershell.exe
        sleep 300
        send cd h:
        sleep 10
        send {enter}
        sleep 10
        send cd DCIM 
        sleep 10
        send {enter}
        sleep 10
        send cd {tab}
        sleep 10
        send {enter}
        sleep 10
        send mkdir smoothed
        sleep 10
        send {enter}
        sleep 10
        send Move-Item -Path .\*smoothed.mp4 -Destination .\smoothed
        sleep 10
        send {enter}
        sleep 10
        send cd smoothed
        sleep 10
        send {enter}
        sleep 10
        sendraw dir | Rename-Item -NewName {$_.name -replace "_smoothed.mp4",".mp4"}
        sleep 10
        send {enter}