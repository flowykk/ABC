.eqv    SIZE 4096
.eqv    NAME_SIZE 512

.data
main_str:    .space SIZE
new_str:     .space SIZE
user_dec:    .space SIZE

ln:     	.asciz "\n"
res:		.asciz "Результат: "
read_str:     	.asciz "Строка, прочитнная из файла: "
result_str:	.asciz "Хотите ли вы увидеть результат?\nЕсли да, введите Y, В противном случае введите любой другой символ: "
prompt:         .asciz "Введите путь к файлу, откуда считать данные: "
prompt2:        .asciz "Введите путь к файлу, куда записать данные: "
er_name_mes:    .asciz "Указан некорректный путь к файлу!\n"
er_read_mes:    .asciz "Произошла ошибка во время чтения из файла!\n"
success:    	.asciz "Запись успешно произошла!"
file_name:      .space	NAME_SIZE

test1: 		.asciz "Тест №1\n"
test2: 		.asciz "Тест №2\n"
test3: 		.asciz "Тест №3\n"
test4: 		.asciz "Тест №4\n"
test5: 		.asciz "Тест №5\n"

test1_file: .asciz "/Users/danila/asmProjects/ihw3/TestData/test1_out.txt"

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
	InputString(result_str, user_dec, SIZE, %x)
	lb      t4 (%x) 
	li 	t2 89
	beq	t4 t2 yes_branch
	li 	a3 0
	j end
	
yes_branch:
	li 	a3 1

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
# message - адрес строкм  с сообщением для пользователя
# address - адрес будущей строки 
# size - размер вводимой строки
# x - регистр, где будетз аписан адрес первого символа строки
.macro InputString(%message, %address, %size, %x)
	la      a0 %message
	la 	a1 %address
        li      a2 %size
        li      a7 54
        ecall
        la 	%x %address
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
# message - адрес строкм  с сообщением для пользователя
# address - адрес строки, которую надо показать пользователю 
.macro PrintString(%message, %address)
	la 	a0 %message
	mv 	a1 %address
      	li 	a7 59
      	#mv 	a0 %x
      	#li 	a7 4
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

# Макрос для показа сообщения а диалоговом окне
# message - адрес строки с сообщением для пользователя
# type - тип сообщения
.macro ShowMessage(%message, %type)
	la 	a0 %message
	mv 	a1 %type
	li 	a7 55
	ecall
.end_macro

# Макрос для ввода названия файла
# message - адрес строкм  с сообщением для пользователя
# address - адрес будущей строки 
# size - размер вводимой строки с названием файла
.macro InputFileName(%message, %address, %size) 
	la 	a0 %message
	la      a1 %address
	li      a2 %size
	li      a7 54
	ecall
.end_macro

# Макрос, вызывающий подпрограмму для записи данных из файла 
.macro ReadFile()
	jal read_from_file
.end_macro

# Макрос, вызывающий подпрограмму для записи данных в файл
.macro WriteFile()
	jal out_in_file
.end_macro

# Макрос для выхода из программы
.macro Exit()
	li      a7 10
        ecall
.end_macro
