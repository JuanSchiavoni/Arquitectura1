.data 0x10000000
	vector1: .word 18,-1215

.text
	la $s1, vector1
	lw $t0, 0($s1)
	lw $t1, 4($s1)
	li $t2, 5
	div $t0,$t2
	mflo $t3
	div $t1,$t2
	mflo $t4
	addi $t5, $zero, 0x10010000
	la $s0,($t5)
	sw $t3,0($s0)
	sw $t4,4($s0)
