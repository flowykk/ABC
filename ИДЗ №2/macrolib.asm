.data
prompt: .asciz  "Введите число x: "
sin_prompt: .asciz  "sin(x) = "
cos_prompt: .asciz  "cos(x) = "
tg_prompt: .asciz  "tg(x) = "
result:  .double 0    # Результат вычисления тангенса x
accuracy: .double 0.0005    # Точность вычисления

# Макрос для вычисления факториала числа %x
# x - регистр, факториал которого будет вычислен
.macro factorial(%x)
        li     a1 1
        li     t1 1

        factorial_loop:
            mul     a1 a1 t1
            addi    t1 t1 1
            ble     t1 %x factorial_loop
.end_macro

# Макрос для вывода вещественного числа на экран
# x - регистр, в котором записано вещественное число для вывода
.macro PrintFloat(%x)
        fmv.d       fa0 %x
        li          a7 3
        ecall
        li          a0 '\n'
        li          a7 11
        ecall
.end_macro

# Макрос для вывода строк и подсказок
# x - регистр со строкой, которую нужно вывести в консоль
.macro PrintPrompt(%x)
        la          a0 %x
        li          a7 4
        ecall
.end_macro

# Макрос для ввода вещественного числа
# x - регистр, куда будет записано вещественное число
.macro InputFloat(%x)
        li          a7 7
        ecall
        fmv.d       %x fa0
.end_macro

# Макрос для завершения работы программы
.macro Exit()
        li          a7 10
        ecall
.end_macro
