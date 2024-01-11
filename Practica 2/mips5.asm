	.data 
	
Vector: .word 1,2,3,4,5,6,7,8,9,0

total: 	.word
canti: 	.word 10

	.text 

main:	la $s1, Vector ($0)
	li $t1, 0
	lw $t2, canti ($0)
	li $t4, 0
	
loop:	lw $s2,($s1)
	addi $s1,$s1,4
	addi $t1,$t1,1
	bnez $s2, F

T: 	addi $t4, $t4,1

F:	ble $t1,$t2, loop

ending:	sw $t4, total ($0)

	j loop
