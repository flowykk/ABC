.include "macrolib.asm"

.text
.global main

main: 
	PrintPrompt(prompt)
	InputNumber(t1)
	lui  	t3, 0xffff0 
	li t4 16
	bge t1 t4 dot
	li t6 0
	j loop

dot:
	mv t6 t1
	div t1 t1 t4
	mul t1 t1 t4
	sub t1 t6 t1

	li t6 1
	
loop:
	li 	t0 0	
	beq 	t1 t0 num_0
	
	li 	t0 1	
	beq 	t1 t0 num_1
	
	li 	t0 2	
	beq 	t1 t0 num_2
	
	li 	t0 3	
	beq 	t1 t0 num_3
	
	li 	t0 4	
	beq 	t1 t0 num_4
	
	li 	t0 5	
	beq 	t1 t0 num_5
	
	li 	t0 6	
	beq 	t1 t0 num_6
	
	li 	t0 7	
	beq 	t1 t0 num_7
	
	li 	t0 8
	beq 	t1 t0 num_8
	
	li 	t0 9	
	beq 	t1 t0 num_9
	
	li 	t0 10	
	beq 	t1 t0 num_10
	
	li 	t0 11	
	beq 	t1 t0 num_11

	li 	t0 12	
	beq 	t1 t0 num_12
	
	li 	t0 13	
	beq 	t1 t0 num_13
	
	li 	t0 14
	beq 	t1 t0 num_14
	
	li 	t0 15	
	beq 	t1 t0 num_15
	
	addi 	t0 t0 1
	beq	t0 t4 check

num_0:
	li    	t5 0x3f
	j indicator_loop

num_1:
	li    	t5 0x6
	j indicator_loop

num_2:
	li    	t5 0x5b
	j indicator_loop

num_3:
	li    	t5 0x4f
	
	j indicator_loop

num_4:
	li    	t5 0x66
	j indicator_loop

num_5:
	li    	t5 0x6d
	j indicator_loop

num_6:
	li    	t5 0x7d
	j indicator_loop

num_7:
	li    	t5 0x7
	j indicator_loop

num_8:
	li    	t5 0x7f
	j indicator_loop

num_9:
	li    	t5 0x6f
	j indicator_loop

num_10:	
	li    	t5 0x77
	j indicator_loop
	

num_11:	
	li    	t5 0x7c
	j indicator_loop

num_12:
	li    	t5 0x58
	j indicator_loop

num_13:
	li    	t5 0x5e
	j indicator_loop

num_14:
	li    	t5 0x79
	j indicator_loop

num_15:
	li    	t5 0x71
	j indicator_loop

indicator_loop:
	bgtz 	t6 set_dot
	j next
	
set_dot:
	addi 	t5 t5 0x80 

next:
	mv 	t2 t5
    	sb    	t2 0x10(t3)
    	Sleep()
    	li    	t2 0x0
    	sb    	t2 0x10(t3)
    	
    	mv 	t2 t5
    	sb    	t2 0x11(t3)
    	Sleep()
    	li    	t2 0x0
    	sb    	t2 0x11(t3)
    	j next

check:
	Exit()
