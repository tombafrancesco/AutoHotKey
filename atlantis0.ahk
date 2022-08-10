#NoEnv
SendMode Input
SetWorkingDir, C:\Users\tomba\OneDrive\Desktop\AutoHotKey
#include C:\Users\tomba\OneDrive\Desktop\AutoHotKey\Var.ahk			; Resolve variables
#include C:\Users\tomba\OneDrive\Desktop\AutoHotKey\lib\func.ahk  	; general function library
; #include C:\Users\tomba\OneDrive\Desktop\AutoHotKey\lib\Acc.ahk 		; can be included for Acc functions
; #include C:\Users\tomba\OneDrive\Desktop\AutoHotKey\lib\resfunc.ahk  	; Resolve function library
#include C:\Users\tomba\OneDrive\Desktop\AutoHotKey\GoSub1.ahk
#SingleInstance Force


;                                                          0             
;                    000                                   0             
;            0         0                         0                       
;            0         0                         0                       
;  0000    000000      0      0000    000000   000000    000      000000 
;      0     0         0          0    00  0     0         0      0   00 
;  00000     0         0      00000    0   0     0         0      00000  
; 0    0     0         0     0    0    0   0     0         0          00 
; 0   00     0  00     0     0   00    0   0     0  00     0     00   00 
;  000 00    0000   0000000   000 00  000 0000   0000   0000000  000000  


; ---------------------------------------------- GENERAL CASE


#if !winactive("ahk_exe RESOLVE.EXE")


$f17::											;1,1
	send ^+h
Return


$f18::											;1,2
	send ^+d
Return

$Pause::										;1,3
	send ^+4
Return

$Browser_Stop::									;1,4
	send ^+5
Return

$Browser_Search::								;1,5
	send ^+6
Return

$f16::											;1,6
	send ^+9
Return

$Browser_Home::									;2,1
	send {f4}
Return

; ; ---------- 								HERE ARE JKL 
; $k::
	; send k
	; Keywait, k, t.2
	; if errorlevel 
	; {
		; send !k
	; }
; return


 
; $f13::											;2,5
	; send +p
; Return

; ; !f13::
; ^f13::									
	; send !p
; Return
 
$f14::											;2,6
	send f
Return
 
$f15::											;3,1
	send ^z
return

 
$Media_Stop::									;3,2
	send ^c
Return
 
$Launch_Mail::									;3,3
	send ^x
Return
 
$Launch_Media::									;3,4
	send ^v
Return

; !Launch_Media::	
; ^Launch_Media::									
	; send !v
; Return
 
; $Launch_App1::									;3,5
	; send +c
; Return
 
; >^Launch_App1::	
	; send l
; return	

; ~RCtrl::
	; Keywait, RCtrl, T.2
	; if errorlevel 
		; {
		; }
	; else 
		; if winactive("ahk_exe Vivaldi.exe")
			; send {space}
	; Keywait, RCtrl
; return
		
; ; >^WheelDown::
	; ; send ^!{WheelDown}
; ; Return

; ; >^WheelUp::
	; ; send ^!{WheelUp}
; ; Return


; ; $Browser_Favorites::								;lr dial
	; ; MsgBox, %A_ThisHotkey% was pressed.
; ; Return

; ; $Launch_App2::									;ud dial
	; ; send +c
; ; Return



; SC072 up::						;Hangul on Via -  careful this double presses on via once on down, once up
									; ;blue right dial?
		 ; MsgBox, %A_ThisHotkey% was pressed.

; Return

; VKE9 up::						;Hanja/kanji 
								; ;blue right dial?
	; MsgBox, %A_ThisHotkey% was pressed.

; Return 

; SC15E::							;power OSX on Via
								; ;blue right dial?
	; MsgBox, %A_ThisHotkey% was pressed.


; Return 


								; CENTRE DIALS

$Browser_Favorites::								;LR dial
	send !h
Return

$Launch_App2::										;UD dial
	MsgBox, %A_ThisHotkey% was pressed.
Return

>^up::
	send !{up}
return

>^down::
	send !{down}
return


								; ; BLUE LEFT DIAL
 
; $Media_Prev::									
	; MsgBox, %A_ThisHotkey% was pressed.
