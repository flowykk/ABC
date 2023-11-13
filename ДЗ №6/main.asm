.include "macrolib.asm"

.data 
empty_string_prompt: 	.asciz "Копирование пустой строки "
empty_str:    .asciz "       "

test_string_prompt: 	.asciz "Копирование строки средней длины"
test_str:    .asciz "test string"

long_string_prompt: 	.asciz "Копирование длинной строки "
long_str: 	   .asciz "long long long long long long long string"

.text
.global main
main:
      	PrintPrompt(prompt1)
      	InputString(main_str, t3)
      	jal strcpy
      	
      	PrintPrompt(empty_string_prompt)
      	PrintPrompt(ln)
        strcpy(empty_str, t3)
        
        PrintPrompt(test_string_prompt)
      	PrintPrompt(ln)
        strcpy(test_str, t3)
        
        PrintPrompt(long_string_prompt)
      	PrintPrompt(ln)
	strcpy(long_str, t3)
      	
      	Exit()
