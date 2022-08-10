#NoEnv
#SingleInstance force

f7::
	Loop
	{
		Random, waitvar, -10000, 10000
		sleep, waitvar
		send ^{pgdn}
		mousemove, waitvar/100, waitvar/200, 50, r
	}
return

esc::
	exitapp
return

