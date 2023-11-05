.include "macrolib.asm"

.text
.globl main

main:
        # Ввод вещественного числа x
        PrintPrompt(prompt)
        InputFloat(ft2)
    
        # Подсчёт и вывод sin(x)
        PrintPrompt(sin_prompt)
        jal sin
        
        # Подсчёт и вывод cos(x)
        PrintPrompt(cos_prompt)
        jal cos

        # Подсчёт и вывод tg(x)
        PrintPrompt(tg_prompt)
        jal tg
        
        # Завершение работы программы
        Exit()
        
sin:
        #Инициализация нужных переменных
        fmv.d           ft6 ft2
    
        fld             ft8 result a4
        fld             ft3 result a3
        fmv.d           ft8 ft2
        fmv.d           ft3 ft8
        
        # Инициализация счетчика
        li              t0 1
        
        # Инициализация знака члена ряда
        li              t2 -1
        
calculate_sin:
        # Запись предыдущего значения sin(x)
        fmv.d           ft3 ft8
    
        # Подсчёт (2n+1)!
        li              t3 2
        mv              t5 t0
        mul             t5 t5 t3
        addi            t5 t5 1
        factorial(t5)
        mv              t5 a1
        fcvt.d.w        ft5 t5

        # Подсчёт x^(2n+1)
        fmul.d          ft6 ft6 ft2
        fmul.d          ft6 ft6 ft2
    
        # Подсчёт текущего члена ряда
        fdiv.d          ft1 ft6 ft5
        
        # Учёт знака текущего члена ряда
        fcvt.d.w        ft10 t2
        fmul.d          ft1 ft1 ft10
        
        # Прибавление текущего члена ряда к результату
        fadd.d          ft8 ft8 ft1
    
        # Подсчёт точности вычисления
        fdiv.d          ft4 ft8 ft3
        fabs.d          ft4 ft4
        li              t5 1
        fcvt.d.w        ft5 t5
        flt.d           t5 ft5 ft4
        addi            t5 t5 -1
        beqz            t5 accuracy_1
        j               no_accuracy_1
    
accuracy_1:
        li              t5 1
        fcvt.d.w        ft5 t5
        fsub.d          ft4 ft4 ft5

no_accuracy_1:
        li              t5 100
        fcvt.d.w        ft5 t5
        fdiv.d          ft4 ft4 ft5
        
        # Смена знака для следующего члена ряда
        bgtz            t2 change_sign
        li              t2 1
        j               sin_next
        
change_sign:
        li              t2 -1
        
sin_next:
        # Увличение номера члена ряда
        addi            t0 t0 1
        
        # Учёт вычисленной точности
        fld             fa3 accuracy a3
        flt.d           t5 ft4 fa3
    
        # Проверка на окончание ряда
        beqz            t5 calculate_sin
        
        # Вывод результата
        PrintFloat(ft8)
ret

cos:
        # Инициализация нужных перемнных
        fmv.d           ft6 ft2
        fdiv.d          ft6 ft6 ft6
    
        fld             ft7 result a4
        fld             ft3 result a3
        fmv.d           ft7 ft6
        fmv.d           ft3 ft7
        
        # Инициализация счетчика
        li              t0 1
        
        # Инициализация знака члена ряда
        li              t2 -1
        
calculate_cos:
        # Запись предыдущего значения cos(x)
        fmv.d           ft3 ft7
        
        # Подсчёт (2n)!
        li              t3 2
        mv              t5 t0
        mul             t5 t5 t3
        factorial(t5)
        mv              t5 a1
        fcvt.d.w        ft5 t5

        # Подсчёт x^2n
        fmul.d          ft6 ft6 ft2
        fmul.d          ft6 ft6 ft2
        
        # Подсчёт текущего члена ряда
        fdiv.d          ft1 ft6 ft5
        
        # Учёт знака текущего члена ряда
        fcvt.d.w        ft10 t2
        fmul.d          ft1 ft1 ft10

        # Прибавление текущего члена ряда к результату
        fadd.d          ft7 ft7 ft1
        
        # Подсчёт точности вычисления
        fdiv.d          ft4 ft7 ft3
        fabs.d          ft4 ft4
        li              t5 1
        fcvt.d.w        ft5 t5
        flt.d           t5 ft5 ft4
        addi            t5 t5 -1
        beqz            t5 accuracy_2
        j               no_accuracy_2
    
accuracy_2:
        li              t5 1
        fcvt.d.w        ft5 t5
        fsub.d          ft4 ft4 ft5

no_accuracy_2:
        li              t5 100
    
        #Смена знака для следующего члена ряда
        bgtz            t2 change_sign_2
        li              t2 1
        j               cos_next
        
change_sign_2:
        li              t2 -1
        
cos_next:
        # Увеличение номера члена ряда
        addi            t0 t0 1
        
        # Учёт вычисленной точности
        fld             fa3 accuracy a3
        flt.d           t5 ft4 fa3
    
        # Проверка на окончание ряда
        beqz            t5 calculate_cos
        
        # Вывод результата
        PrintFloat(ft7)
ret

tg:
        # Подсчёт tg(x) = sin(x)/cos(x)
        fdiv.d          ft1 ft8 ft7
        PrintFloat(ft1)
ret
