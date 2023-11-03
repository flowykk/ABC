.data
x:       .double 1.57  # Пи/4 в радианах (значение x, которое мы вычисляем)
pi:	 .double 3.14159265
result:  .double 0    # Результат вычисления тангенса x
accuracy: .double 0.000005    # Точность вычисления

.macro factorial(%x)
    li a1, 1                # Инициализировать результат (a1) в 1
    li t1, 1                # Инициализировать счетчик цикла (t1) в 1

    factorial_loop:
        mul a1, a1, t1      # Умножить результат (a1) на счетчик цикла (t1)
        addi t1, t1, 1      # Увеличить счетчик цикла на 1
        ble t1, %x, factorial_loop  # Повторять цикл, пока счетчик цикла меньше входного числа (a0)
.end_macro

.macro PrintNumber(%x)
	li      a7 1
        mv      a0 %x       
        ecall
        li      a0 '\n'
        li      a7 11
        ecall
.end_macro


.macro Exit()
	li      a7 10
        ecall
.end_macro


.text
.globl main

main:
    # Приведение x к интервалу от -π до π	
    	fld 		ft2 x t2         # Загрузка x в регистр $f2
    	fld 		ft4 pi t4        # Загрузка значения π в регистр $f4
    	#fdiv.d 		ft2 ft2 ft4      # Деление x на π, чтобы привести x к интервалу от -1 до 1
    	fld 		ft6 x t6
	
	#sin result
	fld		ft8 result a4
	fld		ft3 result a3
	fmv.d   	ft8 ft2
	fmv.d   	ft3 ft8
	
sin:	
    	li 		t0 1             # Инициализация счетчика
    	li 		t2 -1             # Инициализация знака члена ряда
	
	li 		t4 5		 # !!! ВРЕМЕННЫЙ СЧЕТЧИК
    	
calculate_sin:
	#t5 - (2n+1)!
	fmv.d   	ft3 ft8
	
	li 		t3 2
	mv 		t5 t0
	mul		t5 t5 t3 
	addi 		t5 t5 1
	factorial(t5)
	mv 		t5 a1
	fcvt.d.w	ft5 t5

    	fmul.d 		ft6 ft6 ft2  	 # Возведение x в квадрат
    	fmul.d 		ft6 ft6 ft2  	 # Возведение x в квадрат
    
    	fdiv.d 		ft1 ft6 ft5
    	
    	fcvt.d.w	ft10 t2
    	fmul.d 		ft1 ft1 ft10
    	
    	fadd.d		ft8 ft8 ft1
	
	fdiv.d 		ft4 ft8 ft3
	
	#li 		t5 -1
	#fcvt.d.w	ft5 t5
	#fadd.d 		ft4 ft4 ft5
	#fabs.d		ft4 ft4
	
	fmv.d   	fa0 ft4
	li              a7 3                   # Вывод числа двойной точности
	ecall
	li      	a0 '\n'
	li      	a7 11
	ecall
	fmv.d   	fa0 ft8
	li              a7 3                   # Вывод числа двойной точности
	ecall
	li      	a0 '\n'
	li      	a7 11
	ecall
	fmv.d   	fa0 ft3
	li              a7 3                   # Вывод числа двойной точности
	ecall
	li      	a0 '\n'
	li      	a7 11
	ecall
	li      	a0 '\n'
	li      	a7 11
	ecall
    	
    	bgtz 		t2 change_sign
    	li 		t2 1
    	j		sin_next
    	
change_sign:
	li t2 -1
    	
sin_next:
	addi 		t0 t0 1	 	 # +1 к счетчику
    	
    	ble  		t0 t4 calculate_sin # Проверка на окончание ряда (счетчик не равен 0)
    
    
	fmv.d   	fa0 ft8
	li              a7 3                   # Вывод числа двойной точности
	ecall
	li      	a0 '\n'
	li      	a7 11
	ecall

    	
Exit()
