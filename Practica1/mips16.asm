.data 
	numero: .word 0x1237
	
.text
	lw $t0,numero($0)
	sll $t1,$t0,5
	addi $t2,$zero,0x10000000
	la $s0,($t2)
	sw $t1,($s0)
