.include "macrolib.asm"

.text
.global test

test:       
	# Тест 1
	li 	t1 1 
  	ShowMessage(test1, t1)
	jal read_from_file
	
    	PrintString(read_str, t5)

  	StringProcessing(t5)
  	PrintString(res, t3)
  	
  	jal out_in_file
  	
  	
  	# Тест 2
  	li 	t1 1 
  	ShowMessage(test2, t1)
	jal read_from_file
	
    	PrintString(read_str, t5)

  	StringProcessing(t5)
  	PrintString(res, t3)
  	
  	jal out_in_file
  	
ret
