.include "macrolib.asm"
  
.text
.global read_from_file
read_from_file: 
    	# Вывод подсказки
	PrintPrompt(prompt)
	
	# Ввод имени файла с консоли
	la      a0 file_name
	li      a1 NAME_SIZE
	li      a7 8
	ecall
	
	# Убрать перевод строки
	li	t4 '\n'
	la	t5 file_name
	
loop:
	lb	t6  (t5)
	beq 	t4	t6	replace
	addi 	t5 t5 1
	b	loop
	
replace:
    	sb	zero (t5)

    	li   	a7 1024     	# Системный вызов открытия файла
    	la      a0 file_name    # Имя открываемого файла
    	li   	a1 0        	# Открыть для чтения (флаг = 0)
    	ecall             	# Дескриптор файла в a0 или -1)
    	li	s1 -1		# Проверка на корректное открытие
    	beq	a0 s1 er_name	# Ошибка открытия файла
    	mv   	s0 a0       	# Сохранение дескриптора файла

    	# Чтение информации из открытого файла
    	li   	a7, 63       	# Системный вызов для чтения из файла
    	mv   	a0, s0       	# Дескриптор файл
    	la   	a1, main_str   	# Адрес буфера для читаемого текста
    	li   	a2, SIZE 	# Размер читаемой порции
    	ecall             	# Чтение
    	
    	# Проверка на корректное чтение
    	beq	a0 s1 er_read	# Ошибка чтения
    	mv   	s2 a0       	# Сохранение длины текста

    	# Закрытие файла
    	li   	a7, 57       	# Системный вызов закрытия файла
    	mv   	a0, s0       	# Дескриптор файла
    	ecall             	# Закрытие файла

    	# Установка нуля в конце прочитанной строки
    	la 	t5 main_str
    	la	t0 main_str	# Адрес начала буфера
    	add 	t0 t0 s2	# Адрес последнего прочитанного символа
    	addi 	t0 t0 1		# Место для нуля
    	sb	zero (t0)	# Запись нуля в конец текста
ret

er_name:
    	# Сообщение об ошибочном имени файла
    	la	a0 er_name_mes
    	li	a7 4
    	ecall
	Exit()
	
er_read:
    	# Сообщение об ошибочном чтении
    	la	a0 er_read_mes
    	li	a7 4
    	ecall
	Exit
