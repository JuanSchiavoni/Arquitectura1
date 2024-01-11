	.data
V: 	.word 1,2,3,4,5,6,7,8,9,0
canti: 	.word 10
rango1: .word 1
rango2: .word 5
total:  .word

	.text
	
main:	la $s1,V ($0)
	lw $s2,canti ($0)
	lw $s3,rango1 ($0)
	lw $s4,rango2 ($0)
	li $s5, 0
	li $t2, 0

loop:	lw   $t1,($s1)
	addi $s1,$s1,4
	addi $s5,$s5,1

	blt $t1,$s3,F
	bgt $t1,$s4,F

	addi $t2,$t2,1

F:	ble  $s5,$s2,loop

ending:	sw $t2,total ($0)
