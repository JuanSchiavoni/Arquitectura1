.data 0x10010002

byte: .byte 0x10,0x20,0x30,0x40

.text

la $s0, byte

lb $t1, 0($s0)
lb $t2, 1($s0)
lb $t3, 2($s0)
lb $t4, 3($s0)


addi $t5,$zero,0x10010100
la $s1,($t5)

sb $t1, 0($s1)
sb $t2, 1($s1)
sb $t3, 2($s1)
sb $t4, 3($s1)