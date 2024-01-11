.data 
entero:	.word 0xabcd12bd
	
.text
	lw $t0,entero 
	andi $t1,$t0,0x894d12bd
	addi $t3,$zero,0x10000000
	la $s0, ($t3)
	sw $t1,($s0)
