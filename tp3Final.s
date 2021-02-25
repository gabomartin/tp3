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


#                                     Comienzo                                         #


main:	li $s1, 0				        # head = nullptr
	
loop:	jal ImprimirMenu		        # Print pregunta y opciones
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



#			                  Imprime el menu de opciones	          	               #


ImprimirMenu:

	la $a0, pregunta		# carga pregunta en $a0 para imprimir
	li $v0, 4				# codigo syscall para imprimir cadena
	syscall					# imprime cadena en $a0
	la $a0, crearcat	    # Asi sucesivamente hasta jr $ra
	syscall					
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


#	                             Pide opcion de menu	                               #


PedirUsuarioMenu:

	li $v0, 12				# codigo syscall para leer un caracter
	syscall					# lee el caracter
	jr $ra					# retorna a la llamada con el valor


#	             Crea lista enlazada, devuelve direccion de la cabeza                  #


CrearLista:

	bne $s1, $0, AlreadyExists		# Si head != null, indica que ya existe

	li $v0, 9				        # sbrk
	li $a0, 12				        # 12bytes 
	syscall					
	move $s1, $v0			        # guarda la direccion como el encabezado

	la $a0, preguntarID		        # pregunta al usuario que ingrese el ID
	li $v0, 4				
	syscall					

	li $v0, 5				        # codigo syscall para leer entero
	syscall					        # lee el INT (ID); Ahora esta en $v0
	sw $v0, 0($s1)			        # guarda ID en memoria, 1er campo

	la $a0, preguntarValor	        # pregunta valor
	li $v0, 4				
	syscall					

	li $v0, 5				        # codigo syscall para leer entero
	syscall					        # lee el INT (ID); Ahora esta en $v0
	sw $v0, 4($s1)			        # guarda ID en memoria, 1er campo
	sw $0, 8($s1)			        # next = nullptr 
	
	jr $ra					        # retorna a la llamada

	AlreadyExists:
	
	la $a0, yaExiste		        # Carga la cadena para imprimir
	li $v0, 4				
	syscall					
	jr $ra					        # retorna
	

#======================================================================================#
#	                     Imprime el contenido de los nodos                  	       #
#======================================================================================#

Display:

	beq $s1, $0, ListarRequiereLista	

	move $t0, $s1				        # actual = head

	DisplayLoop:
	beq $t0, $0, DevolverDisplay		# Verifica si estamos en un nodo nulo
	la $a0, proximoNodo			        # carga el siguiente nodo es: 
	li $v0, 4				
	syscall					
	
	li $v0, 1				    # codigo syscall para imprimir entero
	lw $a0, 0($t0)				
	syscall					
	
	li $v0, 4				    # codigo syscall para imprimir cadena
	la $a0, tab				
	syscall					

	li $v0, 1				    # codigo syscall para imprimir INT
	lw $a0, 4($t0)				
	syscall					

	lw $t0, 8($t0)				# actual = actual -> siguiente
	j DisplayLoop				# salta al loop

	DevolverDisplay:
	li $v0, 4				    # codigo syscall para imprimir cadena
	la $a0, nuevalinea			# carga nuevalinea
	syscall					
	jr $ra					    # retorna

	ListarRequiereLista:
	la $a0, displayNoList		# carga mensaje para imprimir
	li $v0, 4				
	syscall					
	jr $ra					    # retorna 




#	                 Agrega nuevos nodos a la lista de manera ordenada                 #


