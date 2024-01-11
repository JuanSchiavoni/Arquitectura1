.data 0x10000000

	vector: .space 20 #resevo 20 porque son 5 enteros de 4bytes
	
.text
main:	addi $s0, $zero, 10 #$t0 = 0 + 10
	addi $s1, $zero, 20
	addi $s2, $zero, 25
	addi $s3, $zero, 500
	addi $s4, $zero, 3
	
	addi $t0, $zero, 0
	
	sw $s0, vector($t0)
	   addi $t0, $t0, 4 #sumo 4 bytes para pasar al sigiente entero
	sw $s1, vector($t0)
	   addi $t0, $t0, 4
	sw $s2, vector($t0)
           addi $t0, $t0, 4
        sw $s3, vector($t0)
      	   addi $t0, $t0, 4
      	sw $s3, vector($t0)
      	   
