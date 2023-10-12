# Домашнее задание №5
## Код программы
### Файл dz5.asm
```assembly
.include "macros.asm"

.text

main:
        InputArrayLength(t3, t0) # Ввод и проверка длины массива
        
        FillArray(t0, t3) # Заполнение массива 
	
        li 	t4 2147483647 # Сохранение максимально допустимого 32-битного числа
        li 	t2 -2147483647 # Сохранение максимально допустимого 32-битного числа

        PrintArray(t0, t3) # Вывод массива
    	
        Sum(t0, t3, t1, t5, t6, t4, t2) # Подсчёт суммы с учётом возможного переполнения
  
        PrintSum(t5, t6) # Вывод суммы элементов массива до переполнения  
```

### Файл macros.asm
```assembly
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
	         	a3 %dop_sum overflow_fail
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
```

## Лог программы.
```
Введите число элементов будущего массива: 4
Введите текущий элемент массива: 12
Введите текущий элемент массива: 56
Введите текущий элемент массива: 23
Введите текущий элемент массива: 78
--------
Получившийся массив: 12 56 23 78 
--------
Сумма элементов массива: 169
Число элементов массива, вошедших в сумму: 4
--------

-- program is finished running (0) --

Введите число элементов будущего массива: 3
Введите текущий элемент массива: -19
Введите текущий элемент массива: 45
Введите текущий элемент массива: 90
--------
Получившийся массив: -19 45 90 
--------
Сумма элементов массива: 116
Число элементов массива, вошедших в сумму: 3
--------

-- program is finished running (0) --

Введите число элементов будущего массива: 19
Массив может быть длинной только от 1 до 10!! 

-- program is finished running (0) --

Введите число элементов будущего массива: 0
Массив может быть длинной только от 1 до 10!! 

-- program is finished running (0) --

Введите число элементов будущего массива: 3
Введите текущий элемент массива: 10
Введите текущий элемент массива: 10
Введите текущий элемент массива: 2147483645
--------
Получившийся массив: 10 10 2147483645 
--------
Произошло переполнение!
Сумма элементов массива: 20
Число элементов массива, вошедших в сумму: 2
--------

-- program is finished running (0) --

Введите число элементов будущего массива: 3
Введите текущий элемент массива: 1
Введите текущий элемент массива: 2147483645
Введите текущий элемент массива: 2
--------
Получившийся массив: 1 2147483645 2 
--------
Произошло переполнение!
Сумма элементов массива: 2147483646
Число элементов массива, вошедших в сумму: 2
--------

-- program is finished running (0) --

Введите число элементов будущего массива: 3
Введите текущий элемент массива: -1
Введите текущий элемент массива: -2
Введите текущий элемент массива: -2147483645
--------
Получившийся массив: -1 -2 -2147483645 
--------
Произошло переполнение!
Сумма элементов массива: -3
Число элементов массива, вошедших в сумму: 2
--------

-- program is finished running (0) --

Введите число элементов будущего массива: 3
Введите текущий элемент массива: -10
Введите текущий элемент массива: -20
Введите текущий элемент массива: -2147483643
--------
Получившийся массив: -10 -20 -2147483643 
--------
Произошло переполнение!
Сумма элементов массива: -30
Число элементов массива, вошедших в сумму: 2
--------

-- program is finished running (0) --
```

## Рассмотрим на скриншотах различные ситуации входных данных, чтобы показать работу программы.
### Корректное число элементов массива, переполнения не произошло. Сумма и количество элементов массива в ней вывелось в консоль.
<img width="1440" alt="Снимок экрана 2023-10-12 в 12 41 08" src="https://github.com/flowykk/ABC/assets/71427624/455c216f-63e5-46ef-b3ca-2853fd639c7c">
<img width="1440" alt="Снимок экрана 2023-10-12 в 12 41 39" src="https://github.com/flowykk/ABC/assets/71427624/ebc7c820-7898-4332-abe7-f0833b10cd4d">

### Некорректно задано число элементов массива.
<img width="1440" alt="Снимок экрана 2023-10-12 в 12 43 10" src="https://github.com/flowykk/ABC/assets/71427624/82ab238f-42dc-40b9-90ba-1830bbb84bdb">

### Корректное число элементов массива, произошло переполнение. Cумма и количество элементов массива до переполнения вывелось в консоль.
#### Переполнение в положительную сторону:
<img width="1440" alt="Снимок экрана 2023-10-12 в 12 44 37" src="https://github.com/flowykk/ABC/assets/71427624/87cb0113-4c62-4217-bd80-8f2de6ebca93">
<img width="1440" alt="Снимок экрана 2023-10-12 в 12 45 01" src="https://github.com/flowykk/ABC/assets/71427624/30e04f7c-cfe0-4563-8aaf-8355a6267a9f">

### Корректное число элементов массива, произошло переполнение. Cумма и количество элементов массива до переполнения вывелось в консоль.
#### Переполнение в отрицательную сторону:
<img width="1440" alt="Снимок экрана 2023-10-12 в 12 45 41" src="https://github.com/flowykk/ABC/assets/71427624/9c1bfbaa-d4c5-49de-b4c0-8ff90dcc043b">
<img width="1440" alt="Снимок экрана 2023-10-12 в 12 46 02" src="https://github.com/flowykk/ABC/assets/71427624/7b466b76-0941-44a9-ba29-d0f03d621793">
