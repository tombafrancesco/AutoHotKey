#include C:\Users\tomba\OneDrive\Desktop\AutoHotKey\lib\Acc.ahk

hideacc:=0

Numpad4:: ;get information from object under cursor, 'AccViewer Basic' (cf. AccViewer.ahk)
hideacc:=(hideacc-1)**2
if (hideacc=0)
	tooltip
else {
ComObjError(False)
oAcc := Acc_ObjectFromPoint(vChildId)
vAccRoleNum := oAcc.accRole(vChildId)
vAccRoleNumHex := Format("0x{:X}", vAccRoleNum)
vAccStateNum := oAcc.accState(vChildId)
vAccStateNumHex := Format("0x{:X}", vAccStateNum)
oRect := Acc_Location(oAcc, vChildId)

vAccName := oAcc.accName(vChildId)
vAccValue := oAcc.accValue(vChildId)
vAccRoleText := Acc_GetRoleText(oAcc.accRole(vChildId))
vAccStateText := Acc_GetStateText(oAcc.accState(vChildId))
vAccStateTextAll := JEE_AccGetStateTextAll(vAccStateNum)
vAccAction := oAcc.accDefaultAction(vChildId)
vAccFocus := oAcc.accFocus
vAccSelection := JEE_AccSelection(oAcc)
StrReplace(vAccSelection, ",",, vCount), vCount += 1
vAccSelectionCount := (vAccSelection = "") ? 0 : vCount
vAccChildCount := oAcc.accChildCount
vAccLocation := Format("X{} Y{} W{} H{}", oRect.x, oRect.y, oRect.w, oRect.h)
vAccDescription := oAcc.accDescription(vChildId)
vAccKeyboard := oAcc.accKeyboardShortCut(vChildId)
vAccHelp := oAcc.accHelp(vChildId)
vAccHelpTopic := oAcc.accHelpTopic(vChildId)
hWnd := Acc_WindowFromObject(oAcc)
vAccPath := JEE_AccGetPath(oAcc, hWnd)
; vAccPath := "--" ;not implemented                     ;why??
oAcc := ""
ComObjError(True)

;get window/control details
if (hWndParent := DllCall("user32\GetParent", Ptr,hWnd, Ptr))
{
	WinGetTitle, vWinTitle, % "ahk_id " hWndParent
	ControlGetText, vWinText,, % "ahk_id " hWnd
	WinGetClass, vWinClass, % "ahk_id " hWnd

	;control hWnd to ClassNN
	WinGet, vCtlList, ControlList, % "ahk_id " hWndParent
	Loop, Parse, vCtlList, `n
	{
		ControlGet, hCtl, Hwnd,, % A_LoopField, % "ahk_id " hWndParent
		if (hCtl = hWnd)
		{
			vWinClass := A_LoopField
			break
		}
	}
	ControlGetPos, vPosX, vPosY, vPosW, vPosH,, % "ahk_id " hWnd
	WinGet, vPName, ProcessName, % "ahk_id " hWndParent
	WinGet, vPID, PID, % "ahk_id " hWndParent
}
else
{
	WinGetTitle, vWinTitle, % "ahk_id " hWnd
	WinGetText, vWinText, % "ahk_id " hWnd
	WinGetClass, vWinClass, % "ahk_id " hWnd
	WinGetPos, vPosX, vPosY, vPosW, vPosH, % "ahk_id " hWnd
	WinGet, vPName, ProcessName, % "ahk_id " hWnd
	WinGet, vPID, PID, % "ahk_id " hWnd
}
hWnd := Format("0x{:X}", hWnd)
vWinPos := Format("X{} Y{} W{} H{}", vPosX, vPosY, vPosW, vPosH)

;truncate variables with long text
vList := "vWinText,vAccName,vAccValue"
Loop, Parse, vList, % ","
{
	%A_LoopField% := StrReplace(%A_LoopField%, "`r", " ")
	%A_LoopField% := StrReplace(%A_LoopField%, "`n", " ")
	if (StrLen(%A_LoopField%) > 100)
		%A_LoopField% := SubStr(%A_LoopField%, 1, 100) "..."
}

vOutput = ;continuation section
(
Name: %vAccName%
Value: %vAccValue%
Role: %vAccRoleText% (%vAccRoleNumHex%) (%vAccRoleNum%)
State: %vAccStateText% (%vAccStateNumHex%)
State (All): %vAccStateTextAll%
Action: %vAccAction%
Focused Item: %vAccFocus%
Selected Items: %vAccSelection%
Selection Count: %vAccSelectionCount%
Child Count: %vAccChildCount%

Location: %vAccLocation%
Description: %vAccDescription%
Keyboard: %vAccKeyboard%
Help: %vAccHelp%
HelpTopic: %vAccHelpTopic%

Child ID: %vChildId%
Path: %vAccPath%

WinTitle: %vWinTitle%
Text: %vWinText%
HWnd: %hWnd%
Location: %vWinPos%
Class(NN): %vWinClass%
Process: %vPName%
Proc ID: %vPID%
)
ToolTip, % vOutput
}
return

;==================================================

