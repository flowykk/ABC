.include "macros.asm"

.text

main:
	InputArrayLength(t0, t1, t3) # Ввод и проверка длины массивов
        
	FillArray(t0, t1, t3) # Заполнение массива А и массива Б
	
	# Вывод массивов до каких-либо изменений
	PrintPrompt(prompt5)
	PrintPrompt(ln)
 	PrintArray(t0, t1, t3)
 	
 	# Имзенение всех нулевых элементов, стоящих до первого отрицательного, на единицу 
 	li 	t5 1 # Вспомогательный флаг для отслеживания первого отрицательного элемента
 	EditElems(t1, t3, t5)
 	
 	# Вывод массивов после того, как были изменены элементы
 	PrintPrompt(prompt6)
	PrintPrompt(ln)
 	PrintArray(t0, t1, t3)
 	
 	# Выход из программы
 	Exit()

    	
  
