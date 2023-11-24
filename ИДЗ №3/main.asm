.include "macrolib.asm"

.text
.global main

main:       
	# Вызов подпрограммы для выгрузки строки из файла
	jal read_from_file

	# Вывод вывод содержания файла
    	PrintString(read_str, t5)

	# Вызов подпрограммы для обработки строки
  	StringProcessing(t5)
  	
  	# Возможность пользователя выбрать вывести результат или нет
  	UserDecision(t1)
  	bgtz a3 print_result
  	j no_result

# Пользователь хочет видеть результат
print_result:
  	# Вывод результата
  	PrintString(res, t3)

no_result:
  	# Запись результата в файл
  	jal out_in_file
  	
  	# Вывода диалогового окна с сообщением об успешной записи результата в файл
  	li 	t1 1 
  	ShowMessage(success, t1)
  	
  	# Вызов тестовых подпрограмм
  	jal test
  	jal test_macro
  	
  	# Завершение работы программы
  	Exit()
