# Домашнее задание №5
## Код программы
### Файл [idz1.asm](idz1.asm)
```assembly
.include "macros.asm"

.text

main:
        InputArrayLength(t0, t1, t3) # Ввод и проверка длины массивов
        
	FillArray(t0, t1, t3) # Заполнение массива А и массива Б
	
	# Вывод массивов до каких-либо изменений
	PrintPrompt(prompt5)
	PrintPrompt(ln)
 	PrintArray(t0, t1, t3)
 	
 	# Имзенение всех нулевых элементов, стоящих до первого отрицательного, на единицу 
 	li 	t5 1 # Вспомогательный флаг для отслеживания первого отрицательного элемента
 	EditElems(t1, t3, t5)
 	
 	# Вывод массивов после того, как были изменены элементы
 	PrintPrompt(prompt6)
	PrintPrompt(ln)
 	PrintArray(t0, t1, t3)
 	
 	# Выход из программы
 	Exit()
```

### Файл [macros.asm](macros.asm)
```assembly
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
```

## Лог программы.
```
Введите число элементов массива: 5
Введите текущий элемент массива: 0
Введите текущий элемент массива: 1
Введите текущий элемент массива: -1
Введите текущий элемент массива: 0
Введите текущий элемент массива: 4
--------
Массивы до изменения: 
Массив А: 0 1 -1 0 4 
Массив B: 0 1 -1 0 4 
--------
Массивы после изменения: 
Массив А: 0 1 -1 0 4 
Массив B: 1 1 -1 0 4 
--------

-- program is finished running (0) --

Введите число элементов массива: 9
Введите текущий элемент массива: 0
Введите текущий элемент массива: 1
Введите текущий элемент массива: 2
Введите текущий элемент массива: 0
Введите текущий элемент массива: 0
Введите текущий элемент массива: -13
Введите текущий элемент массива: 12
Введите текущий элемент массива: 0
Введите текущий элемент массива: 1
--------
Массивы до изменения: 
Массив А: 0 1 2 0 0 -13 12 0 1 
Массив B: 0 1 2 0 0 -13 12 0 1 
--------
Массивы после изменения: 
Массив А: 0 1 2 0 0 -13 12 0 1 
Массив B: 1 1 2 1 1 -13 12 0 1 
--------

-- program is finished running (0) --

Введите число элементов массива: 0
Массив может быть длинной только от 1 до 10!! 

-- program is finished running (0) --

Введите число элементов массива: -10
Массив может быть длинной только от 1 до 10!! 

-- program is finished running (0) --

Введите число элементов массива: 11
Массив может быть длинной только от 1 до 10!! 

-- program is finished running (0) --

Введите число элементов массива: 14
Массив может быть длинной только от 1 до 10!! 

-- program is finished running (0) --

Введите число элементов массива: 10
Введите текущий элемент массива: 9
Введите текущий элемент массива: 0
Введите текущий элемент массива: 2
Введите текущий элемент массива: 3
Введите текущий элемент массива: 0
Введите текущий элемент массива: 0
Введите текущий элемент массива: -27
Введите текущий элемент массива: 21
Введите текущий элемент массива: 0
Введите текущий элемент массива: 4
--------
Массивы до изменения: 
Массив А: 9 0 2 3 0 0 -27 21 0 4 
Массив B: 9 0 2 3 0 0 -27 21 0 4 
--------
Массивы после изменения: 
Массив А: 9 0 2 3 0 0 -27 21 0 4 
Массив B: 9 1 2 3 1 1 -27 21 0 4 
--------

-- program is finished running (0) --

Введите число элементов массива: 3
Введите текущий элемент массива: 0
Введите текущий элемент массива: -1
Введите текущий элемент массива: 0
--------
Массивы до изменения: 
Массив А: 0 -1 0 
Массив B: 0 -1 0 
--------
Массивы после изменения: 
Массив А: 0 -1 0 
Массив B: 1 -1 0 
--------
```

## Рассмотрим на скриншотах различные ситуации входных данных, чтобы показать работу программы.
### Пользователем введено корректное число элементов массива. Массив B корректно скопировался на основе массива А. Оба массива корректно выводятся на экран. Изменения массива В выполнились правильно и результат был выведен на экран.
<img width="1440" alt="Снимок экрана 2023-10-12 в 20 39 11" src="https://github.com/flowykk/ABC/assets/71427624/3159b8ea-2226-4b1b-85bd-23fd2d3b09d4">
<img width="1440" alt="Снимок экрана 2023-10-12 в 20 39 41" src="https://github.com/flowykk/ABC/assets/71427624/0decbaa4-fd84-449e-b51d-919dd40e1b93">

### Некорректно задано число элементов массива. >10.
<img width="1440" alt="Снимок экрана 2023-10-12 в 20 40 56" src="https://github.com/flowykk/ABC/assets/71427624/d0f15a1d-832f-41b3-90d2-67520dfc6f1a">

### Некорректно задано число элементов массива. <1.
<img width="1440" alt="Снимок экрана 2023-10-12 в 20 40 39" src="https://github.com/flowykk/ABC/assets/71427624/5a92e2a9-55a6-4e42-b41c-17f044eb5867">

### Чуть больше тестов работы программы.
<img width="1440" alt="Снимок экрана 2023-10-12 в 20 45 18" src="https://github.com/flowykk/ABC/assets/71427624/bbb39840-a131-4216-91a6-3095ade6f2df">
<img width="1440" alt="Снимок экрана 2023-10-12 в 20 46 00" src="https://github.com/flowykk/ABC/assets/71427624/7a9895ce-e544-4eba-b072-4e64973aab54">

