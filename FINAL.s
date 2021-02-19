

.data

	pregunta: .asciiz "\nSeleccione su opcion:"
	crearcat: .asciiz "\n\tC para crear una lista."
	display: .asciiz "\n\tL para mostrar lista."
	agregarNodo: .asciiz "\n\tA para agregar un nodo."
	eliminar: .asciiz "\n\tD para eliminar un nodo."
	buscarID: .asciiz "\n\tS para buscar por ID."
	buscarValor: .asciiz "\n\tF para buscar por valor."
	terminar: .asciiz "\nOr X para finalizar: "
	preguntarID: .asciiz "\n\n\tingrese el ID: "
	preguntarValor: .asciiz "\tingrese el valor: "
	proximoNodo: .asciiz "\n\n\tel proximo nodo es (id, valor):\t"
	nodoEncontrado: .asciiz "\n\tnodo encontrado:\t"
	yaExiste: .asciiz "\n\n\tya existe una lista.\n"
	agregandoANull: .asciiz "\n\n\tnecesita crear categoria para ingresar un nodo. Mire las opciones 'C'.\n"
	displayNoList: .asciiz "\n\n\tnecesita crear categoria para imprimir un nodo. Mire las opciones 'C'.\n"
	busquedaNoList: .asciiz "\n\n\tnecesita crear categoria para buscar un nodo. Mire las opciones 'C'.\n"
	nodosNulos: .asciiz "\n\n\tnecesita crear categoria para poder eliminar un nodo. Mire las opciones 'C'.\n"
	nodoNoEncontrado: .asciiz "\n\n\tnodo no encontrado\n"
	nodoYaExiste: .asciiz "\n\tel nodo con el id ingresado ya existe en la lista\n"
	tab: .asciiz "\t"
	nuevalinea: .asciiz "\n"

.text

#======================================================================================#
#      Comienzo     #
#======================================================================================#

main:	li $s1, 0				# head = nullptr
	
loop:	jal ImprimirMenu				# Print pregunta y opciones
	jal PedirUsuarioMenu			# Pide al usuario que hacer	

	seq $t0, $v0, 'C'
	bne $t0, $zero, C
	seq $t0, $v0, 'L'
	bne $t0, $zero, L
	seq $t0, $v0, 'A'
	bne $t0, $zero, A
	seq $t0, $v0, 'D'
	bne $t0, $zero, D
	seq $t0, $v0, 'S'
	bne $t0, $zero, S
	seq $t0, $v0, 'F'
	bne $t0, $zero, F
	seq $t0, $v0, 'X'
	bne $t0, $zero, Exit
	j loop
	
	C:	jal CrearLista
		j loop
	L:	jal Display
		j loop
	A:	jal AgregarNodo
		j loop
	D:	jal EliminarNodo
		j loop
	S:	jal EncontrarID
		j loop
	F:	jal BuscarValor
		j loop


#======================================================================================#
#			Prints the menu options to the console.	          	       #
#======================================================================================#

ImprimirMenu:

	la $a0, pregunta				# load pregunta into $a0 for printing
	li $v0, 4				# syscall code for printing string
	syscall					# print the string in $a0
	la $a0, crearcat				# load next string
	syscall					# I'm lazy; the rest is straightforward
	la $a0, display				
	syscall
	la $a0, agregarNodo
	syscall
	la $a0, eliminar
	syscall
	la $a0, buscarID
	syscall
	la $a0, buscarValor
	syscall
	la $a0, terminar
	syscall
	jr $ra

#======================================================================================#
#	     pide opcion de menu.	                                 #
#======================================================================================#

PedirUsuarioMenu:

	li $v0, 12				# syscall code for reading a char
	syscall					# read the char (it's now in $v0)
	jr $ra					# return to caller with that value

#======================================================================================#
#	crea lista enlazada, devuelve direccion de la cabeza      #
#======================================================================================#

