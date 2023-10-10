# Домашнее задание №3
## Код программы
```assembly
.data
sep:    .asciz  "--------\n"
prompt: .asciz  "Введите число элементов будущего массива: "
prompt2: .asciz  "Введите текущий элемент массива: "  
prompt3: .asciz  "Получившийся массив: "
prompt4: .asciz  "Сумма элементов массива: "
prompt5: .asciz  "Число элементов массива, вошедших в сумму: "
prompt6: .asciz  "Количество чётных элементов массива: "
prompt7: .asciz  "\nКоличество нечётных элементов массива: "
ln:     .asciz "\n"
overflow_error: .asciz "\nПроизошло переполнение!\n"
error:  .asciz  "Массив может быть длинной только от 1 до 10!! \n" 

.align  2                  
n:	.word	0
array:  .space  40
.text
in:
        la 	a0, prompt
        li 	a7, 4
        ecall
        li      a7 5
        ecall
        mv      t3 a0
        
        ble     t3 zero fail
        li      t4 10
        bgt     t3 t4 fail
        la	t4 n
        sw	t3 (t4)
        la      t0 array
     
# Заполнение массива      
fill:
	la 	a0, prompt2 
	li 	a7, 4
        ecall
        li      a7 5
        ecall
        
        mv      t2 a0    
        sw      t2 (t0) 
        
        addi    t0 t0 4
        addi    t3 t3 -1
        
        bnez    t3 fill 
        la      a0 sep
        li      a7 4
        ecall
        
        lw	t3 n	
        la      t0 array
        li 	t4 2147483647 # Сохранение максимально допустимого 32-битного числа
        li 	t2 -2147483647 # Сохранение максимально допустимого 32-битного числа
        	
        
        la 	a0 prompt3   
	li 	a7 4           
        ecall

# Вывод массива
out_array:
    	li      a7 1
        lw      a0 (t0)
        ecall
        li      a0 ' '
        li      a7 11
        ecall
        
        addi    t0 t0 4
        addi    t3 t3 -1
        bnez    t3 out_array
        
        lw	t3 n	
        la      t0 array
        
        la      a0 ln
   	li      a7 4
        ecall
        la      a0 sep
    	li      a7 4
        ecall

# Подсчёт суммы с учётом возможного переполнения
sum:	
	lw      a0 (t0) 
	
	bltz	a0 check_less_zero_overflow
	
	sub 	a3 t4 a0
	ble 	a3 t1 overflow_fail
	j 	sum_next
	
check_less_zero_overflow:
	sub 	a3 t2 a0
	bge 	a3 t1 overflow_fail

sum_next:
        add	t1 t5 a0 
        add	t5 t5 a0
        addi	t6 t6 1 
        
        addi    t0 t0 4
        addi    t3 t3 -1      
        
        bnez    t3 sum  
        
        lw	t3 n	
        la      t0 array
        j out_sum
       
# Обработка переполнения 
overflow_fail:
        la 	a0 overflow_error
        li 	a7 4
        ecall
        
        lw	t3 n	
        la      t0 array
  
# Вывод суммы элементов массива до переполнения      
out_sum:
	la 	a0 prompt4     
	li 	a7 4           
        ecall
        li      a7 1
        mv      a0 t5        
        ecall
        la 	a0 ln     
	li 	a7 4     
        ecall
        la 	a0 prompt5 
	li 	a7 4
        ecall
        li      a7 1
        mv      a0 t6         
        ecall
	
	la      a0 ln
   	li      a7 4
        ecall
        la      a0 sep
    	li      a7 4
        ecall
        
        lw	t3 n	
        la      t0 array
        mv 	t1 zero
        mv 	t4 zero
       
# Подсчёт чётных/нечётных элементов массива
count_odd_even:
	lw      a0 (t0) 
        
        addi    t0 t0 4
        addi    t3 t3 -1
        addi 	t4 t4 1
              
        andi 	a1 a0 1 
	bnez 	a1 count_odd_even_next

	addi 	t1 t1 1

count_odd_even_next:
        bnez    t3 count_odd_even  
        sub 	t4 t4 t1

# Вывод количества чётных/нечётных элементов массива
out_odd_even:
	la 	a0 prompt6
	li 	a7 4
        ecall
        li      a7 1
        mv      a0 t1         
        ecall
        la 	a0 prompt7
	li 	a7 4
        ecall
        li      a7 1
        mv      a0 t4       
        ecall
        la 	a0 ln
	li 	a7 4
        ecall
        
        li      a7 10    
        ecall

# Обработка ошибки при попытке записи числа элементов, не соотвутсвующего допустимым
fail:
        la 	a0 error
        li 	a7 4
        ecall
        li      a7 10
        ecall
```
## Рассмотрим на скриншотах различные ситуации входных данных, чтобы показать работу программы.
### Корректное число элементов массива, переполнения не произошло. Сумма и количество элементов массива, а также количество чётных/нечётных элементов вывелось в консоль.
<img width="1440" alt="Снимок экрана 2023-09-27 в 15 54 46" src="https://github.com/flowykk/ABC/assets/71427624/88fdab56-0364-4ad2-8c3d-dd8b8172e85a">
<img width="1440" alt="Снимок экрана 2023-09-27 в 16 26 00" src="https://github.com/flowykk/ABC/assets/71427624/88890113-2d56-411b-84fb-1916858adbf0">

### Некорректно задано число элементов массива, > 10.
<img width="1440" alt="Снимок экрана 2023-09-27 в 15 58 13" src="https://github.com/flowykk/ABC/assets/71427624/4bf43c6e-4ce0-4f06-9922-0af7caf1461a">

### Некорректно задано число элементов массива, < 1.
<img width="1440" alt="Снимок экрана 2023-09-27 в 15 58 47" src="https://github.com/flowykk/ABC/assets/71427624/51bc67dc-ffe2-4ffd-a53e-dabc5e673cd0">

### Корректное число элементов массива, произошло переполнение. Cумма и количество элементов массива до переполнения, а также количество чётных/нечётных элементов вывелось в консоль.
#### Переполнение в положительную сторону:
<img width="1440" alt="Снимок экрана 2023-09-28 в 20 46 33" src="https://github.com/flowykk/ABC/assets/71427624/026d92ee-316b-4566-9164-eee377d84627">
<img width="1440" alt="Снимок экрана 2023-09-28 в 20 53 45" src="https://github.com/flowykk/ABC/assets/71427624/cc6d639d-b3c3-4dd7-800d-f725e8ec7aa7">

#### Переполнение в отрицательную сторону:
<img width="1440" alt="Снимок экрана 2023-09-28 в 20 57 54" src="https://github.com/flowykk/ABC/assets/71427624/4748b46d-5b66-4344-9c39-e55cdc46b00d">
<img width="1440" alt="Снимок экрана 2023-09-28 в 21 01 28" src="https://github.com/flowykk/ABC/assets/71427624/8a551815-ff90-4ffd-aea2-df5e77dd8145">
