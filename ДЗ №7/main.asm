.include "macrolib.asm"

.text
.global main

main: 
	jal digit
	
	Exit()
