.data

	prompt: .asciiz "\n Especifique una accion a realizar para la lista vinculada:"
	createcat: .asciiz "\n \t A para crear la categoria"
	deletecat: .asciiz "\n \t B para eliminar categoria"
	createobj: .asciiz "\n \t C para crear un objeto"
	deleteobj: .asciiz "\n \t D para eliminar un objeto"
	nextcat: .asciiz "\n \t E imprime categoria siguiente"
	previuscat: .asciiz "\n \t F imprime categoria anterior"
	cat:.asciiz "\n \t G imprime categoria actual"
	orTerminate: .asciiz "\n  H para terminar:"
	askForCat: .asciiz "\n \n \t Introduzca el nombre de la categoria:"
	askForObject: .asciiz "\t Introduzca el nombre del objeto:"
	alreadyExists: .asciiz "\n \n \t Ya existe una lista enlazada. Ingrese 'A' en el menú para agregar nodos o 'L' para mostrarla. \n"
    addToNullHead: .asciiz "\n \n \t Debe crear una lista vinculada antes de poder insertar un nuevo nodo. Consulte la opción de menú 'C'. \n"
	displayRequiresList: .asciiz "\n \n \t Debe crear una lista vinculada antes de poder imprimirla. Consulte la opción de menú 'C'. \n"
	searchRequiresList: .asciiz "\n \n \t Debe crear una lista vinculada antes de poder buscar un nodo. Consulte la opción de menú 'C'. \n"
	noNodesToDelete: .asciiz "\n \n \t Debe crear una lista vinculada antes de poder eliminar un nodo. Consulte la opción de menú 'C'. \n"
	nodeNotFound: .asciiz "\n \n \t El nodo solicitado no se encontró en la lista vinculada. \n"
	nodeAlreadyExists: .asciiz "\n \t El nodo con el ID solicitado ya existe en la lista vinculada. \n"
	tab: .asciiz "\t"
	newline: .asciiz "\n"

.text

# ================================================================================================ #
# Punto de entrada del programa. Solicita la entrada del usuario y dirige a las opciones del menú. #
# ================================================================================================ #

main:	li $s1, 0				# head = nullptr
	
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
	bne $t0, $zero, Exit
	j loop

	
	A:	jal Createcat
		j loop
	B:	jal Createobj
		j loop
	C:	jal Deletecat
		j loop
	D:	jal Deleteobj
		j loop
	E:	jal Nextcat
		j loop
	F:	jal Previuscat
		j loop
	G:  jal Cat
		j loop


#======================================================================================#
#                  Imprime las opciones del menú en la consola.                        #
#======================================================================================#


PrintMenu:

	la $a0, prompt			# carga prompt en $a0 para imprimir
	li $v0, 4				# codigo syscall para imprimir cadena
	syscall					# imprime la cadena en $a0
	la $a0, createcat		# carga la siguiente cadena
	syscall	
	la $a0, createobj
	syscall				
	la $a0, deletecat				
	syscall
	la $a0, deleteobj
	syscall
	la $a0, nextcat
	syscall
	la $a0, previuscat
	syscall
	la $a0, cat
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

#======================================================================================#
#    Crea un nuevo objeto, devolviendo la direccion del nodo principal     #
#======================================================================================#

Createcat:

	bne $s1, $0, AlreadyExists	 # Si head != nullptr, advertir al usuario
	#ACA DEBERIA IRSE AL NODO SIGUIENTE SI ES DIFERENTE DE 0#

	li $v0, 9				# codigo syscall (9) para asignar memoria	
	li $a0, 16				# Se necesitan doce bytes (4 palabras)
	syscall						
	move $s1, $v0			# Almacenar esa direccion como el encabezado

	la $a0, askForCat		# solicita al usuario que ingrese una categoria
	li $v0, 4				# codigo syscall para imprimir cadena
	syscall					# print the prompt

	li $v0, 8				# codigo syscall para leer cadena
	syscall					# lee la cadena; ahora esta en $v0
	sw $v0, 0($s1)			# almacena la cadena en memoria, primer campo
	la $a0, askForObject	# solicita al usuario que ingrese un objeto
	li $v0, 4				# codigo syscall para imprimir cadena
	syscall					# imprime el mensaje

	li $v0, 8				# codigo syscall para leer una cadena
	syscall					# lee la cadena, ahora esta en $v0
	sw $v0, 4($s1)			# guarda el valor en memoria, segundo campo
	sw $0, 8($s1)			# next = nullptr para una nueva lista enlazada
	
	jr $ra					# retorna

	AlreadyExists:
	la $a0, alreadyExists	# carga la cadena para imprimir
	li $v0, 4				# codigo syscall para imprimir cadena
	syscall					# imprime el string
	jr $ra					# retorna




