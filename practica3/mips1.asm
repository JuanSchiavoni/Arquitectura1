	 .data
	 
slist: 	 .word 0
cclist:  .word 0
wclist:  .word 0
schedv:  .space 36
menu: 	 .ascii "Colecciones de objetos categorizados\n"
 	 .ascii "====================================\n"
 	 .ascii "1-Nueva categoria\n"
 	 .ascii "2-Siguiente categoria\n"
 	 .ascii "3-Categoria anterior\n"
 	 .ascii "4-Listar categorias\n"
 	 .ascii "5-Borrar categoria actual\n"
 	 .ascii "6-Anexar objeto a la categoria actual\n"
 	 .ascii "7-Listar objetos de la categoria\n"
 	 .ascii "8-Borrar objeto de la categoria\n"
 	 .ascii "0-Salir\n"
 	 .asciiz "Ingrese la opcion deseada: "
error:   .asciiz "Error: "
return:  .asciiz "\n"
catName: .asciiz "\nIngrese el nombre de una categoria: "
selCat:  .asciiz "\nSe ha seleccionado la categoria:"
idObj: 	 .asciiz "\nIngrese el ID del objeto a eliminar: "
objName: .asciiz "\nIngrese el nombre de un objeto: "
success: .asciiz "La operación se realizo con exito\n\n"
espacio: .asciiz "-----------------------\n"
donde: 	 .asciiz ">"
noesta:  .asciiz "Not found\n"

	.text
	.globl main
	
main:
 	la $t0, schedv # inicializacion del vector scheduler
 	la $t1, final
 	sw $t1, 0($t0)
 	la $t1, nuevacategoria
	sw $t1, 4($t0)
 	la $t1, siguientecategoria
 	sw $t1, 8($t0)
 	la $t1, anteriorcat
 	sw $t1, 12($t0)
 	la $t1, listarcat
 	sw $t1, 16($t0)
 	la $t1, borrarcat
 	sw $t1, 20($t0)
 	la $t1, nuevoelemento
 	sw $t1, 24($t0)
 	la $t1, listarelementos
 	sw $t1, 28($t0)
 	la $t1, borrarelemento
 	sw $t1, 32($t0)

inicio:
 	jal mostrar_menu
 	li $v0, 5
 	syscall
 	move $a0, $v0
 	jal controla_ingreso
 	li $t0, -1
 	beq $v0, $t0, inicio
 	move $t0, $v0
 	sll $t0, $t0, 2
 	lw $t0, schedv($t0)
 	la $ra, inicio
 	jr $t0


#-------------------------------------------------------------------------------------------------------------------------------------------
# 1)
nuevacategoria:
 	addiu $sp, $sp, -4
 	sw $ra, 4($sp)
 	la $a0, catName 	# ingresa el nombre de la categoria
 	jal getblock
 	move $a2, $v0 		# $a2 = *char a nombre de categoria
 	la $a0, cclist 		# $a0 = lista
 	li $a1, 0 		# $a1 = NULL
 	jal addnode
 	lw $t0, wclist
 	bnez $t0, newcategory_end
 	sw $v0, wclist # actualiza la lista si es NULL
 	
newcategory_end:
 	li $v0, 0 # return resultado
 	lw $ra, 4($sp)
 	addiu $sp, $sp, 4
 	jr $ra
 

 	# a0: direccion lista
 	# a1: NULL si categoria, direccion de nodo si elemento
 	# a2: *char a nombre de nodo
 	# v0: dicreccion de nodo agregado
addnode:
 	addi $sp, $sp, -8
 	sw $ra, 8($sp)
 	sw $a0, 4($sp)
 	jal smalloc
 	sw $a1, 4($v0) 		# contenido del nodo
 	sw $a2, 8($v0)
 	lw $a0, 4($sp)
 	lw $t0, ($a0) 		# direccion del primer nodo
 	beqz $t0, addnode_empty_list
 	
