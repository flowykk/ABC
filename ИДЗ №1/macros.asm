.data
sep:    .asciz  "--------\n"
prompt: .asciz  "Введите число элементов массива: "
prompt2: .asciz  "Введите текущий элемент массива: "  
prompt3: .asciz  "Массив А: "
prompt4: .asciz  "Массив B: "
prompt5: .asciz  "Массивы до изменения: "
prompt6: .asciz  "Массивы после изменения: "
error:  .asciz  "Массив может быть длинной только от 1 до 10!! \n" 
ln:     .asciz "\n"

.align  2                  
n:	.word	0
array:  .space  40
copy_array:  .space  40

# Макрос для ввода и проверки длины массивов
# array_address - адрес на первый элемент массива А
# copy_array_address - адрес на первый элемент массива Б (копии массива А)
# n - будущее количество элементов в массивах
.macro InputArrayLength(%array_address, %copy_array_address, %n)
input: 
    	PrintPrompt(prompt)
        InputNumber(%n)
        
        ble     %n zero fail
        li      t4 10
        bgt     %n t4 fail
        j 	input_next
        
fail:
        PrintPrompt(error)
        Exit()

input_next:
        la	t4 n
        sw	%n (t4)
        la      %array_address array   
        
        la      %copy_array_address copy_array    
.end_macro

# Макрос для ввода элементов массива А и их копирования в массив B
# array_address - адрес на первый элемент массива А
# copy_array_address - адрес на первый элемент массива Б (копии массива А)
# n - количество элементов в массивах
.macro FillArray(%array_address, %copy_array_address, %n)
fill:
    	PrintPrompt(prompt2)
        InputNumber(t2)   
        
        sw      t2 (%array_address) 
        sw      t2 (%copy_array_address) 
        
        addi    %array_address %array_address 4
        addi    %copy_array_address %copy_array_address 4
        addi    %n %n -1
        
        bnez    %n fill 
        
        PrintPrompt(sep)
        
        lw	%n n	
        la      %array_address array
        
        la      %copy_array_address copy_array
        
.end_macro

# Макрос для вывода элементов двух массивов
# array_address - адрес на первый элемент массива А
# copy_array_address - адрес на первый элемент массива Б (копии массива А)
# n - будущее количество элементов в массивах
.macro PrintArray(%array_address, %copy_array_address, %n)

	PrintPrompt(prompt3)
	
out_array:
	li      a7 1
        lw      a0 (%array_address)
        ecall
        
        li      a0 ' '
        li      a7 11
        ecall
        
        addi    %array_address %array_address 4
        addi    %n %n -1

        bnez    %n out_array
        
        lw	%n n
        
        PrintPrompt(ln)
        PrintPrompt(prompt4)
        
out_copy_array:
	li      a7 1
        lw      a0 (%copy_array_address)
        ecall
        
        li      a0 ' '
        li      a7 11
        ecall
        
        addi    %copy_array_address %copy_array_address 4
        addi    %n %n -1

        bnez    %n out_copy_array
        
        lw	%n n
        la      %copy_array_address copy_array
        la      %array_address array
        
        PrintPrompt(ln)
        PrintPrompt(sep)
	
.end_macro

# Макрос для замены всех нулевых элементов, стоящих до первого отрицательного, единицами
# copy_array_address - адрес на первый элемент массива Б (копии массива А)
# n - будущее количество элементов в массивах
# flag - регистр, который хранит вспомогательный флаг
.macro EditElems(%copy_array_address, %n, %flag)
loop:
        lw      a0 (%copy_array_address)
	
	li 	t4 0
	blt 	a0 t4 edit_flag
	beq	a0 t4 edit
	j 	loop_next
	
edit:
	li      t2 1    
	bne 	%flag t2 loop_next
        sw      t2 (%copy_array_address) 
        j 	loop_next
        
edit_flag:
	li 	%flag 2

loop_next:
        addi    %copy_array_address %copy_array_address 4
        addi    %n %n -1

        bnez    %n loop
        
        lw	%n n
        la      %copy_array_address copy_array
	
	
.end_macro

# Макрос для вывода строк и подсказок
# x - регистр со строкой, которую нужно вывести в консоль
.macro PrintPrompt(%x)
	la 	a0 %x    
	li 	a7 4           
        ecall
.end_macro

# Макрос для вывода целых чисел
# x - регистр с числом, которое нужно вывести в консоль
.macro PrintNumber(%x)
	li      a7 1
        mv      a0 %x       
        ecall
.end_macro

# Макрос для ввода целых чисел
# x - регистр, куда нужно записать число, которое введёт пользователь
.macro InputNumber(%x)
	li      a7 5
        ecall
        mv      %x a0
.end_macro

# Макрос для выхода из программы
.macro Exit()
	li      a7 10
        ecall
.end_macro
