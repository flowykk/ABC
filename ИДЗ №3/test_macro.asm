.include "macrolib.asm"

.text
.global test_macro

test_macro:       
  	
  	# Тест 3
  	li 	t1 1 
  	ShowMessage(test3, t1)
  	
	ReadFile()
	
    	PrintString(read_str, t5)

  	StringProcessing(t5)
  	PrintString(res, t3)
  	
	WriteFile()
  	
  	# Тест 4
  	li 	t1 1 
  	ShowMessage(test4, t1)
  	
	ReadFile()
	
    	PrintString(read_str, t5)

  	StringProcessing(t5)
  	PrintString(res, t3)
  	
	WriteFile()
  	
ret
