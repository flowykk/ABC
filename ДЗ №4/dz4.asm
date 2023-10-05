.data
sep:    .asciz  "--------\n"
prompt: .asciz  "Максимальный допустимый аргумент факториала: "
prompt1: .asciz  ", его факториал: "
ln:     .asciz "\n"

.text
main:
        li      a1, 1

loop:
    	mv      a0, a1
        jal     fact
        
	li      a7, 1
        ecall
        
        li      t0, 2147483647
        addi 	a2, a1, 1
        div	a3, t0, a2
	
        blt 	a3, a0, end
        
        li      a7, 4
        la      a0, ln
        ecall
        
        addi    a1, a1, 1
        j       loop

end:
	li      a7, 4
        la      a0, ln
        ecall
        
	li      a7, 4
        la      a0, sep
        ecall
        
        li      a7, 4
        la      a0, prompt
        ecall
        
	mv	a0, a1
	li      a7, 1
        ecall
        
        li      a7, 4
        la      a0, prompt1
        ecall
        
        mv	a0, a1
        jal     fact
	li      a7, 1
        ecall
        
        li      a7, 10
        ecall

fact:   addi    sp sp -8
        sw      ra 4(sp)
        sw      s1 (sp)

        mv      s1 a0
        addi    a0 s1 -1
        li      t0 1
        ble     a0 t0 done
        jal     fact
        mul     s1 s1 a0

done:   mv      a0 s1
        lw      s1 (sp)
        lw      ra 4(sp)
        addi    sp sp 8
        ret
