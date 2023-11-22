.eqv    SIZE 4096
.eqv    NAME_SIZE 512

.data
main_str:    .space SIZE
new_str:     .space SIZE
user_dec:    .space SIZE

ln:     	.asciz "\n"
read_str:     	.asciz "Строка, прочитнная из файла: "
result_str:	.asciz "Хотите ли вы увидеть результат?\nЕсли да, введите Y, В противном случае введите любой другой символ: "
prompt:         .asciz "Введите путь к файлу, откуда считать данные: "
prompt2:        .asciz "Введите путь к файлу, куда записать данные: "
er_name_mes:    .asciz "Указан некорректный путь к файлу!\n"
er_read_mes:    .asciz "Произошла ошибка во время чтения из файла!\n"
file_name:      .space	NAME_SIZE

# Макрос для проверки, является ли текущий символ строки цифрой
# x - текущий символ строки
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

# Макрос возможности пользователя выбрать выводить результат или нет
.macro UserDecision(%x)
	PrintPrompt(result_str)
	
	InputString(user_dec, %x)
	lb      t4 (%x) 
	li 	t2 89
	beq	t4 t2 yes_branch
	li 	a0 0
	j end
	
yes_branch:
	li 	a0 1

end: 
.end_macro

# Макрос для обработки строки в соответствии с условием задания
# address - адрес строки, которую нужно обработать
.macro StringProcessing(%address)
do:   
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
	mv 	a6 t3
.end_macro

# Макрос для ввода строки
# string_address - адрес будущей строки 
# x - регистр, где будетз аписан адрес первого символа строки
.macro InputString(%string_address, %x)
	la      a0 %string_address
        li      a1 SIZE
        li      a7 8
        ecall
        mv 	%x a0
.end_macro

# Макрос для создания строки
# string_address - адрес будущей строки 
# x - регистр, где будет аписан адрес первого символа строки
.macro CreateString(%string_address, %x)
	la      a0 %string_address
        mv 	%x a0
        mv 	t3 %x
.end_macro

# Макрос для вывода подсказок
# x - регистр со подскзкой, которую нужно вывести в консоль
.macro PrintPrompt(%x)
	la 	a0 %x    
	li 	a7 4           
        ecall
.end_macro

# Макрос для вывода строк
# x - регистр со строкой, которую нужно вывести в консоль
.macro PrintString(%x)
      	mv 	a0 %x
      	li 	a7 4
      	ecall
      	PrintPrompt(ln)
.end_macro

# Макрос для вывода целых чисел
# x - регистр с числом, которое нужно вывести в консоль
.macro PrintNumber(%x)
	li      a7 1
        mv      a0 %x       
        ecall
.end_macro

# Макрос для выхода из программы
.macro Exit()
	li      a7 10
        ecall
.end_macro
