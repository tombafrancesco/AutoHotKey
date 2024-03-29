#SingleInstance,Force   ;~ Adapted from Cerberus    https://www.autohotkey.com/boards/viewtopic.php?p=319004#p319698  



global Count := 329, Shell := 1, Image := 0, File := "shell32.dll", Height := A_ScreenHeight - 170 ;Define constants
CreateGui:
Gui, Destroy
Gui, -MinimizeBox -MaximizeBox
Gui, Add,Radio,vShell32  gRadioClick Checked%Shell% Check,shell32.dll
Gui, Add,Radio,vImageRes gRadioClick Checked%Image% ,imageres.dll
Gui, Add,ListView,h%Height% w180 gListClick,Icon &amp; Number
ImageListID := IL_Create(Count)
LV_SetImageList(ImageListID)
loop, % Count
  IL_Add(ImageListID,File,A_Index) 
loop, % Count
  LV_Add("Icon" A_Index,A_Index)
LV_ModifyCol("Hdr")  ; Auto-adjust the column widths.
Gui Show
return

RadioClick:
	Gui, Submit
	Count := (Shell32 ? 329 : 412)
	File := (Shell32 ? "shell32.dll" : "imageres.dll")
	Shell := Shell32 ? 1 : 0
	Image := Shell32 ? 0 : 1
	gosub, CreateGui
return

ListClick(){
  If (A_GuiEvent = "DoubleClick"){
    Clipboard := "Menu, Tray, Icon, " A_WinDir "\system32\" File "," A_EventInfo " `;Set custom Script icon`n"
    MsgBox,,Your Clipboard now has, % clipboard
}}

Escape::
GuiClose:
ExitApp