CrearLista:

	bne $s1, $0, AlreadyExists		# if head != nullptr, warn the user

	li $v0, 9				# sbrk
	li $a0, 12				# 12bytes 
	syscall					
	move $s1, $v0				# store that address as the head

	la $a0, preguntarID			# pregunta user to enter an ID
	li $v0, 4				# syscall code for printing string
	syscall					# print the pregunta

	li $v0, 5				# syscall code for reading int
	syscall					# read the int (ID); it's now in $v0
	sw $v0, 0($s1)				# store the ID in memory, 1st field

	la $a0, preguntarValor			# pregunta valor
	li $v0, 4				# syscall code for printing string
	syscall					# print the pregunta

	li $v0, 5				# syscall code for reading an int
	syscall					# read the int (value); it's now in $v0
	sw $v0, 4($s1)				# store the value in memory, 2nd field
	sw $0, 8($s1)				# next = nullptr for a new LinkedList
	
	jr $ra					# return to caller

	AlreadyExists:
	
	la $a0, yaExiste			# load string for printing
	li $v0, 4				# syscall code for printing string
	syscall					# print that string
	jr $ra					# and return
	

#======================================================================================#
#	    Prints the contents of the Nodes in this Linked List object.	       #
#======================================================================================#

Display:

	beq $s1, $0, ListarRequiereLista	# code would work without this, but best to inform user

	move $t0, $s1				# current = LinkedList.head

	DisplayLoop:
	beq $t0, $0, DevolverDisplay		# check if we're at a null ($0) node
	la $a0, proximoNodo			# load "The next node is: " string
	li $v0, 4				# syscall code for printing a string
	syscall					# print the string
	
	li $v0, 1				# syscall code for printing an int
	lw $a0, 0($t0)				# load the ID into $a0 for printing
	syscall					# print the ID
	
	li $v0, 4				# syscall code for printing a string
	la $a0, tab				# load the tab into $a0 for printing
	syscall					# print the tab

	li $v0, 1				# syscall code for printing an int
	lw $a0, 4($t0)				# load the value into $a0 for printing
	syscall					# print the value

	lw $t0, 8($t0)				# current = current->next
	j DisplayLoop				# jump to loop

	DevolverDisplay:
	li $v0, 4				# syscall code for printing string
	la $a0, nuevalinea				# load the nuevalinea
	syscall					# print the nuevalinea
	jr $ra					# return to caller

	ListarRequiereLista:
	la $a0, displayNoList		# load message for printing
	li $v0, 4				# syscall code for printing string
	syscall					# print it
	jr $ra					# return to caller


#======================================================================================#
#		Returns 1 if the given ID is unique and 0 otherwise.      	       #
#======================================================================================#

EsIdUnico:

	move $t0, $s1				# current = head

	CheckNodes:
	beq $t0, $0, UniqueID			# if current == nullptr, ID is unique
	lw $t1, 0($t0)				# current->ID
	beq $a0, $t1, NotUnique			# break
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