AgregarNodo:

	beq $s1, $0, AgregandoACabezaNula		# rechaza la insercion de un nuevo nodo si head = nullptr	

	move $t0, $s1				            # actual = head 
	
	la $a0, preguntarID			            # pregunta al usuario que ingrese ID
	li $v0, 4				                # codigo syscall para imprimir cadena
	syscall					                # imprime pregunta

	li $v0, 5				    # codigo syscall para leer entero
	syscall					    
	move $t1, $v0				# guarda el ID en $t1 para usarlo luego

	addi $sp, $sp, -12			# stack frame de tres palabras
	sw $t0, 0($sp)				# guarda en el nodo actual
	sw $t1, 4($sp)				# guarda el ID ingresado por el usuario
	sw $ra, 8($sp)				# guarda la direccion de retorno
	move $a0, $t1				# mueve el ID para llamar a la funcion
	jal EsIdUnico				# comprueba si el ID es unico; pregunta en $v0, si es 1 = unico

	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12

	beq $v0, $0, CreandoNodoDuplicado	# no es ID unico, de lo contrario si

	

	la $a0, preguntarValor			    # pregunta al usuario que ingrese un valor
	li $v0, 4				        
	syscall					        

	li $v0, 5				# codigo syscall para leer entero
	syscall					
	move $t2, $v0			# guarda el valor en $t2 para usarlo luego

	li $t3, 0				# utilizado para buscar el nodo anterior

	EncontrarLoop:

	beq $t0, $0, SalirLoopAdicionNodo		# si actual == nullptr, salir del loop
	lw $t4, 4($t0)				            # t4 = actual -> valor
	slt $t4, $t2, $t4			            # registra si el valor para guardar (t2) < valor actual (t4), guarda en t4
	bne $t4, $0, SalirLoopAdicionNodo		# si t2 es < t4, sale

	# Estamos almacenando los nodos ascendentes por valor.
	
	move $t3, $t0				        # anterior = actual
	lw $t0, 8($t0)				        # actual = actual -> siguiente
	j EncontrarLoop				        # loop

	SalirLoopAdicionNodo:
	
	li $v0, 9				            # codigo syscall para asignar memoria (nuevo nodo)
	li $a0, 12				            # 12 bytes (3 words)
	syscall						
	
	sw $t1, 0($v0)				        # nuevoNodo->id = $t1 (ingresado por el usuario desde antes)
	sw $t2, 4($v0)				        # nuevoNodo->valor = $t2 (ingresado por el usuario desde antes)	
	sw $t0, 8($v0)				        # nuevoNodo->siguiente = actual 

	beq $t3, $0, AnteriorEraNulo		# Si anterior == nullptr, terminamos con el anterior

	sw $v0, 8($t3)				        # anterior->siguiente = newNode (insercion en otra parte de la lista)
	jr $ra					            # retorna a la llamada

	AnteriorEraNulo:

	bne $t4, $0, InsertarAntesCabeza	# Si nuevoNodo es el nuevo encabezado, actualiza el encabezado
	j ReturnFromAddNode			        # retorna a la llamada			

	InsertarAntesCabeza:

	move $s1, $v0				# head = nuevoNodo
	jr $ra					    # retorna a llamada

	AgregandoACabezaNula:

	la $a0, agregandoANull		# carga el mensaje y lo imprime
	li $v0, 4				    
	syscall					    
	jr $ra					    

	CreandoNodoDuplicado:
	
	la $a0, nodoYaExiste		# carga el mensaje y lo imprime
	li $v0, 4				
	syscall					
	jr $ra					


#	    	Devuelve 1 si el ID es unico, de lo contrario devuelve 0         	       #


EsIdUnico:

	move $t0, $s1				# actual = head

	CheckNodes:
	beq $t0, $0, IDunico		# si el actual == nullptr, el ID es unico
	lw $t1, 0($t0)				# actual -> ID
	beq $a0, $t1, NoEsUnico		# break
	lw $t0, 8($t0)				# actual = actual->siguiente
	j CheckNodes				# loop

	IDunico:
	li $v0, 1				
	jr $ra					

	NoEsUnico:
	li $v0, 0				# falso
	jr $ra					# retorna

	

#	                            Elimina el nodo con el ID	                           #


EliminarNodo:
	
	beq $s1, $0, SinNodosParaEliminar		# Si head == nullptr, nada para eliminar

	move $t0, $s1				            # actual = head

	la $a0, preguntarID			            # pregunta al usuario para que ingrese ID
	li $v0, 4				                
	syscall					                

	li $v0, 5				                # codigo syscall para leer entero
	syscall					                
	move $t1, $v0				            # guarda el ID en $t1 para usarlo despues
	
	li $t2, 0				                # anterior = nullptr (para usarlo despues en la eliminacion)

	EncontrarEliminar:	

	beq $t0, $0, EliminarNoEncontrado	    # Si actual == nullptr, retorna
	lw $t3, 0($t0)				            # actual->ID
	beq $t1, $t3, NodoEncontradoEliminar	# si no, si actual->ID == $t1
	move $t2, $t0				            # si no, anterior = actual
	lw $t0, 8($t0)				            # si no, actual = actual -> siguente
	j EncontrarEliminar			            # salta loop	

	NodoEncontradoEliminar:
		
	beq $t2, $0, EliminarCabeza			    # Si el anterior == nullptr, entonces estamos eliminando el head
		

	# Se nos fuga memoria

	lw $t3, 8($t0)				# actual -> siguiente
	sw $t3, 8($t2)				# anterior -> siguiente = actual -> siguiente
	jr $ra					    # retorna

	EliminarCabeza:
	
	lw $t2, 8($t0)				# nuevoHead = head -> siguiente (escribe sobre $t2 porque ya no lo necesito)
	move $s1, $t2				# head = nuevoHead  
	jr $ra

	EliminarNoEncontrado:

	la $a0, nodoNoEncontrado	# carga mensaje
	li $v0, 4				    
	syscall					    
	jr $ra					    # retorna

	SinNodosParaEliminar:

	la $a0, nodosNulos			# carga mensaje
	li $v0, 4				    
	syscall					    
	jr $ra					    # retorna


