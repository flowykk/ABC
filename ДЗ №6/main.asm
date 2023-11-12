.eqv    SIZE 100                # размер буфера
.data
main_str:    .space SIZE             # буфер
new_str:     .space SIZE
test_str:    .asciz "test string"
prompt1:  .asciz  "Введите строку: "
prompt3:  .asciz  "Скопированная строка: " 
ln:     .asciz "\n"

.macro PrintPrompt(%x)
	la 	a0 %x    
	li 	a7 4           
        ecall
.end_macro

.macro PrintNumber(%x)
	li      a7 1
        mv      a0 %x       
        ecall
.end_macro

.macro InputNumber(%x)
	li      a7 5
        ecall
        mv      %x a0
.end_macro

.macro CreateString(%string_address, %x)
	la      a0 %string_address
        mv 	%x a0
        mv 	t5 %x
.end_macro

.macro ParseTestString(%string_address, %x)
	      la      a0 %string_address
        li      a1 SIZE
        mv 	    %x a0
.end_macro

.macro InputString(%string_address, %x)
	      la      a0 %string_address
        li      a1 SIZE
        li      a7 8
        ecall
        mv 	    %x a0
.end_macro

.macro PrintString(%x)
      	mv 	    a0 %x
      	li 	    a7 4
      	ecall
.end_macro

.macro Exit()
	      li      a7 10
        ecall
.end_macro

.text
main:
      	PrintPrompt(prompt1)
      	InputString(main_str, t3)
      
      	jal strcpy
      	
      	ParseTestString(test_str, t3)
        jal strcpy
      	
      	Exit()

strcpy:   
	      CreateString(new_str, t4)
	
loop:
      	lb      t1 (t3)
      	sb	    t1 (t4)
        beqz    t1 end
        
strcpy_next:   
      	addi    t3 t3 1
      	addi    t4 t4 1
        b       loop
        
end:
	PrintPrompt(prompt3)
	PrintString(t5)

ret
