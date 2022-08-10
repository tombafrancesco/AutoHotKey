#NoEnv
SendMode Input
SetWorkingDir, C:\Users\tomba\OneDrive\Desktop\AutoHotKey
; #include %A_WorkingDir%\lib\func.ahk  	; general function library
; #include %A_WorkingDir%\lib\Acc.ahk 		; can be included for Acc functions
; #include %A_WorkingDir%\lib\resfunc.ahk  	; Resolve function library
#MaxHotkeysPerInterval 120				; mostly for FASTSCROLL
#SingleInstance Force


; o o o o o o o o o o o o o         GOSUB        GOTO        o o o o o o o o o o o o o o o o o 

Scroll:
	t := A_TimeSincePriorHotkey
	if (A_PriorHotkey = A_ThisHotkey && t < timeout)
	{
		; Remember how many times we've scrolled in the current direction
		distance++

		; Calculate acceleration factor using a 1/x curve
		v := (t < 80 && t > 1) ? (250.0 / t) - 1 : 1

		; Apply boost
		if (boost > 1 && distance > boost)
		{
			; Hold onto the highest speed we've achieved during this boost
			if (v > vmax)
				vmax := v
			else
				v := vmax

			v *= distance / boost
		}
		; Validate
		v := (v > 1) ? ((v > limit) ? limit : Floor(v)) : 1
		
		MouseClick, %A_ThisHotkey%, , , v
	}
	else
	{
		; Combo broken, so reset session variables
		distance := 0
		vmax := 1

		MouseClick %A_ThisHotkey%
	}
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