addnode_to_end:
 	lw $t1, ($t0) 		# ultimo nodo agregado
 	# actualizar puteros anterior y posterior del nuevo nodo
 	sw $t1, 0($v0)
 	sw $t0, 12($v0)
 	# actualizar puteros anterior y posterior al nuevo nodo
 	sw $v0, 12($t1)
 	sw $v0, 0($t0)
 	j addnode_exit
 	
addnode_empty_list:
 	sw $v0, ($a0)
 	sw $v0, 0($v0)
 	sw $v0, 12($v0)
 	
addnode_exit:
 	lw $ra, 8($sp)
 	addi $sp, $sp, 8
 	jr $ra
 
 
 	# a0: dir del nodo a borrar
 	# a1: dir de la lista donde se elimina el nodo
delnode:
 	addi $sp, $sp, -8
 	sw $ra, 8($sp)
 	sw $a0, 4($sp)
 	lw $a0, 8($a0) 		# direccion del bloque
 	jal sfree 		# liberar bloque
 	lw $a0, 4($sp) 		# restaurar argumento a0
 	lw $t0, 12($a0) 	# direccion del nodo siguiente de a0
 	
node:
 	beq $a0, $t0, delnode_point_self
 	lw $t1, 0($a0) 		# direccion del nodo anterior
 	sw $t1, 0($t0)
 	sw $t0, 12($t1)
 	lw $t1, 0($a1) 		# direccion del primer nodo
 	
again:
 	bne $a0, $t1, delnode_exit
 	sw $t0, ($a1) 		# puntero lista al sig nodo
 	j delnode_exit
 	
delnode_point_self:
 	sw $zero, ($a1) 	# solo un nodo
 	
delnode_exit:
 	jal sfree
 	lw $ra, 8($sp)
 	addi $sp, $sp, 8
 	jr $ra


	# a0: msj para preguntar
	# v0: direccion de bloque asignada con string
getblock:
 	addi $sp, $sp, -4
 	sw $ra, 4($sp)
 	li $v0, 4
	syscall
 	jal smalloc
 	move $a0, $v0
 	li $a1, 16
 	li $v0, 8
 	syscall
 	move $v0, $a0
 	lw $ra, 4($sp)
 	addi $sp, $sp, 4
 	jr $ra


smalloc:
 	lw $t0, slist
 	beqz $t0, sbrk
 	move $v0, $t0
 	lw $t0, 12($t0)
 	sw $t0, slist
 	jr $ra


sbrk:
 	li $a0, 16 		# tamaño fijo de nodo 4 words
 	li $v0, 9
 	syscall 		# return direccion de nodo en v0
 	jr $ra


sfree:
 	lw $t0, slist
 	sw $t0, 12($a0)
 	sw $a0, slist 		# $a0 dir de nodo en la lista no usada
 	jr $ra


mostrar_menu:
 	la $a0, return
 	li $v0, 4
 	syscall
 	la $a0, menu
 	syscall
 	jr $ra


	# a0: numero dado por el usuario
	# v0: si el numero es un ingreso correcto, -1 si es incorrecto
controla_ingreso:
 	bltz $a0, ingreso_incorrecto
 	li $t0, 8
 	bgt $a0, $t0, ingreso_incorrecto
 	move $v0, $a0
 	jr $ra
 	
ingreso_incorrecto:
 	li $a0, 101
 	addi $sp, $sp, -4
 	sw $ra, 4($sp)
 	jal salto_error
 	lw $ra, 4($sp)
 	addi $sp, $sp, 4
 	li $v0, -1
 	jr $ra
 	

#-------------------------------------------------------------------------------------------------------------------------------------------
# 2)
siguientecategoria:
 	addi $sp, $sp, -4
 	sw $ra, 4($sp)
 	lw $t0, wclist
 	beqz $t0, nohaycat
 	lw $t1, 12($t0)
 	beq $t0, $t1, hayunacat
 	sw $t1, wclist
 	jr $ra


#-------------------------------------------------------------------------------------------------------------------------------------------
# 3)
anteriorcat:
 	lw $t0, wclist
 	addi $sp, $sp, -4
 	sw $ra, 4($sp)
 	beqz $t0, nohaycat
 	lw $t1, ($t0)
 	beq $t0, $t1, hayunacat
 	sw $t1, wclist
 	jr $ra

