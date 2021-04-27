#NoEnv
#SingleInstance force


containtxt(in,out) {
	saved := clipboardall
	clipboard := ""
	sleep 8
	send ^x
	ClipWait,.2						;- wait for the clipboard to contain data
	if (!ErrorLevel)  {				;- if NOT ErrorLevel clipwait found data on the clipboard
		sendraw %in%
		send ^v
		sendraw %out%							
		}
	else {
		sendraw % in out
		send {left}
		}
	clipboard := saved
	saved := ""
	send {esc}
return
}


!^9::
	containtxt("(",")")
return


!^'::
	containtxt("'","'")
return

!^2::
	saved := clipboardall
	clipboard := ""
	sleep 8
	send ^x
	ClipWait,.2						;- wait for the clipboard to contain data
	if (!ErrorLevel)  {				;- if NOT ErrorLevel clipwait found data on the clipboard
		send % chr(34)
		send ^v
		send % chr(34)						
		}
	else {
		send % chr(34) chr(34)
		send {left}
		}
	clipboard := saved
	saved := ""
	send {esc}
return

!^[::
	saved := clipboardall
	clipboard := ""
	send ^x
	ClipWait,.2						;- wait for the clipboard to contain data
	if (!ErrorLevel)  {				;- if NOT ErrorLevel: clipwait found data on the clipboard
		send {{}^{v}{enter}{}}							
		}
	else {
		send {{}{enter}{tab}{enter}{}}{up}
		}
	clipboard := saved
	saved := ""
	send {esc}
return
