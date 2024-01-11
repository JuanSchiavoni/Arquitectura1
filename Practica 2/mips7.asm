	.data
string:	.asciiz "hola"
letra:	.byte 'o'
	.align 2
res: 	.space 4

	.text

main:	la $t0, string($0)
	lb $t1, letra($0)
	lw $t2, res($0)

loop:	lb $t3, 0($t0)
	bnez $t3, busca
	beqz $t3, fin

busca:	seq $t4, $t3, $t1
	add $t2, $t2, $t4
	addi $t0, $t0, 1
	j loop
	 	
fin: 	sw $t2, res  #aca