; Return

; $Media_Next::									
	; MsgBox, %A_ThisHotkey% was pressed.
; Return
 
; $Media_Play_Pause::								
	; MsgBox, %A_ThisHotkey% was pressed.
; Return


								; RED LEFT DIAL
								
; $Volume_Mute::									
	; MsgBox, %A_ThisHotkey% was pressed.
; Return

; $Volume_Down::									
	; MsgBox, A %A_ThisHotkey% was pressed.
; Return

; $Volume_Up::									
	; MsgBox, %A_ThisHotkey% was pressed.
; Return


								; ; RED RIGHT DIAL
								
; $Browser_Back::									
	; send [
; Return

; $Browser_Forward::								
	; send ]
; Return

; $Browser_Refresh::								
	; send ^q
; Return



								; BLUE RIGHT DIAL
								
VKE9 up::						;Hanja/kanji 				
	send ^{PgUp}
Return 
					


SC15E::							;power OSX on Via
	send ^{PgDn}
Return 

SC072 up::						;Hangul on Via -  careful this double presses on via once on down, once up
	send ^w
Return


								; ; Silver LEFT DIAL      l&r := ,&.        press := SC07E
; SC07E::							; , Comma on via
								; ; Left Dial press
	; if (A_ThisHotkey = A_PriorHotkey)
		; Send !u 
	; else 
	; {
		; Send ^{u 2}
	; }
; Return		
							

								;Silver TOP DIAL
; !PgUp::
; +PgUp::
; ^PgUp::
	; Send {f16}
; Return

; !PgDn::
; +PgDn::
; ^PgDn::
	; Send {f19}
Return




								;Silver BOTTOM DIAL
$WheelLeft::
	Send {WheelRight}
Return

^WheelLeft::
!WheelLeft::
	Send !{home}
Return

$WheelRight::
	Send {WheelLeft}
Return

^WheelRight::
!WheelRight::
	Send !{end}
Return


#if

;                                  00                            00    
;      000                         00                            00    
;       00                                                             
;       00                                                             
;   000000   00000   0000  0000  0000     00 000      000000   0000    
; 00   000       00    0    00     00      00  00    00   00     00    
; 0     00        0    0    0      00      0    0   00           00    
; 0     00   000000    00  00      00      0    0   0            00    
; 0     00  00    0     0  0       00      0    0   0            00    
; 0     00  0     0     00 0       00      0    0   00           00    
; 00   000  0   000      000       00      0    0    00   00     00    
;   0000000  0000 00     00     00000000  000  000    00000   00000000 
;                                                                                                                  



#if winactive("ahk_exe RESOLVE.EXE")



f17::											;1,1
	send {del}
Return

!f17::								
^f17::
+f17::
	send {backspace}
Return

$f18::											;1,2
	send !d
Return

$Pause::										;1,3
	send !i
Return

!Pause::
	 t1:=A_TickCount, X:=Y:=""

	Text:="|<>*104$63.zzzzzzzzzzw3zzzzzzzzzyzzzzzznjzzb7XV7zzPzzxrPhazzwTzzStQirzzbzznr/ZqzzwzzyyvRirzz/zzUMwRqzzvTzzzzzzzzyRzzzzzzzzzzzzw"

	 if (ok:=FindText(5712-150000, -1258-150000, 5712+150000, -1258+150000, 0, 0, Text))
	 {
	   CoordMode, Mouse
	   X:=ok.1.x, Y:=ok.1.y, Comment:=ok.1.id
	   X2:=X+234
	   Y2:=Y+24
	   DllCall("SetCursorPos", "int", X2, "int", Y)
	   Click, 
	   Sleep 10
		DllCall("SetCursorPos", "int", X2, "int", Y2)
		Click,	
	 }

	 ; MsgBox, 4096, Tip, % "Found:`t" Round(ok.MaxIndex())
	   ; . "`n`nTime:`t" (A_TickCount-t1) " ms"
	   ; . "`n`nPos:`t" X ", " Y
	   ; . "`n`nResult:`t" (ok ? "Success !" : "Failed !")

	 for i,v in ok
	   if (i<=2)
		 FindText.MouseTip(ok[i].x, ok[i].y)
										  
	 ; MsgBox, %A_ThisHotkey% was pressed.
