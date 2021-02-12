.data

	prompt: .asciiz "\n Especifique una accion a realizar para la lista vinculada:"
	newCategory: .asciiz "\n \t A Crear una categoria"
	nextCategory: .asciiz "\n \t B Categoria siguiente"
	prevCategory: .asciiz "\n \t C Categoria anterior"
	delCategory: .asciiz "\n \t D Eliminar una categoria"
	display: .asciiz "\n \t E Mostrar las categorias"
	newObject: .asciiz "\n \t F Crear un objeto"
	delObject: .asciiz "\n \t G Elimina objeto"
	addNode: .asciiz "\n \t H Agrega un nodo"
	delNode:.asciiz "\n \t I Elimina un nodo"
	orTerminate: .asciiz "\n \t T para terminar:"
	askForCat: .asciiz "\n\n\tIngrese el nombre de la categoria: "
    


    slist: .word 0 # inicializado a null
    next:  .word 0 # inicializado a null
    prev:  .word 0 # inicializado a null
    #numbers: .word 1,2,3,4 # lista de enteros  
.text

# ================================================================================================ #
# Punto de entrada del programa. Solicita la entrada del usuario y dirige a las opciones del menú. #
# ================================================================================================ #

main:	lw $s1, slist				# head = nullptr
        lw $s2, next
        lw $s3, prev
#main: li $s1, numbers
      #li $s1, 4
#loop: lw $a0, ($s0)
      #jal Newnode
      #addi $s0, $s0, 4
      #addi $s1, $s1, -1
      #bnez $s1, loop
	
loop:	jal PrintMenu				#Imprime el indicador del menu y las opciones
	    jal GetUserMenuInput		#Recupera la entrada del usuario desde la consola	

	seq $t0, $v0, 'A'
	bne $t0, $zero, A
	seq $t0, $v0, 'B'
	bne $t0, $zero, B
	seq $t0, $v0, 'C'
	bne $t0, $zero, C
	seq $t0, $v0, 'D'
	bne $t0, $zero, D
	seq $t0, $v0, 'E'
	bne $t0, $zero, E
	seq $t0, $v0, 'F'
	bne $t0, $zero, F
	seq $t0, $v0,'G'
	bne $t0, $zero, G
	seq $t0, $v0, 'H'
	bne $t0, $v0, H
	seq $t0, $v0, 'I'
	bne $t0, $v0, I
	seq $t0, $v0, 'T'
	bne $t0, $zero, Exit
	j loop

	
	A:	jal NewCategory
		j loop
	B:	jal NextCategory
		j loop
	C:	jal PrevCategory
		j loop
	D:	jal DelCategory
		j loop
	E:	jal Display
		j loop
	F:	jal NewObject
		j loop
	G:  jal DelObject
		j loop
	H:  jal AddNode
	    j loop
    I:  jal DelNode
        j loop


#======================================================================================#
#                  Imprime las opciones del menú en la consola.                        #
#======================================================================================#


PrintMenu:

	la $a0, prompt			# carga prompt en $a0 para imprimir
	li $v0, 4				# codigo syscall para imprimir cadena
	syscall					# imprime la cadena en $a0
	la $a0, newCategory		# carga la siguiente cadena
	syscall	
	la $a0, nextCategory
	syscall				
	la $a0, prevCategory				
	syscall
	la $a0, delCategory
	syscall
	la $a0, display
	syscall
	la $a0, newObject
	syscall
	la $a0, delObject
	syscall
	la $a0, addNode
	syscall
	la $a0, delNode
	syscall
	la $a0, orTerminate
	syscall
	jr $ra

#======================================================================================#
#	     Recupera la entrada del menú del usuario, almacenada en el registro $ v0.     #
#======================================================================================#

GetUserMenuInput:

	li $v0, 12				# codigo syscall para leer un char
	syscall					# lee el char (ahora esta en $v0)
	jr $ra					# regresa a la persona que llama con ese valor



#Cuando un nodo se elimina lo que se hace es pasarlo a una lista enlazada simple como
#la mencionada, que sería similar a free en C. Cuando se necesita un nodo nuevo se
#debe examinar si hay algun nodo en la lista de liberados y tomarlo de allí. Si la lista
#está vacía se recurre al syscall sbrk. Este comportamiento es muy similar a malloc en
#C pero muchísimo más siemple.

NewCategory:
    jal Sbrk
    move $t0, $a0 # preserva arg 1 
    la $a0, askForCat			# prompt user to enter an ID
	li $v0, 4				# syscall code for printing string
	syscall					# print the prompt
    #li $v0, 9
    #li $a0, 16 #era 8 pq solo necesita dos campos 16 ahora pq necesita 4
    #syscall  
    #jal Sbrk      #usar jal sbrk no funciona, queda en loop infinito       
    #sw $t0, ($v0) # guarda el arg en new node
    #lw $t1, slist
    #beq $t1, $0, First # ? si la lista es vacia
    #sw $t1, 4($v0) # inserta new node por el frente
    #sw $v0, slist # actualiza la lista
    jal Smalloc
    #jal Sfree
    jr $ra

    #First:

    #sw $0, 4($v0) # primer nodo inicializado a null
    #sw $v0, slist # apunta la lista a new node
    #jr $ra

Smalloc:

    lw $t0, slist
    beqz $t0, Sbrk
    move $v0, $t0
    lw $t0, 12($t0)
    sw $t0, slist
    jr $ra

Sbrk:

    li $v0, 9
    li $a0, 16 # node size fixed 4 words
    syscall # return node address in v0
    jr $ra

Sfree:

    la $t0, slist
    sw $t0, 12($a0)
    sw $a0, slist # $a0 node address in unused list
    jr $ra 

    
Exit:

	li $v0, 10
	syscall