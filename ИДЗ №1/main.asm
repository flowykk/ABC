.include "macrolib.asm"

.text

main:
	InputArrayLength(t0, t1, t3) # Ввод и проверка длины массивов
        
	FillArray(t0, t1, t3) # Заполнение массива А и массива Б
	
	# Вывод массивов до каких-либо изменений
	PrintPrompt(prompt5)
	PrintPrompt(ln)
 	jal print_array
 	
 	# Имзенение всех нулевых элементов, стоящих до первого отрицательного, на единицу 
 	li 	t5 1 # Вспомогательный флаг для отслеживания первого отрицательного элемента
 	jal edit_elems
 	
 	# Вывод массивов после того, как были изменены элементы
 	PrintPrompt(prompt6)
	PrintPrompt(ln)
 	jal print_array
 	
 	# Выход из программы
 	Exit()
 	
# Подпрограмма для вывода элементов двух массивов
# t0 - адрес на первый элемент массива А
# t1 - адрес на первый элемент массива Б (копии массива А)
# t3 - будущее количество элементов в массивах
print_array:
	PrintPrompt(prompt3)
	
out_array:
	li      a7 1
        lw      a0 (t0)
        ecall
        
        li      a0 ' '
        li      a7 11
        ecall
        
        addi    t0 t0 4
        addi    t3 t3 -1

        bnez    t3 out_array
        
        lw	t3 n
        
        PrintPrompt(ln)
        PrintPrompt(prompt4)
        
out_copy_array:
	li      a7 1
        lw      a0 (t1)
        ecall
        
        li      a0 ' '
        li      a7 11
        ecall
        
        addi    t1 t1 4
        addi    t3 t3 -1

        bnez    t3 out_copy_array
        
        lw	t3 n
        la      t1 copy_array
        la      t0 array
        
        PrintPrompt(ln)
        PrintPrompt(sep)
ret

# Подпрграмма для замены всех нулевых элементов, стоящих до первого отрицательного, единицами
# t1 - адрес на первый элемент массива Б (копии массива А)
# t3 - будущее количество элементов в массивах
# t5 - регистр, который хранит вспомогательный флаг
edit_elems:
        lw      a0 (t1)
	
	li 	t4 0
	blt 	a0 t4 edit_flag
	beq	a0 t4 edit
	j 	loop_next
	
edit:
	li      t2 1    
	bne 	t5 t2 loop_next
        sw      t2 (t1) 
        j 	loop_next
        
edit_flag:
	li 	t5 2

loop_next:
        addi    t1 t1 4
        addi    t3 t3 -1

        bnez    t3 edit_elems
        
        lw	t3 n
        la      t1 copy_array
ret
