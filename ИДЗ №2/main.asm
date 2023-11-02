.data
x:       .float 2  # Пи/4 в радианах (значение x, которое мы вычисляем)
pi:	 .float 3.14159265
result:  .float 0           # Результат вычисления тангенса x
accuracy: .float 0.000005    # Точность вычисления

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
    	flw 		ft2 x t2         # Загрузка x в регистр $f2
    	flw 		ft4 pi t4        # Загрузка значения π в регистр $f4
    	#fdiv.s 		ft2 ft2 ft4      # Деление x на π, чтобы привести x к интервалу от -1 до 1
    	
    	fadd.s		ft1 ft1 ft2
    	
    	li 		t0 1             # Инициализация счетчика
    	li 		t1 1             # Инициализация знака члена ряда
    	li 		t2 3             # Начинаем с x^3 (первый член ряда с нечетным показателем)
    	li 		t3 3             # Инициализация знаменателя (начиная с 3)
	
	
	    li 		t4 5		 # !!! ВРЕМЕННЫЙ СЧЕТЧИК
	
    	fcvt.d.w	ft5 t0 
    	fmv.d   	ft6 ft2
calculate_tan:

	    fmv.d   	fa0 ft6
    	li              a7 2                    # Вывод числа двойной точности
    	ecall
    	li      a0 '\n'
      li      a7 11
      ecall

    	fmul.s 		ft6 ft6 ft2  	 # Возведение x в квадрат
    	fmul.s 		ft6 ft6 ft2  	 # Возведение x в квадрат
    	
    	fdiv.s 		ft5 ft6 ft5 	 # Вычисление x^n / n
    	fcvt.d.w	ft10 t1 
    	fmul.s 		ft5 ft5 ft10 	 # Применение знака к члену ряда
    	fadd.s		ft1 ft1 ft5  	 # Прибавление члена ряда к результату
    	

    	
    	
    	addi 		t0 t0 1	 	 # +1 к счетчику
    	addi 		t1 t1 -1    	 # Смена знака
    	addi 		t2 t2 2     	 # Переход к следующему члену ряда (увеличение показателя степени на 2)
    	addi 		t3 t3 2     	 # Увеличение знаменателя на 2
    	ble  		t0 t4 calculate_tan # Проверка на окончание ряда (счетчик не равен 0)
    
    	#fmul.s 		ft4 ft4 ft2
    	
Exit()