Return

$Browser_Stop::									;1,4
	send !t
Return

$Browser_Search::								;1,5
	send !n
Return

$f16::											;1,6
		p := Morse()									
	If (p = "0")
	{
		send +6
	}
	Else If (p = "00") 
	{
		send +5
	}
	Else If (p = "01") 	
	{
		send +8
	}
	Else 
	{
		send +7
	}
Return

$Browser_Home::									;2,1
	if (a_thishotkey=a_priorhotkey && a_timesincepriorhotkey<200) {
		send ^f
	}
	else {
		send !f
	}
Return

; ---------- 								HERE ARE JKL 
$k::
	send k
	Keywait, k, t.2
	if errorlevel 
	{
		send !k
	}
return


 
$f13::											;2,5
	send +p
Return

!f13::
^f13::									
	send !p
Return
 
; $f14::											;2,6
	; send ^u
; Return
 
$f15::											;3,1
	keywait, f15, t.2 
	if errorlevel {
		undoscroll:=true
		cursed:=1
		gosub cursing
		tooltip ☻
		}
	else {
			send ^z
		}
return

 
$Media_Stop::									;3,2
	send ^c
Return
 
$Launch_Mail::									;3,3
	send ^x
Return
 
$Launch_Media::									;3,4
	send ^v
Return

!Launch_Media::	
^Launch_Media::									
	send !v
Return
 
$Launch_App1::									;3,5
	send +c
Return
 
>^Launch_App1::	
	send l
return	

; ~RCtrl::
	; Keywait, RCtrl, T.2
	; if errorlevel 
		; {
		; }
	; else 
		; send {space}
	; Keywait, RCtrl
; return
		
; >^WheelDown::
	; send ^!{WheelDown}
; Return

; >^WheelUp::
	; send ^!{WheelUp}
; Return





								; CENTRE DIALS

$Browser_Favorites::								;LR dial
	send !h
Return

$Launch_App2::										;UD dial
	MsgBox, %A_ThisHotkey% was pressed.
Return

>^up::
	send !{up}
return

>^down::
	send !{down}
return


								; RED LEFT DIAL
								
; $Volume_Mute::									
	; MsgBox, %A_ThisHotkey% was pressed.
; Return

; $Volume_Down::									
	; MsgBox, A %A_ThisHotkey% was pressed.
; Return

; $Volume_Up::									
	; MsgBox, %A_ThisHotkey% was pressed.
; Return



								; ; BLUE LEFT DIAL
 
; $Media_Prev::									
	; MsgBox, %A_ThisHotkey% was pressed.
; Return

; $Media_Next::									
	; MsgBox, %A_ThisHotkey% was pressed.
; Return
 
; $Media_Play_Pause::								
	; MsgBox, %A_ThisHotkey% was pressed.
; Return




								; RED RIGHT DIAL
								
$Browser_Back::									
	send [
Return

$Browser_Forward::								
	send ]
Return

$Browser_Refresh::								
	send ^q
Return



								; BLUE RIGHT DIAL
								
VKE9 up::						;Hanja/kanji 				
	send +[
Return 
					

SC15E::							;power OSX on Via
	send +]
Return 

SC072 up::						;Hangul on Via -  careful this double presses on via once on down, once up
	sendraw :
Return


								; Silver LEFT DIAL      l&r := ,&.        press := SC07E
SC07E::							; , Comma on via
								; Left Dial press
	if (A_ThisHotkey = A_PriorHotkey)
		Send !u 
	else 
	{
		Send ^{u 2}
	}
Return								
															
								
								
								;Silver TOP DIAL
!PgUp::
+PgUp::
^PgUp::
	Send {f16}
Return

!PgDn::
+PgDn::
^PgDn::
	Send {f19}
Return




								;Silver BOTTOM DIAL
$WheelLeft::
	Send ^!{wheeldown}
Return

^WheelLeft::
!WheelLeft::
	Send !{home}
Return

$WheelRight::
	Send ^!{wheelup}
Return

^WheelRight::
!WheelRight::
	Send !{end}
Return


#if