AgregarNodo:

	beq $s1, $0, AgregandoACabezaNula		# reject insertion of a new node if head is nullptr	

	move $t0, $s1				# current = LinkedList.head
	
	la $a0, preguntarID			# pregunta user to enter an ID
	li $v0, 4				# syscall code for printing string
	syscall					# print the pregunta

	li $v0, 5				# syscall code for reading int
	syscall					# read the int (ID); it's now in $v0
	move $t1, $v0				# store the ID in $t1 for use later

	addi $sp, $sp, -12			# stack frame for three words
	sw $t0, 0($sp)				# store current Node
	sw $t1, 4($sp)				# store user's entered ID
	sw $ra, 8($sp)				# store return address
	move $a0, $t1				# load ID argument for function call
	jal EsIdUnico				# check if the ID is unique; answer in $v0 (1 = unique)

	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12

	beq $v0, $0, CreandoNodoDuplicado	# not unique ID

	# Otherwise, unique ID

	la $a0, preguntarValor			# pregunta user to enter a value
	li $v0, 4				# syscall code for printing string
	syscall					# print the pregunta

	li $v0, 5				# syscall code for reading an int
	syscall					# read the int (value); it's now in $v0
	move $t2, $v0				# store the value in $t2 for use later

	li $t3, 0				# to be used as a "previous" Node tracker (Node before current, initially nullptr)

	EncontrarLoop:

	beq $t0, $0, SalirLoopAdicionNodo		# if current == nullptr, exit loop
	lw $t4, 4($t0)				# t4 = current->value
	slt $t4, $t2, $t4			# record whether valueToStore (t2) < valueInCurrent (t4), and store in t4
	bne $t4, $0, SalirLoopAdicionNodo		# if t2 is in fact < t4, break

	# Anything below (but before SalirLoopAdicionNodo) runs when valueToStore (t2) >= valueInCurrent (t4)
	# Since we're storing nodes in ascending order by value, we need to move up one link in this case.
	
	move $t3, $t0				# previous = current
	lw $t0, 8($t0)				# current = current->next
	j EncontrarLoop				# loop again

	SalirLoopAdicionNodo:
	
	li $v0, 9				# syscall code (9) for allocating memory (new Node)	
	li $a0, 12				# twelve bytes needed (3 words)
	syscall					# let there be light	
	
	sw $t1, 0($v0)				# newNode->id = $t1 (user-entered id from before)
	sw $t2, 4($v0)				# newNode->value = $t2 (user-entered value from before)	
	sw $t0, 8($v0)				# newNode->next = current (either nullptr or a valid Node)

	beq $t3, $0, AnteriorEraNulo		# if previous == nullptr, we're done w/ above	

	sw $v0, 8($t3)				# else, previous->next = newNode (insertion elsewhere in the list)
	jr $ra					# return to caller

	AnteriorEraNulo:

	# One last thing: we have to check if newNode is being entered before the head (it's the new head),
	# in which case we need to update $s1, the current head, to point to newNode. This happens
	# when previous == nullptr and valueToEnter < valueInCurrent. So now, we check if the 2nd condition
	# caused us to terminate from the 'while' loop above (the other termination condition was current == nullptr).

	bne $t4, $0, InsertarAntesCabeza	# if newNode is the new head, update head
	j ReturnFromAddNode			# else, return to caller			

	InsertarAntesCabeza:

	move $s1, $v0				# head = newNode
	jr $ra					# return to caller

	AgregandoACabezaNula:

	la $a0, agregandoANull		# load message
	li $v0, 4				# syscall code for printing string
	syscall					# print it
	jr $ra					# return to caller

	CreandoNodoDuplicado:
	
	la $a0, nodoYaExiste		# load message
	li $v0, 4				# syscall code for printing string
	syscall					# print it
	jr $ra					# return to caller
	
#======================================================================================#
#	Removes the node with the given ID from this Linked List object.	       #
#======================================================================================#

EliminarNodo:
	
	beq $s1, $0, SinNodosParaEliminar		# if head == nullptr, nothing to eliminar

	move $t0, $s1				# current = LinkedList->head

	la $a0, preguntarID			# pregunta user to enter an ID
	li $v0, 4				# syscall code for printing string
	syscall					# print the pregunta

	li $v0, 5				# syscall code for reading int
	syscall					# read the int (ID); it's now in $v0
	move $t1, $v0				# store the ID in $t1 for use later
	
	li $t2, 0				# previous = nullptr (to be used later in deleting)

	EncontrarEliminar:	

	beq $t0, $0, EliminarNoEncontrado	# if current == nullptr, return
	lw $t3, 0($t0)				# current->ID
	beq $t1, $t3, NodoEncontradoEliminar	# else, branch if current->ID == $t1
	move $t2, $t0				# if it doesn't, previous = current
	lw $t0, 8($t0)				# if it doesn't, current = current->next
	j EncontrarEliminar			# and loop	

	NodoEncontradoEliminar:
		
	beq $t2, $0, EliminarCabeza			# if previous == nullptr, then we're deleting the head
	
	# Otherwise, we're not deleting the head. In that case,
	# it doesn't matter what we're deleting; all we need to do
	# is reconnect the broken links. Consider [5]-[8]-[20] and a
	# request to eliminar [20]. Then [8]->next = [20]->next. Here,
	# [20]->next == nullptr. And so on.	

	# Memory leak here, courtesy of SPIM
	lw $t3, 8($t0)				# current->next
	sw $t3, 8($t2)				# previous->next = current->next
	jr $ra					# return

	EliminarCabeza:
	
	lw $t2, 8($t0)				# newHead = head->next (overwrite $t2, dont need it anymore)
	move $s1, $t2				# head = newHead (memory leak, yuck... thanks again, SPIM)
	jr $ra

	EliminarNoEncontrado:

	la $a0, nodoNoEncontrado			# load message
	li $v0, 4				# syscall code for printing string
	syscall					# print it
	jr $ra					# return to caller

	SinNodosParaEliminar:

	la $a0, nodosNulos			# load message
	li $v0, 4				# syscall code for printing string
	syscall					# print it
	jr $ra					# and return

