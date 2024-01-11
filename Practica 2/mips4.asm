	.data

dato1: 	.word 2
dato2:  .word 10
dato3: 	.word 50
dato4: 	.word 70
dato5: 	.word 34

res: 	.word

	.text
main:	lw $s1,dato1 ($0)
	lw $s2,dato2 ($0)
	lw $s3,dato3 ($0)
	lw $s4,dato4 ($0)
	lw $s5,dato5 ($0)

	blt $s5,$s1, sigue
	bgt $s5,$s2, sigue
	j V
	
sigue:	blt $s5,$s3, V
	bgt $s5,$s4, V

V:	li $t2,1
	j final
	
F:	li $t2,0

final: sw $t2, res ($0)