#======================================================================================#
#	                        Imprime el contenido de los nodos                   	   #
#======================================================================================#

Cat:

	beq $s1, $0, DisplayRequiresList	# funcionaria sin esto pero informa al usuario

	move $t0, $s1				        # actual = cabeza de lista enlazada

	DisplayLoop:
	beq $t0, $0, ReturnFromDisplay		# comprueba si estamos en un nodo nulo
	la $a0, nextNodeIs			        # carga "el siguiente nodo es: "
	li $v0, 4				            # codigo syscall para imprimir cadena
	syscall					            # imprime cadena
	
	li $v0, 4				            # codigo syscall para imprimir una cadena
	lw $a0, 0($t0)				        # carga el ID en $a0 para imprimir
	syscall					            # imprime ID
	
	li $v0, 4				            # codigo syscall para imprimir cadena
	la $a0, tab				            # carga tab en $a0 para imprimir
	syscall					            # imprime tab

	li $v0, 4				            # codigo syscall para imprimir la cadena
	lw $a0, 4($t0)				        # carga la cadena en $a0 para imprimir
	syscall					            # imprime el valor

	lw $t0, 8($t0)				        # actual= actual->siguiente
	j DisplayLoop				        # salta al loop

	ReturnFromDisplay:
	li $v0, 4				            # codigo syscall para imprimir cadena
	la $a0, newline			            # carga la nueva linea
	syscall					            # imprime nueva linea
	jr $ra					            # retorna

	DisplayRequiresList:
	la $a0, displayRequiresList		    # carga el mensaje para imprimir
	li $v0, 4				            # codigo syscall para imprimir cadena
	syscall					            # imprime
	jr $ra					            # retorna


#======================================================================================#
#		  Devuelve 1 si el ID proporcionado es único y  0 en caso contrario.           #
#======================================================================================#

IsUniqueID:

	move $t0, $s1				# current = head

	CheckNodes:
	beq $t0, $0, UniqueID	    # if current == nullptr, ID is unique
	lw $t1, 0($t0)				# current->ID
	beq $a0, $t1, NotUnique		# break
	lw $t0, 8($t0)				# else, current = current->next
	j CheckNodes				# loop

	UniqueID:
	li $v0, 1				# if we reach this, ID is unique
	jr $ra					# and return

	NotUnique:
	li $v0, 0				# false
	jr $ra					# return


#======================================================================================#
#	Adds a new node to the existing Linked List in sorted fashion (by value).      #
#======================================================================================#

Createobj:

	beq $s1, $0, AddingToNullHead		# reject insertion of a new node if head is nullptr	

	move $t0, $s1				# current = LinkedList.head
	
	la $a0, askForID			# prompt user to enter an ID
	li $v0, 4				# syscall code for printing string
	syscall					# print the prompt

	li $v0, 5				# syscall code for reading int
	syscall					# read the int (ID); it's now in $v0
	move $t1, $v0				# store the ID in $t1 for use later

	addi $sp, $sp, -12			# stack frame for three words
	sw $t0, 0($sp)				# store current Node
	sw $t1, 4($sp)				# store user's entered ID
	sw $ra, 8($sp)				# store return address
	move $a0, $t1				# load ID argument for function call
	jal IsUniqueID				# check if the ID is unique; answer in $v0 (1 = unique)

	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12

	beq $v0, $0, CreatingDuplicateNode	# not unique ID

	# Otherwise, unique ID

	la $a0, askForValue			# prompt user to enter a value
	li $v0, 4				# syscall code for printing string
	syscall					# print the prompt

	li $v0, 5				# syscall code for reading an int
	syscall					# read the int (value); it's now in $v0
	move $t2, $v0				# store the value in $t2 for use later

	li $t3, 0				# to be used as a "previous" Node tracker (Node before current, initially nullptr)

	FindLoop:

	beq $t0, $0, ExitAddNodeLoop		# if current == nullptr, exit loop
	lw $t4, 4($t0)				# t4 = current->value
	slt $t4, $t2, $t4			# record whether valueToStore (t2) < valueInCurrent (t4), and store in t4
	bne $t4, $0, ExitAddNodeLoop		# if t2 is in fact < t4, break

	# Anything below (but before ExitAddNodeLoop) runs when valueToStore (t2) >= valueInCurrent (t4)
	# Since we're storing nodes in ascending order by value, we need to move up one link in this case.
	
	move $t3, $t0				# previous = current
	lw $t0, 8($t0)				# current = current->next
	j FindLoop				# loop again

	ExitAddNodeLoop:
	
	li $v0, 9				# syscall code (9) for allocating memory (new Node)	
	li $a0, 12				# twelve bytes needed (3 words)
	syscall					# let there be light	
	
	sw $t1, 0($v0)				# newNode->id = $t1 (user-entered id from before)
	sw $t2, 4($v0)				# newNode->value = $t2 (user-entered value from before)	
	sw $t0, 8($v0)				# newNode->next = current (either nullptr or a valid Node)

	beq $t3, $0, PreviousWasNull		# if previous == nullptr, we're done w/ above	

	sw $v0, 8($t3)				# else, previous->next = newNode (insertion elsewhere in the list)
	jr $ra					# return to caller

	PreviousWasNull:

	# One last thing: we have to check if newNode is being entered before the head (it's the new head),
	# in which case we need to update $s1, the current head, to point to newNode. This happens
	# when previous == nullptr and valueToEnter < valueInCurrent. So now, we check if the 2nd condition
	# caused us to terminate from the 'while' loop above (the other termination condition was current == nullptr).

	bne $t4, $0, InsertionBeforeHead	# if newNode is the new head, update head
	j ReturnFromAddNode			# else, return to caller			

	InsertionBeforeHead:

	move $s1, $v0				# head = newNode
	jr $ra					# return to caller

	AddingToNullHead:

	la $a0, addingToNullHead		# load message
	li $v0, 4				# syscall code for printing string
	syscall					# print it
	jr $ra					# return to caller

	CreatingDuplicateNode:
	
	la $a0, nodeAlreadyExists		# load message
	li $v0, 4				# syscall code for printing string
	syscall					# print it
	jr $ra					# return to caller
	
#======================================================================================#
#	Removes the node with the given ID from this Linked List object.	       #
#======================================================================================#

DeleteNode:
	
	beq $s1, $0, NoNodesToDelete		# if head == nullptr, nothing to delete

	move $t0, $s1				# current = LinkedList->head

	la $a0, askForID			# prompt user to enter an ID
	li $v0, 4				# syscall code for printing string
	syscall					# print the prompt

	li $v0, 5				# syscall code for reading int
	syscall					# read the int (ID); it's now in $v0
	move $t1, $v0				# store the ID in $t1 for use later
	
	li $t2, 0				# previous = nullptr (to be used later in deleting)

	FindNodeToDelete:	

	beq $t0, $0, DeletionNodeNotFound	# if current == nullptr, return
	lw $t3, 0($t0)				# current->ID
	beq $t1, $t3, NodeFoundForDeletion	# else, branch if current->ID == $t1
	move $t2, $t0				# if it doesn't, previous = current
	lw $t0, 8($t0)				# if it doesn't, current = current->next
	j FindNodeToDelete			# and loop	

	NodeFoundForDeletion:
		
	beq $t2, $0, DeleteHead			# if previous == nullptr, then we're deleting the head
	
	# Otherwise, we're not deleting the head. In that case,
	# it doesn't matter what we're deleting; all we need to do
	# is reconnect the broken links. Consider [5]-[8]-[20] and a
	# request to delete [20]. Then [8]->next = [20]->next. Here,
	# [20]->next == nullptr. And so on.	

	# Memory leak here, courtesy of SPIM
	lw $t3, 8($t0)				# current->next
	sw $t3, 8($t2)				# previous->next = current->next
	jr $ra					# return

	DeleteHead:
	
	lw $t2, 8($t0)				# newHead = head->next (overwrite $t2, dont need it anymore)
	move $s1, $t2				# head = newHead (memory leak, yuck... thanks again, SPIM)
	jr $ra

	DeletionNodeNotFound:

	la $a0, nodeNotFound			# load message
	li $v0, 4				# syscall code for printing string
	syscall					# print it
	jr $ra					# return to caller

	NoNodesToDelete:

	la $a0, noNodesToDelete			# load message
	li $v0, 4				# syscall code for printing string
	syscall					# print it
	jr $ra					# and return

#======================================================================================#
#	Searches for a Node with the specified ID in this Linked List.		       #
#======================================================================================#

SearchID:

	beq $s1, $0, NoNodeIDToFind		# if head == nullptr

	move $t0, $s1				# current = head	

	la $a0, askForID			# prompt user to enter an ID
	li $v0, 4				# syscall code for printing string
	syscall					# print the prompt

	li $v0, 5				# syscall code for reading int
	syscall					# read the int (ID); it's now in $v0
	move $t1, $v0				# store the ID in $t1 for use later

	FindID:
	
	beq $t0, $0, NodeIDNotFound		# if current == nullptr, we reached the end w/o finding anything
	lw $t2, 0($t0)				# current->ID
	beq $t1, $t2, NodeIDFound		# found the node
	lw $t0, 8($t0)				# else, current = current->next
	j FindID

	NodeIDFound:

	la $a0, foundNode			# load message
	li $v0, 4				# syscall code for printing string
	syscall					# print it

	li $v0, 1				# syscall code for printing an int
	lw $a0, 0($t0)				# load the ID into $a0 for printing
	syscall					# print the ID
	
	li $v0, 4				# syscall code for printing a string
	la $a0, tab				# load the tab into $a0 for printing
	syscall					# print the tab

	li $v0, 1				# syscall code for printing an int
	lw $a0, 4($t0)				# load the value into $a0 for printing
	syscall					# print the value

	la $a0, newline				# load newline
	li $v0, 4				# syscall code for printing string
	syscall					# print the newline
	jr $ra					# return

	NodeIDNotFound:

	la $a0, nodeNotFound			# load message
	li $v0, 4				# syscall code for printing string
	syscall					# print it
	jr $ra					# return

	NoNodeIDToFind:
	
	la $a0, searchRequiresList		# load message
	li $v0, 4				# syscall code for printing string
	syscall					# print it
	jr $ra					# and return

#======================================================================================#
#	Searches for a Node with the specified value in this Linked List.	       #
#======================================================================================#

SearchValue:
	
	beq $s1, $0, NoNodeValToFind		# if head == nullptr

	move $t0, $s1				# current = head	

	la $a0, newline				# load newline
	li $v0, 4				# syscall code for printing string
	syscall					# print it
	syscall					# again

	la $a0, askForValue			# prompt user to enter an ID
	li $v0, 4				# syscall code for printing string
	syscall					# print the prompt

	li $v0, 5				# syscall code for reading int
	syscall					# read the int (val); it's now in $v0
	move $t1, $v0				# store the val in $t1 for use later
	li $t3, 0				# to be used as a flag variable later; see NodeValFound

	FindValue:
	
	beq $t0, $0, Done			# if current == nullptr, exit the loop
	lw $t2, 4($t0)				# current->value
	beq $t1, $t2, NodeValFound		# found the node
	lw $t0, 8($t0)				# if not a match, current = current->next
	j FindValue				# loop

	Done:
	beq $t3, $0, NodeValNotFound		# if the $t3 flag is zero, then we never found a node
	jr $ra					# otherwise, just return

	NodeValFound:

	li $t3, 1				# flag for found
	la $a0, foundNode			# load message
	li $v0, 4				# syscall code for printing string
	syscall					# print it

	li $v0, 1				# syscall code for printing an int
	lw $a0, 0($t0)				# load the ID into $a0 for printing
	syscall					# print the ID
	
	li $v0, 4				# syscall code for printing a string
	la $a0, tab				# load the tab into $a0 for printing
	syscall					# print the tab

	li $v0, 1				# syscall code for printing an int
	lw $a0, 4($t0)				# load the value into $a0 for printing
	syscall					# print the value

	la $a0, newline				# load newline
	li $v0, 4				# syscall code for printing string
	syscall					# print the newline
	lw $t0, 8($t0)				# get the next node
	j FindValue				# loop

	NodeValNotFound:

	la $a0, nodeNotFound			# load message
	li $v0, 4				# syscall code for printing string
	syscall					# print it
	jr $ra					# return

	NoNodeValToFind:
	
	la $a0, searchRequiresList		# carga mensaje
	li $v0, 4				        # codigo syscall para imprimir cadena
	syscall					        # imprime esto
	jr $ra					        # retorna
 
#======================================================================================#
#			                   Termina el programa	                                   #
#======================================================================================#

Exit:
	li $v0, 10
	syscall