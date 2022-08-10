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
send mkdir smoothed
sleep 10
send {enter}
sleep 10
send cd {tab}
sleep 10
send {enter}
sleep 10
send Move-Item -Path .\*smoothed.mp4 -Destination H:\DCIM\smoothed
sleep 10
send {enter}
sleep 10
send cd..
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

