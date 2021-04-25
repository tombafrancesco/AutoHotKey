#SingleInstance Force
#include C:\Users\tomba\OneDrive\Desktop\AutoHotKey\lib\Acc.ahk
#include C:\Users\tomba\OneDrive\Desktop\AutoHotKey\lib\Anchor.ahk


GetElementByName(AccObj, name) {									;function for URL retrieval in chrome
   if (AccObj.accName(0) = name)
      return AccObj
   
   for k, v in Acc_Children(AccObj)
      if IsObject(obj := GetElementByName(v, name))
         return obj
}

; numpad0::
	; hwndChrome := WinExist("ahk_class Chrome_WidgetWin_1")								;magic that searches for "youtube.com" in current url
	; AccChrome := Acc_ObjectFromWindow(hwndChrome)
	; AccAddressBar := GetElementByName(AccChrome, "Address and search bar")				;spits out current url
	; msgbox % AccAddressBar.accValue(0)
	; ytpos := instr( AccAddressBar.accValue(0), "youtube.com")							;finds needle "youtube.com" in haystack "accbar.."
	; msgbox % ytpos
; return


Morse(timeout = 250) { 
   tout := timeout/1000
   key := RegExReplace(A_ThisHotKey,"[\*\~\$\#\+\!\^]")
   Loop {
      t := A_TickCount
      KeyWait %key%
      Pattern .= A_TickCount-t > timeout
      KeyWait %key%,DT%tout%
      If (ErrorLevel)
         Return Pattern
   }
}


