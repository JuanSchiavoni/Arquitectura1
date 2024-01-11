.data 
	entero: .word 0xff0f1235

.text 
	lw $t0,entero 
	xori $t1,$t0,0x22800000
	addi $t3,$zero,0x10000000
	la $s0, ($t3)
	sw $t1,($s0)
