


;----- hold down key move mouse left right to paste in bigger or smaller values 

q::
   mousegetpos x,y
   send ^c
   boxnum:=clipboard
   goto boxedit
Return
	
boxedit:
loop {
	mousegetpos xnew, ynew
	SetFormat, IntegerFast, D
	boxnum:=clipboard*((xnew-x)/x+1)/2
	send ^a %boxnum%
	qstate:=getkeystate("q","p")
	if (qstate=0) {
		break
	}
}
return

;------

f3 & f2::											; flop image aacc changes depending on the instance
	winactivate % davinci
	WinGet, hWnd, ID, A
	oAcc := Acc_Get("Object", "4.2.2.3.1.2.1.1.3.1.3.1.1.1.1.5.1.1.1.1.1.1.13.1", 0, "ahk_id " hWnd)
	oAcc.accDoDefaultAction(0)   
	oAcc := ""                  
return

f3 & f4::											; flip image
	winactivate % davinci
	WinGet, hWnd, ID, A
	oAcc := Acc_Get("Object", "4.2.2.3.1.2.1.1.3.1.3.1.1.1.1.5.1.1.1.1.1.1.13.1", 0, "ahk_id " hWnd)
	oAcc.accDoDefaultAction(0) 
	oAcc := ""
return

;------ FindText()


Numpad0::

 t1:=A_TickCount, X:=Y:=""

Text:="|<Flip flop buttons>*59$56.zzzzzzzzzy00Dzzw00T001zzy003bzzDzzDzyNzTnzznsDaTrwzzwy3tbxzDzzDlyNzTnzznwTaFrYzzwzztYBVDzzDzyN3MHzzn01aEq4zzwzztYxtDzzDzyNzTnzznwTaTrwzzwz7tbxzDzzDUyNzTnzznsDaTzwzzwzztk00TzzU00y00Tzzw00zzzzzzzzzzU"

 if (ok:=FindText(1798-150000, 327-150000, 1798+150000, 327+150000, 0, 0, Text))
 
 {
   CoordMode, Mouse
   X:=ok.1.x, Y:=ok.1.y, Comment:=ok.1.id
    X:=X-20
	Click, %X% , %Y%
 }
 


 ; MsgBox, 4096, Tip, % "Found:`t" Round(ok.MaxIndex())
   ; . "`n`nTime:`t" (A_TickCount-t1) " ms"
   ; . "`n`nPos:`t" X ", " Y
   ; . "`n`nResult:`t" (ok ? "Success !" : "Failed !")

 for i,v in ok
   if (i<=2)
     FindText.MouseTip(ok[i].x, ok[i].y)
	 
	 
return


Numpad1::

 t1:=A_TickCount, X:=Y:=""

Text:="|<Flip flop buttons>*59$56.zzzzzzzzzy00Dzzw00T001zzy003bzzDzzDzyNzTnzznsDaTrwzzwy3tbxzDzzDlyNzTnzznwTaFrYzzwzztYBVDzzDzyN3MHzzn01aEq4zzwzztYxtDzzDzyNzTnzznwTaTrwzzwz7tbxzDzzDUyNzTnzznsDaTzwzzwzztk00TzzU00y00Tzzw00zzzzzzzzzzU"

 if (ok:=FindText(1798-150000, 327-150000, 1798+150000, 327+150000, 0, 0, Text))
 
 {
   CoordMode, Mouse
   X:=ok.1.x, Y:=ok.1.y, Comment:=ok.1.id
    X:=X+20
	Click, %X% , %Y%
 }
 


 ; MsgBox, 4096, Tip, % "Found:`t" Round(ok.MaxIndex())
   ; . "`n`nTime:`t" (A_TickCount-t1) " ms"
   ; . "`n`nPos:`t" X ", " Y
   ; . "`n`nResult:`t" (ok ? "Success !" : "Failed !")

 for i,v in ok
   if (i<=2)
     FindText.MouseTip(ok[i].x, ok[i].y)
	 
	 
; return


;-------------------------probably the way forward - universal pixchanger
;;;;;;;;;;;;;;;;;;;;;;;REMEMEBR TO SET VARS
q:={x:2500,y:500}
start:=A_TickCount


q::                                             
	goto tweaker
return

q up::
	scrollmod:=0
	Send {LButton up}
	DllCall("SetCursorPos", "int", skip.x, "int", skip.y)
return

^!q::
	key:="q"
	goto altgrkey
return

^!q up::
	goto altgrkeyup
return 

tweaker:
	key:=A_ThisHotKey
	dif:=(A_tickcount-start)
	if (dif > 300){
		start:=A_TickCount
		skip := GetCursorPos()
		DllCall("SetCursorPos", "int", %key%.x, "int",%key%.y)
		scrollmod:=1
		Send {LButton down}
		Keywait %key% 
		}	
	else {
		DllCall("SetCursorPos", "int", %key%.x, "int",%key%.y)
		Send {LButton 2}
		Keywait %key% 
		}
return

altgrkey:
	skip := GetCursorPos()
	DllCall("SetCursorPos", "int", %key%.x, "int",%key%.y)
	Keywait %key%
return

altgrkeyup:
	newpos := GetCursorPos()
	%key%.x := newpos.x, %key%.y := newpos.y
return