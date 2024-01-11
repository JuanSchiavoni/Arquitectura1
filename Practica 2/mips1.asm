	.data 
Vector: .byte 0,1,1,1,0
res: 	.space 1

	.text
	
main:
	lb $s1, Vector($0)    #carga del vector en registro
	lb $s2, Vector+1($0)  #carga del vector en registro
	lb $s3, Vector+2($0)  #carga del vector en registro
	lb $s4, Vector+3($0)  #carga del vector en registro
	lb $s5, Vector+4($0)  #carga del vector en registro

	#COMPARACIONES
	and $t1,$s1,$s5
	or  $t2,$s2,$s4
	or  $t3,$s1,$s2
	and $t3,$t3,$s3
	sb $t1, res
	sb $t2, res+1
	sb $t3, res+2
