#NoEnv
#SingleInstance force
; #include C:\Users\tomba\OneDrive\Desktop\AutoHotKey\lib\Acc.ahk
; #include C:\Users\tomba\OneDrive\Desktop\AutoHotKey\lib\func.ahk
; #include C:\Users\tomba\OneDrive\Desktop\AutoHotKey\lib\gdip.ahk


davinci := "DaVinci Resolve by Blackmagic Design - 17.1.0"

; Numpad0:: 
	; winactivate % davinci
   ; WinGet, hWnd, ID, A														; OPEN MENU, SELECT MENU ITEM
   ; oAcc := Acc_Get("Object", "4.1.11", 0, "ahk_id " hWnd)
   ; msgBox, % oAcc.accName(0)
   ; oAcc.accDoDefaultAction(0)
   ; ; oAcc := Acc_Get("Object", "4.1.11.1.9", 0, "ahk_id " hWnd)
   ; ; oAcc.accDoDefaultAction(0)
   ; oAcc := ""
; return


; numpad0::
	; WinGet, hWnd, ID, A
	; oAcc := Acc_Get("Object", "4.1.2.1.2.1", 0, "ahk_id " hWnd)				; REAL PRETTY WAY OF GETTING CLICKS IN THE RIGHT PLACES
	; ; msgBox, % oAcc.accName(0)
	; oRect := Acc_Location(oAcc)
	; ; MsgBox, % oRect.x " " oRect.y " " oRect.w " " oRect.h
	; DllCall("SetCursorPos", "int", oRect.x + oRect.w/2 , "int", oRect.y+oRect.h/2)
	; oAcc := ""
; return

; Numpad0:: 
	; winactivate % davinci
   ; WinGet, hWnd, ID, A															; IS PAGE ACTIVE - page path technique
   ; oAcc := Acc_Get("Object", "4.2.2.3", 0, "ahk_id " hWnd)						; 4.2.2.1 - 4.2.2.7     NOTE!! 5,6 inverted
	  ; msgBox, % oAcc.accState(0)													; color:6, fairlight: 5
	  ; if (oAcc.accState(0)=0)														; 0 if selected
		; page:= "edit"																; use to get rid of pg buttons??
; return

; Numpad0:: 
	; winactivate % davinci
   ; WinGet, hWnd, ID, A															; FIND IF PAGE IS SELECTED - button technique
   ; oAcc := Acc_Get("Object", "4.2.1.1.1.1.2.5", 0, "ahk_id " hWnd)
	  ; ; msgBox, % oAcc.accState(0)
	  ; if (oAcc.accState(0)=1048592)												; 1048592 is selected (only for pages)
		; page:= "edit"															; 1048576 is unselected
; return

; Numpad0:: 
	; winactivate % davinci
   ; WinGet, hWnd, ID, A																; IS PAGE ACTIVE - page path technique
   ; oAcc := Acc_Get("Object", "4.2.2.3.1.1.1.3.1.3", 0, "ahk_id " hWnd)				; 4.2.2.1 - 4.2.2.7     NOTE!! 5,6 inverted
	  ; msgBox, % oAcc.accState(0)													; color:6, fairlight: 5
	  ; if (oAcc.accState(0)=0)														; 0 if selected
		; page:= "edit"																; use to get rid of pg buttons??
; return






; q::
   ; winactivate DaVinci Resolve by Blackmagic Design - 17.1.0
   ; WinGet, hWnd, ID, A
   ; oAcc := Acc_Get("Object", "4.2.2.6.1.2.3.2.2.1.1.2.1.8.1.2.1.2.2.1.4.4", 0, "ahk_id " hWnd)
   ; oAcc.accDoDefaultAction(0)
   ; mousegetpos x,y
   ; send ^c
   ; boxnum:=clipboard
   ; goto boxedit
; Return
	
; boxedit:
; loop {
	; mousegetpos xnew, ynew
	; boxnum:=(xnew-x)/x
	; send ^a %boxnum%
	; qstate:=getkeystate("q","p")
	; if (qstate=0)
		; break
; }
; return




; q:: 															;Notepad - get status bar text
; WinGet, hWnd, ID, A
; oAcc := Acc_Get("Object", "3", 0, "ahk_id " hWnd)
; MsgBox, % oAcc.accName(2)
; msgBox, % oAcc.accDefaultAction(2)
; oAcc.accDoDefaultAction(2)
; oAcc := ""
; return


; open close toggle inspector:

	; if (page="edit") {
		; oAcc := Acc_Get("Object", "4.2.2.3.1.2.1", 0, "ahk_id " hWnd)	; inspector for any monitor setup
		; if (oAcc.accState(0)=0)											; inspector is open
			; insp:=1
		; else 
			; insp:=0
		
		; oAcc := Acc_Get("Object", "4.2.2.3.1.1.1.3", 0, "ahk_id " hWnd)
		; if (oAcc.accState(0)=0) {											;fullscreen timeline 
			; oAcc := Acc_Get("Object", "4.2.2.3.1.1.1.3.1.3", 0, "ahk_id " hWnd)
			; if (mode=2) {
				; oAcc.accDoDefaultAction(0)
				; }
			; else if (mode=1)
			; }
		; else {Acc_Get("Object", "4.2.2.3.1.1.1.2", 0, "ahk_id " hWnd)
			; if (oAcc.accState(0)=0) {										;dual screen norm timeline
				; oAcc := Acc_Get("Object", "4.2.2.3.1.1.1.2.1.3", 0, "ahk_id " hWnd)
				; oAcc.accDoDefaultAction(0)
				; }
			; else {
				; oAcc := Acc_Get("Object", "2.2.3.1.1.1.1.2.5", 0, "ahk_id " hWnd)
				; oAcc.accDoDefaultAction(0)
				
				; }
; return


; $AppsKey::
	; if WinActive("ahk_exe chrome.exe") 
	; {																						;Language Reactor tool to skip around captions. uses pgup,pgdn,appskey
		; hwndChrome := WinExist("ahk_class Chrome_WidgetWin_1")								;magic that finds current url
		; AccChrome := Acc_ObjectFromWindow(hwndChrome)
		; AccAddressBar := GetElementByName(AccChrome, "Address and search bar")				;spits out current url
		; ; msgbox % AccAddressBar.accValue(0)
		; ytpos := instr( AccAddressBar.accValue(0), "netflix.com")							;finds needle "netflix.com" in haystack "accaddress..."
		; ; msgbox % ytpos
		; if (ytpos > 0)
		; {	
			; capwheel := 1
			; Gui, 96: +ToolWindow -Caption +AlwaysOnTop +LastFound
			; Gui, 96: Color, ff0000
			; Gui, 96: Show, % "x" 0 " y" 1050 " w" 10 " h" 10 " NA"
		; }
		; else
		; {
			; capwheel := 0
			; Gui, 96:  Hide
		; }
	; }
	; else 
	; {
		; capwheel := 0
		; Gui, 96:  Hide
	; }
; Return

; #if (capwheel = 1) && WinActive("ahk_exe chrome.exe")

; pgup::
	; if (A_timesincepriorhotkey<500)
		; send a
	; else
		; send s
; return

; pgdn::
	; send d
; return

; #if