#======================================================================================#
#	Searches for a Node with the specified ID in this Linked List.		       #
#======================================================================================#

EncontrarID:

	beq $s1, $0, NoHayID		# if head == nullptr

	move $t0, $s1				# current = head	

	la $a0, preguntarID			# pregunta user to enter an ID
	li $v0, 4				# syscall code for printing string
	syscall					# print the pregunta

	li $v0, 5				# syscall code for reading int
	syscall					# read the int (ID); it's now in $v0
	move $t1, $v0				# store the ID in $t1 for use later

	BuscarID:
	
	beq $t0, $0, IDNoEncontrado		# if current == nullptr, we reached the end w/o finding anything
	lw $t2, 0($t0)				# current->ID
	beq $t1, $t2, IDEncontrado		# found the node
	lw $t0, 8($t0)				# else, current = current->next
	j BuscarID

	IDEncontrado:

	la $a0, nodoEncontrado			# load message
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

	la $a0, nuevalinea				# load nuevalinea
	li $v0, 4				# syscall code for printing string
	syscall					# print the nuevalinea
	jr $ra					# return

	IDNoEncontrado:

	la $a0, nodoNoEncontrado			# load message
	li $v0, 4				# syscall code for printing string
	syscall					# print it
	jr $ra					# return

	NoHayID:
	
	la $a0, busquedaNoList		# load message
	li $v0, 4				# syscall code for printing string
	syscall					# print it
	jr $ra					# and return

#======================================================================================#
#	Searches for a Node with the specified value in this Linked List.	       #
#======================================================================================#

BuscarValor:
	
	beq $s1, $0, NoHayNodos		# if head == nullptr

	move $t0, $s1				# current = head	

	la $a0, nuevalinea				# load nuevalinea
	li $v0, 4				# syscall code for printing string
	syscall					# print it
	syscall					# again

	la $a0, preguntarValor			# pregunta user to enter an ID
	li $v0, 4				# syscall code for printing string
	syscall					# print the pregunta

	li $v0, 5				# syscall code for reading int
	syscall					# read the int (val); it's now in $v0
	move $t1, $v0				# store the val in $t1 for use later
	li $t3, 0				# to be used as a flag variable later; see ValorEncontrado

	FindValue:
	
	beq $t0, $0, Listo			# if current == nullptr, exit the loop
	lw $t2, 4($t0)				# current->value
	beq $t1, $t2, ValorEncontrado		# found the node
	lw $t0, 8($t0)				# if not a match, current = current->next
	j FindValue				# loop

	Listo:
	beq $t3, $0, ValorNoEncontrado		# if the $t3 flag is zero, then we never found a node
	jr $ra					# otherwise, just return

	ValorEncontrado:

	li $t3, 1				# flag for found
	la $a0, nodoEncontrado			# load message
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

	la $a0, nuevalinea				# load nuevalinea
	li $v0, 4				# syscall code for printing string
	syscall					# print the nuevalinea
	lw $t0, 8($t0)				# get the next node
	j FindValue				# loop

	ValorNoEncontrado:

	la $a0, nodoNoEncontrado			# load message
	li $v0, 4				# syscall code for printing string
	syscall					# print it
	jr $ra					# return

	NoHayNodos:
	
	la $a0, busquedaNoList		# load message
	li $v0, 4				# syscall code for printing string
	syscall					# print it
	jr $ra					# and return

#======================================================================================#
#			Termina el programa			                                               #
#======================================================================================#

Exit:
	li $v0, 10
	syscall