#	                        Busca un nodo con el ID especificado	                   #


EncontrarID:

	beq $s1, $0, NoHayID		# Si head == nullptr

	move $t0, $s1				# actual = head	

	la $a0, preguntarID			# pregunta user to enter an ID
	li $v0, 4				    
	syscall					   

	li $v0, 5				    # codigo syscall para leer entero
	syscall					    
	move $t1, $v0				# guarda el ID $t1 para usarlo luego

	BuscarID:
	
	beq $t0, $0, IDNoEncontrado		# si actual == nullptr, llegamos al final y no encontramos nada
	lw $t2, 0($t0)				    # actual -> ID
	beq $t1, $t2, IDEncontrado		# encontro el nodo
	lw $t0, 8($t0)				    # actual = actual -> siguiente
	j BuscarID

	IDEncontrado:

	la $a0, nodoEncontrado			# Carga mensaje
	li $v0, 4				        
	syscall					        

	li $v0, 1				        # Codigo syscall para imprimir entero
	lw $a0, 0($t0)				    
	syscall					        
	
	li $v0, 4				        # codigo syscall para imprimir cadena
	la $a0, tab				        
	syscall					        

	li $v0, 1				        # codigo syscall para imprimir un entero
	lw $a0, 4($t0)				    
	syscall					        

	la $a0, nuevalinea				# carga nuevalinea
	li $v0, 4				        
	syscall					        
	jr $ra					        # retorna

	IDNoEncontrado:

	la $a0, nodoNoEncontrado		# carga mensaje
	li $v0, 4				        
	syscall					        
	jr $ra					        # retorna

	NoHayID:
	
	la $a0, busquedaNoList		    # carga mensaje
	li $v0, 4				        
	syscall					        
	jr $ra					        # retorna


#	                       Busca nodos con un valor especifico              	       #


BuscarValor:
	
	beq $s1, $0, NoHayNodos		# Si head == nullptr

	move $t0, $s1				# actual = head	

	la $a0, nuevalinea			# carga nuevalinea
	li $v0, 4				    
	syscall					    # imprimo
	syscall					    # Imprimo de nuevo

	la $a0, preguntarValor		# pregunta al usuario que ingrese el valor
	li $v0, 4				    
	syscall					    

	li $v0, 5				    # codigo syscall para leer entero
	syscall					    
	move $t1, $v0				# guarda el valor en $t1 para usarlo luego
	li $t3, 0				    # luego va a ser usado como bandera 

	busVal:
	
	beq $t0, $0, Listo			        # Si actual == nullptr, sale del loop
	lw $t2, 4($t0)				        # actual -> valor
	beq $t1, $t2, ValorEncontrado		# encontro el nodo
	lw $t0, 8($t0)				        # si no, actual = actual -> siguiente
	j busVal				            # loop

	Listo:
	beq $t3, $0, ValorNoEncontrado		# si la bandera $t3 es 0, nunca encontramos un nodo
	jr $ra					            # si no, retorna

	ValorEncontrado:

	li $t3, 1				# bandera de encontrado
	la $a0, nodoEncontrado	# carga mensaje
	li $v0, 4				# codigo syscall para imprimir cadena
	syscall					

	li $v0, 1				# codigo syscall para imprimir entero
	lw $a0, 0($t0)			# carga el ID en $a0 para imprimir
	syscall					
	
	li $v0, 4				# codigo syscall para imprimir cadena
	la $a0, tab				# carga tab en $a0 para imprimir
	syscall					

	li $v0, 1				# codigo syscall para imprimir entero
	lw $a0, 4($t0)			
	syscall					

	la $a0, nuevalinea		# carga nuevalinea
	li $v0, 4				
	syscall					
	lw $t0, 8($t0)			# carga el siguiente nodo
	j busVal				# vuelve al loop

	ValorNoEncontrado:

	la $a0, nodoNoEncontrado	# carga mensaje
	li $v0, 4				    
	syscall					    
	jr $ra					    # retorna

	NoHayNodos:
	
	la $a0, busquedaNoList	    # carga mensaje
	li $v0, 4				    
	syscall					    
	jr $ra					    # retorna



#			                        Termina el programa			                       #


Exit:
	li $v0, 10
	syscall