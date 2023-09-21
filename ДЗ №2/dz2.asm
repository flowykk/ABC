#t0 - делимое
#t1 - делитель 
#t2 - частное
#t3 - вспомогательная переменная, которая отвечает за знак частного
#t4 - вспомогательная переменная, которая отвечает за знак остатка

.data 
    arg01:  .asciz "Введите первое число: "
    arg02:  .asciz "Введите второе число: "
    result01: .asciz "Частное: "
    result02: .asciz "Остаток: "
    zerodiv: .asciz "Делить на 0 нельзя!"
    ln:     .asciz "\n"
    
.text
#ввод делимого
la a0, arg01   
li a7, 4
ecall
li a7, 5
ecall
mv t0, a0

#ввод делителя
la a0, arg02   
li a7, 4
ecall
li a7, 5
ecall
mv t1, a0

#обнуление счетчика (частного от деления)
mv t2, zero

#деление на 0
beqz t1, division_zero

#учёт знаков будущих частного и остатка
li t3, 1
li t4, 1
if_sign1_1:
    bltz t0, if_sign2_1
    bgtz t1, if_1
    sub t3, zero, t3
    j if_1
    
if_sign2_1:
    bltz t1, if_sign2_2
    sub t3, zero, t3
    sub t4, zero, t4
    j if_1
 
if_sign2_2:   
    sub t4, zero, t4

#учёт знаков операндов (взятие обратного по знаку, в случае, если операнд отрицательный)
if_1:
    bgtz t0, if_2
    sub t0, zero, t0
    
if_2:
    bgtz t1, while
    sub t1, zero, t1

#цикл для подсчёта частного и остатка от деления
while:
    bgt t1, t0, if_3
    sub t0, t0, t1
    addi t2, t2, 1
    j while
    
#смена знаков у частного и остатка при необходимости
if_3:
    bgtz t3, if_4
    sub t2, zero, t2

if_4:
    bgtz t4, print_result
    sub t0, zero, t0

#вывод результата
print_result:
    la a0, result01   
    li a7, 4
    ecall
    mv a0, t2
    li a7, 1
    ecall
    
    la a0, ln   
    li a7, 4
    ecall
    
    la a0, result02  
    li a7, 4
    ecall
    mv a0, t0
    li a7, 1
    ecall
    
    li a7, 10
    ecall
    
#обработка попытки деления на 0
division_zero:
    la a0, zerodiv   
    li a7, 4
    ecall
