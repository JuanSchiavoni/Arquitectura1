.data 0x10000000

array:	.space 8 #reservo espacio para el array

.text
	addi $s0, $zero, 10   #cargo el elemento 1 del array
	addi $s1, $zero, 20   #cargo el elemento 2 
	
	addi $t0, $zero, 0	#incdice = $t0
	
	sw $s0, array($t0)	#ubico el primer numero en la primera posicion del array
		addi $t0, $t0, 4 
	sw $s1, array($t0)	#ubicto el segundo n en la 2da posicion del array
	
	move $t0, $s0   	#muevo los numeros a los registros t para hacer la suma
	move $t1, $s1
	
	add $t2, $t0, $t1	#hago la suma 
	
	#muestro el resultado 
	li $v0, 1
	move $a0, $t2
	syscall
	
	
	