JEE_AccGetStateTextAll(vState)
{
	;sources: WinUser.h, oleacc.h
	;e.g. STATE_SYSTEM_SELECTED := 0x2
	static oArray := {0x1:"UNAVAILABLE"
	, 0x2:"SELECTED"
	, 0x4:"FOCUSED"
	, 0x8:"PRESSED"
	, 0x10:"CHECKED"
	, 0x20:"MIXED"
	, 0x40:"READONLY"
	, 0x80:"HOTTRACKED"
	, 0x100:"DEFAULT"
	, 0x200:"EXPANDED"
	, 0x400:"COLLAPSED"
	, 0x800:"BUSY"
	, 0x1000:"FLOATING"
	, 0x2000:"MARQUEED"
	, 0x4000:"ANIMATED"
	, 0x8000:"INVISIBLE"
	, 0x10000:"OFFSCREEN"
	, 0x20000:"SIZEABLE"
	, 0x40000:"MOVEABLE"
	, 0x80000:"SELFVOICING"
	, 0x100000:"FOCUSABLE"
	, 0x200000:"SELECTABLE"
	, 0x400000:"LINKED"
	, 0x800000:"TRAVERSED"
	, 0x1000000:"MULTISELECTABLE"
	, 0x2000000:"EXTSELECTABLE"
	, 0x4000000:"ALERT_LOW"
	, 0x8000000:"ALERT_MEDIUM"
	, 0x10000000:"ALERT_HIGH"
	, 0x20000000:"PROTECTED"
	, 0x40000000:"HASPOPUP"}
	vNum := 1
	Loop, 30
	{
		if vState & vNum
			vOutput .= oArray[vNum] " "
		vNum <<= 1 ;multiply by 2
	}
	vOutput := RTrim(vOutput)
	return Format("{:L}", vOutput)
}

;==================================================

JEE_AccSelection(oAcc)
{
	vSel := oAcc.accSelection ;if one item selected, gets index, if multiple items selected, gets indexes as object
	if IsObject(vSel)
	{
		oSel := vSel, vSel := ""
		while oSel.Next(vValue, vType)
			vSel .= (A_Index=1?"":",") vValue
		oSel := ""
	}
	return vSel
}

;==================================================

numpad5:: ;acc get path of element under the cursor
WinGet, hWnd, ID, A
;hWnd := -1 ;get all possible ancestors
oAcc := Acc_ObjectFromPoint(vChildID)
vAccPath := JEE_AccGetPath(oAcc, hWnd)
if vChildID
	MsgBox, % Clipboard := vAccPath " c" vChildID
else
	MsgBox, % Clipboard := vAccPath

;use acc path (check that the acc path is correct)
oAcc := Acc_Get("Object", vAccPath, vChildID, "ahk_id " hWnd)
vName := vValue := ""
try vName := oAcc.accName(vChildID)
try vValue := oAcc.accValue(vChildID)
MsgBox, % vName "`r`n" vValue
return

;==================================================

;note: path might be too short e.g. menu items
;note: path might be too long (I haven't seen this happen)
;note: if there is ambiguity identifying the index, 'or' is used (see JEE_AccGetEnumIndex)
JEE_AccGetPath(oAcc, hWnd:="")
{
	local
	if (hWnd = "")
		hWnd := Acc_WindowFromObject(oAcc)
		, hWnd := DllCall("user32\GetParent", Ptr,hWnd, Ptr)
	vAccPath := ""
	vIsMatch := 0
	if (hWnd = -1) ;get all possible ancestors
		Loop
		{
			vIndex := JEE_AccGetEnumIndex(oAcc)
			if !vIndex
				break
			vAccPath := vIndex (A_Index=1?"":".") vAccPath
			oAcc := oAcc.accParent
		}
	else
		Loop
		{
			vIndex := JEE_AccGetEnumIndex(oAcc)
			hWnd2 := Acc_WindowFromObject(oAcc)
			if !vIsMatch && (hWnd = hWnd2)
				vIsMatch := 1
			if vIsMatch && !(hWnd = hWnd2)
				break
			vAccPath := vIndex (A_Index=1?"":".") vAccPath
			oAcc := oAcc.accParent
		}
	if vIsMatch
		return SubStr(vAccPath, InStr(vAccPath, ".")+1)
	return vAccPath
}

;==================================================

;note: AccViewer uses a mod of Acc_Location that returns a 'pos' key,
;this function is compatible with the older and AccViewer versions of Acc_Location
;note: if there is ambiguity identifying the index, 'or' is used
JEE_AccGetEnumIndex(oAcc, vChildID:=0)
{
	local
	vOutput := ""
	vAccState := oAcc.accState(0)
	if !vChildID
	{
		Acc_Location(oAcc, 0, vChildPos)
		for _, oChild in Acc_Children(Acc_Parent(oAcc))
		{
			if !(vAccState = oChild.accState(0))
				continue
			Acc_Location(oChild, 0, vPos)
			if IsObject(oChild) && (vPos = vChildPos)
				vOutput .= A_Index "or"
		}
	}
	else
	{
		Acc_Location(oAcc, vChildID, vChildPos)
		for _, oChild in Acc_Children(oAcc)
		{
			if !(vAccState = oChild.accState(0))
				continue
			Acc_Location(oAcc, oChild, vPos)
			if !IsObject(oChild) && (vPos = vChildPos)
				vOutput .= A_Index "or"
		}
	}
	return SubStr(vOutput, 1, -2)
}

;==================================================

numpad6:: ;acc get info for element under the cursor and ancestors
WinGet, hWnd, ID, A
oAcc := Acc_ObjectFromPoint()
vOutput := ""
Loop, 10
{
	vOutput .= Acc_WindowFromObject(oAcc) "|" Format("0x{:X}", oAcc.accRole(0)) "|" RegExReplace(oAcc.accName(0), "s)[`r`n].*", "...") "|" RegExReplace(oAcc.accValue(0), "s)[`r`n].*", "...") "`r`n"
	oAcc := oAcc.accParent
}
Clipboard := vOutput
MsgBox, % vOutput
return