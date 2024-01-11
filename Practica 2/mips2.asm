	.data
Vector: .word 2, -4, -6
res: 	.space 3
	.text
	
main:	lw $s1, Vector($0)	#carga del vector en el registro 
	lw $s2, Vector + 4	#carga del vector en el registro 
	lw $s3, Vector + 8	#carga del vector en el registro 

	#comparaciones 	
	slt $t1,$0,$s1
	slt $t2,$0,$s2
	slt $t3,$0,$s3

	sb $t4, res($0)
	sb $t5, res+1
	sb $t5, res+2
