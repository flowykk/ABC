.include "macrolib.asm"

.text
.global main

main:       
	# Вызов подпрограммы для выгрузки строки из файла
	jal read_from_file

	# Вывод вывод содержания файла
    	PrintPrompt(read_str)
    	PrintString(t5)

	# Вызов подпрограммы для обработки строки
  	StringProcessing(t5)
  	
  	# Возможность пользователя выбрать вывести результат или нет
  	UserDecision(t1)
  	bgtz a0 print_result
  	j no_result

# Пользователь хочет видеть результат
print_result:
  	# Вывод результата
  	#PrintPrompt(result_str)
  	PrintString(t3)

no_result:
  	# Запись результата в файл
  	jal out_in_file
  	
  	# Завершение работы программы
  	Exit()
