.data
sep:    .asciz  "--------\n"
prompt: .asciz  "Введите число элементов будущего массива: "
prompt2: .asciz  "Введите текущий элемент массива: "  
prompt3: .asciz  "Получившийся массив: "
prompt4: .asciz  "Сумма элементов массива: "
prompt5: .asciz  "Число элементов массива, вошедших в сумму: "
overflow_error: .asciz "\nПроизошло переполнение!\n"
error:  .asciz  "Массив может быть длинной только от 1 до 10!! \n" 
ln:     .asciz "\n"

.align  2                  
n:	.word	0
array:  .space  40

# Макрос для ввода и проверки длины массива
.macro InputArrayLength(%n, %array_address)
input: 
    	PrintPrompt(prompt)
        InputNumber(%n)
        
        ble     %n zero fail
        li      t4 10
        bgt     %n t4 fail
        j 	input_next
        
fail:
        PrintPrompt(error)

        li      a7 10
        ecall

input_next:
        la	t4 n
        sw	%n (t4)
        la      %array_address array     

.end_macro

# Макрос для ввода элементов массива
.macro FillArray(%array_address, %curr_elem)
fill:
    	PrintPrompt(prompt2)
        
        InputNumber(t2)   
        sw      t2 (%array_address) 
        
        addi    %array_address %array_address 4
        addi    %curr_elem %curr_elem -1
        
        bnez    %curr_elem fill 
        
        PrintPrompt(sep)
        
        lw	%curr_elem n	
        la      %array_address array
        
        PrintPrompt(prompt3)
.end_macro

# Макрос для вывода элементов массива
.macro PrintArray(%array_address, %curr_elem)
out_array:
	li      a7 1
        lw      a0 (%array_address)
        ecall
        
        li      a0 ' '
        li      a7 11
        ecall
        
        addi    %array_address %array_address 4
        addi    %curr_elem %curr_elem -1
        bnez    %curr_elem out_array
        
        lw	%curr_elem n	
        la      %array_address array
        
        PrintPrompt(ln)
        
        PrintPrompt(sep)
.end_macro

# Макрос для подсчёта и проверки суммы элементов массива
.macro Sum(%array_address, %curr_elem, %dop_sum, %curr_sum, %counter_sum, %max_p, %max_m) 
sum:	
	lw      a0 (%array_address) 
	
	bltz	a0 check_less_zero_overflow
	
	sub 	a3 %max_p a0
	ble 	a3 %dop_sum overflow_fail
	j 	sum_next
	
check_less_zero_overflow:
	sub 	a3 %max_m a0
	bge 	a3 %dop_sum overflow_fail
	j 	sum_next

sum_next:
        add	%dop_sum %curr_sum a0 
        add	%curr_sum %curr_sum a0
        addi	%counter_sum %counter_sum 1 
        
        addi    %array_address %array_address 4
        addi    %curr_elem %curr_elem -1      
        
        bnez    %curr_elem sum  
        
        lw	%curr_elem n	
        la      %array_address array
        PrintSum(%curr_sum, %counter_sum)	
       
# Обработка переполнения 
overflow_fail:
        PrintPrompt(overflow_error)
        
        lw	%curr_elem n	
        la      %array_address array
.end_macro

# Макрос для вывода суммы элементов массива
.macro PrintSum(%curr_sum, %counter_sum)
	PrintPrompt(prompt4)
        
        PrintNumber(%curr_sum)
        
        PrintPrompt(ln)
        
        PrintPrompt(prompt5)
        
        PrintNumber(%counter_sum)
	
	PrintPrompt(ln)
        
        PrintPrompt(sep)
        
        li      a7 10
        ecall
.end_macro

# Макрос для вывода строк и подсказок
.macro PrintPrompt(%x)
	la 	a0 %x    
	li 	a7 4           
        ecall
.end_macro

# Макрос для вывода целых чисел
.macro PrintNumber(%x)
	li      a7 1
        mv      a0 %x        
        ecall
.end_macro

# Макрос для ввода целых чисел
.macro InputNumber(%x)
	li      a7 5
        ecall
        mv      %x a0
.end_macro
