	.data 
Vector: .word 1,-4,-5,2
res: 	.space 1
	.text

main:	lw $s1, Vector($0)
	lw $s2, Vector+4
	lw $s3, Vector+8
	lw $s4, Vector+12

	bgez $s1, final
	bgez $s2, final
	bgez $s3, final
	bgez $s4, final

final1:	li $s5,1
	sb $s4, res ($0)
	j ending

final:  li $s5, 0
	sb $s5, res($0)

ending:
