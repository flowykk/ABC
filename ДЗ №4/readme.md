# Домашнее задание №4
## Код программы
```assembly
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

fact:   addi    sp, sp, -8
        sw      ra, 4(sp)
        sw      s1, (sp)

        mv      s1, a0
        addi    a0, s1 -1
        li      t0, 1
        ble     a0, t0, done
        jal     fact
        mul     s1, s1, a0

done:   mv      a0, s1
        lw      s1, (sp)
        lw      ra, 4(sp)
        addi    sp, sp 8
        ret
```

## Скриншоты, демонстрирующий работу программы.
<img width="1440" alt="Снимок экрана 2023-10-05 в 19 59 49" src="https://github.com/flowykk/ABC/assets/71427624/ed072445-519d-4215-9c8c-8a9cbfabc174">
<img width="1440" alt="Снимок экрана 2023-10-05 в 19 59 57" src="https://github.com/flowykk/ABC/assets/71427624/926b88ff-6e63-47dc-8f5b-a3de7a364fe5">

По результатам работы программы видим, что максимальное значение аргумента, при котором результат вычисления факториала размещается в 32-х разрядном машинном слове - это 12, факториал которого равняется *__479_001_600__*. Факториал же 13 будет *__6_227_020_800__*, что чуть ли не в 3 раза больше максимально допустимого числа: *__2_147_483_647__*.