nohaycat:
 	li $a0, 201
 	jal salto_error
 	lw $ra, 4($sp)
 	addi $sp, $sp, 4
 	jr $ra

hayunacat:
 	li $a0, 202
 	jal salto_error
 	lw $ra, 4($sp)
 	addi $sp, $sp, 4
 	jr $ra


#-------------------------------------------------------------------------------------------------------------------------------------------
# 4)
listarcat:
 	lw $t0, cclist
 	addi $sp, $sp, -4
 	sw $ra, 4($sp)
 	beqz $t0, no_hay
 	move $a0, $t0
 	jal imprimir_categrorias
 	lw $ra, 4($sp)
 	addi $sp, $sp, 4
 	jr $ra

no_hay:
 	li $a0, 301
 	jal salto_error
 	lw $ra, 4($sp)
 	addi $sp, $sp, 4
 	jr $ra

	# a0: Principio de categorias
imprimir_categrorias:
 	move $t0, $a0
 	move $t1, $t0
 	lw $t2, wclist
 	
listar_categorias:
 	li $v0, 4
 	bne $t2, $t1, no_esta_aca
 	la $a0, donde		# Imprime ">" que marca cual es la categoria en la que se esta trabajando
 	syscall
 	
no_esta_aca:
 	lw $a0, 8($t1)
 	syscall
 	lw $t1, 12($t1)
 	bne $t1, $t0, listar_categorias
 	jr $ra			# Mientras el siguiente no sea nuevamnete la primera categoria


#-------------------------------------------------------------------------------------------------------------------------------------------
# 5)
borrarcat:
 	addi $sp, $sp, -4
	sw $ra, 4($sp)
 	lw $a1, wclist
 	beqz $a1, sin_cat
 	
 	lw $s0, 4($a1)
 	addi $a1, $a1, 4 	# direccion lista
 	beqz $s0, no_hay_ahora 	# elimina todo los nodos de elementos
 	
borra_todos:
 	move $a0, $s0
 	lw $s0, 12($s0)
 	jal delnode
 	lw $t1, ($a1)
 	bnez $t1, borra_todos 	# si la lista no esta vacia
 	
no_hay_ahora: 			# elimina el nodo de categoria
 	lw $a0, wclist
 	lw $t0, 12($a0)
 	beq $a0, $t0, iguales
 	sw $t0, wclist
 	j distintos
 	
iguales:
 	sw $0, wclist
 	
distintos:
 	la $a1, cclist
 	jal delnode
 

 	lw $ra, 4($sp)
 	addi $sp, $sp, 4
 	jr $ra

sin_cat:
 	li $a0, 401
 	jal salto_error
 	lw $ra, 4($sp)
 	addi $sp, $sp, 4
 	jr $ra


#-------------------------------------------------------------------------------------------------------------------------------------------
# 6)
nuevoelemento:
 	addi $sp, $sp, -4
 	sw $ra, 4($sp)
 	lw $t0, wclist
 	beqz $t0, faltan_listas
 	la $a0, objName
 	jal getblock

 	move $a2, $v0 		# $a2 = *char a nombre de elemento
 	lw $a0, wclist
 	jal obtener_num
 
 	addi $a0, $a0, 4	# $a0 = lista
 	move $a1, $v0 		# Identificador de objeto
 	jal addnode
 	lw $ra, 4($sp)
 	addi $sp, $sp, 4
 	jr $ra

 
	# a0: nodo que contiene a la lista
	# v0: nuevo identificador
obtener_num:
 	lw $t0, 4($a0)
 	beqz $t0, no_hay_elementos
 	lw $t0, ($t0)
 	lw $t0, 4($t0)
 	addi $v0, $t0, 1
 	jr $ra
 	
no_hay_elementos:
 	li $v0, 1
 	jr $ra

faltan_listas:
 	li $a0, 501
 	jal salto_error
 	lw $ra, 4($sp)
 	addi $sp, $sp, 4
 	jr $ra


