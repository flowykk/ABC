.include "macrolib.asm"

.text
.global main
# /Users/danila/asmProjects/ihw3/test.txt
main:       
	jal read_from_file

	PrintPrompt(ln)
    	PrintPrompt(read_str)
    	PrintString(t5)

  	dotask(t5)
  	
  	PrintPrompt(result_str)
  	PrintString(t3)
  	
  	jal out_in_file
  	
  	Exit()
