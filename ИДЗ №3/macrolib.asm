.eqv    SIZE 2048
.eqv    NAME_SIZE 256

.data
main_str:    .space SIZE
new_str:     .space SIZE

ln:     .asciz "\n"
read_str:     	.asciz "Строка, прочитнная из файла: "
result_str:	.asciz "Полученный результат: "
prompt:         .asciz "Введите путь к файлу: "
er_name_mes:    .asciz "Указан некорректный путь к файлу!\n"
er_read_mes:    .asciz "Произошла ошибка во время чтения из файла!\n"
file_name:      .space	NAME_SIZE

.macro isDigit(%x)
	li 	a0 48
	li 	a1 57
	
	blt 	%x a0 no_digit 
	bgt 	%x a1 no_digit
	
	li 	t2 1
	j 	end
	
no_digit:
	li 	t2 0
end:
.end_macro

.macro dotask(%address)
do:   
	mv 	a2 %address

	CreateString(new_str, t6)
	li 	t0 0
	
loop:
      	lb      t1 (%address) 
 
      	isDigit(t1)
	beqz  	t2 no_digit
	sb	t1 (t6)
	li 	t0 1
	addi    t6 t6 1
	j loop_next

no_digit:
	beqz 	t0 loop_next
	li 	t4 43
	sb	t4 (t6)
	addi    t6 t6 1
	li 	t0 0
	
loop_next:   	
        beqz    t1 end 
      	addi	%address %address 1
        b       loop
        
end:	
	addi	t6 t6 -1
	li	t4 0
	sb	t4 (t6)
	mv %address a2
.end_macro

.macro InputString(%string_address, %x)
	la      a0 %string_address
        li      a1 SIZE
        li      a7 8
        ecall
        mv 	%x a0
.end_macro

.macro CreateString(%string_address, %x)
	la      a0 %string_address
        mv 	%x a0
        mv 	t3 %x
.end_macro

.macro PrintPrompt(%x)
	la 	a0 %x    
	li 	a7 4           
        ecall
.end_macro

.macro PrintString(%x)
      	mv 	a0 %x
      	li 	a7 4
      	ecall
.end_macro

.macro PrintNumber(%x)
	li      a7 1
        mv      a0 %x       
        ecall
.end_macro

.macro Exit()
	li      a7 10
        ecall
.end_macro