#-------------------------------------------------------------------------------------------------------------------------------------------
# 7)
listarelementos:
 	lw $t0, wclist
 	beqz $t0, no_hay_listas
 	lw $t1, 4($t0)
	beqz $t1, no_hay_objs
 	move $a0, $t0
 	move $a1, $t1
 	addi $sp, $sp, -4
 	sw $ra, 4($sp)
 	jal imprimir_elementos
 	lw $ra, 4($sp)
 	addi $sp, $sp, 4
 	jr $ra

no_hay_listas:
 	li $a0, 601
 	addi $sp, $sp, -4
 	sw $ra, 4($sp)
 	jal salto_error
 	lw $ra, 4($sp)
	addi $sp, $sp, 4
 	jr $ra

no_hay_objs:
 	li $a0, 602
 	addi $sp, $sp, -4
 	sw $ra, 4($sp)
 	jal salto_error
 	lw $ra, 4($sp)
 	addi $sp, $sp, 4
 	jr $ra

	# a0: categoria que trabajo
	# a1: lista de elementos
imprimir_elementos:			
 	lw $a0, 8($a0)		# El nombre de la categoria
 	li $v0, 4
 	syscall
 	la $a0, espacio
 	syscall
	# Listamos la categoria
 	move $t0, $a1
 	move $t1, $t0
 	
sig_elemento:
 	lw $a0, 4($t1)
 	li $v0, 1
 	syscall
 	li $v0, 11
 	li $a0, '-'
 	syscall
 	lw $a0, 8($t1)
 	li $v0, 4
 	syscall
 	lw $t1, 12($t1)
 	bne $t1, $t0, sig_elemento
 	jr $ra
 	

#-------------------------------------------------------------------------------------------------------------------------------------------
# 8)
borrarelemento:
 	addi $sp, $sp, -4
 	sw $ra, 4($sp)
 	lw $t0, wclist
 	beqz $t0, no_hay_cat
 	la $a0, idObj
 	li $v0, 4
 	syscall
 	li $v0, 5
 	syscall
 	move $t3, $v0 	# t3 contiene el id
 	lw $t0, 4($t0)
 	move $t1, $t0
 	
siguiente:
 	lw $t2, 4($t1)
 	beq $t2, $t3, encontrado
 	lw $t1, 12($t1)
 	beq $t0, $t1, no_encontrado
 	j siguiente

encontrado:
 	move $a0, $t1 	# a0: direccion de nodo
 	lw $a1, wclist
 	addi $a1, $a1, 4 # direccion de lista
 	lw $s0, 12($a0)
 	jal delnode
 	move $a0, $s0
 	lw $a1, wclist
 	lw $a1, 4($a1)
 	jal actualizar_Ids
 	lw $ra, 4($sp)
 	addi $sp, $sp, 4
 	jr $ra

no_encontrado:
 	la $a0, noesta
 	li $v0, 4
 	syscall
 	lw $ra, 4($sp)
 	addi $sp, $sp, 4
 	jr $ra

	# a0 siguiente nodo en la lista
	# a1 nodo con el primer ID
actualizar_Ids:
 	beqz $a1, finalizar
 	beq $a0, $a1, chequeo
 	lw $t0, 4($a0)
 	addi $t0, $t0, -1
 	sw $t0, 4($a0)
 	lw $a0, 12($a0)
 	j actualizar_Ids
 	
chequeo:
 	lw $t0, 4($a0)
 	bne $t0, 1, no_finalizar
 	
finalizar:
 	jr $ra

no_finalizar:
 	addi $t0, $t0, -1
 	sw $t0, 4($a0)
 	lw $a0, 12($a0)
 	j actualizar_Ids

no_hay_cat:
 	li $a0, 701
 	jal salto_error
 	lw $ra, 4($sp)
 	addi $sp, $sp, 4
 	jr $ra

	# a0: numero de error ocurrido
salto_error:
	move $t0, $a0
 	la $a0, error
 	li $v0, 4
 	syscall
 	move $a0, $t0
 	li $v0, 1
 	syscall
 	jr $ra

final:
 	li $v0, 10
 	syscall