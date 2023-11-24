.data

ln:     	.asciz "\n"
prompt:     	.asciz "Введите число: "


# Макрос для вывода подсказок
# x - регистр со подскзкой, которую нужно вывести в консоль
.macro PrintPrompt(%x)
	la 	a0 %x    
	li 	a7 4           
        ecall
.end_macro

# Макрос для ввода целых чисел
# x - регистр, куда нужно записать число, которое введёт пользователь
.macro InputNumber(%x)
	li      a7 5
        ecall
        mv      %x a0
.end_macro

.macro Sleep()
	li 	a0 1000
    	li 	a7 32
    	ecall
.end_macro

# Макрос для выхода из программы
.macro Exit()
	li      a7 10
        ecall
.end_macro
