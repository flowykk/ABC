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
