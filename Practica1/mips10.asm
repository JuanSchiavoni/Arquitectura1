.data 
	palabra: .word 0x10203040

.text
main:   lh $s0, palabra($0)
	addi $t0, $t0, 2
	lh $s1, palabra($t0)
	
	sh $s1, 0x10010000
	sh $s0, 0x10010002
	