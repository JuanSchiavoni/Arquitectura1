.data 

dato: .byte 3 #inicializo una psicion de memoria a 3

.text
.globl main #debe ser global

main: lw $t0, dato($0)

#etiquetas: las etiquetas son dato: y main:. Son las que van seguidas de :

#comentarios: son los que van despues del #, y sirven para aclarar que es lo que estamos haciendo

#directivas: Las directivas son las que vienen despues de un punto. .data .text .globl