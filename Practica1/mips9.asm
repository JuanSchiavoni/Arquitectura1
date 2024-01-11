.data
Palabra:    .word 0x10203040
PalabraR:   .space 4

.text
 lb $s0,Palabra ($0)
 lb $s1,Palabra + 1 ($0)
 lb $s2,Palabra + 2 ($0)
 lb $s3,Palabra + 3 ($0)
 sb $s0,PalabraR + 3($0)
 sb $s1,PalabraR + 2($0)
 sb $s2,PalabraR + 1($0)
 sb $s3,PalabraR    ($0)