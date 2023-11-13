.include "macrolib.asm"

.text
.global strcpy
strcpy:   
	CreateString(new_str, t4)
	
loop:
      	lb      t1 (t3)
      	sb	t1 (t4)
        beqz    t1 end
        
strcpy_next:   
      	addi    t3 t3 1
      	addi    t4 t4 1
        b       loop
        
end:
	PrintPrompt(prompt3)
	PrintString(t5)
	
	PrintPrompt(ln)
ret
