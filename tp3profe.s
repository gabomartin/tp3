         .data


options: .asciiz      "Elija la opcion a realizar y presione enter: 
                      \n 1 - Nueva categoria 
                      \n 2 - Nuevo objeto 
                      \n 3 - Siguiente nodo 
                      \n 4 - Nodo anterior
                      \n 5 - Eliminar nodo 
                      \n 6 - Listar categoria
                      \n 7 - Listar objetos   
                      \n "
emptyLine: .asciiz    "\n"
cat:  .asciiz "Introduzca nombre de categoria:\n"   
obj:   .asciiz "Introduzca el nombre del objeto:\n"


slist:  .word 0  # inicializado a null    (puntero al primer nodo)                                  <- punteros     
cclist: .word 0  #                        (circular category list)(apunta a la lista de categorías)        <- punteros 
wclist:          #                        (working category list)(la lista en la cual estamos trabajando)         <- punteros 
prevcat:    # punteros o funciones?       
nextcat:


          .text


main: 
start:      
      #Verifica si no hay ningun elemento
      beqz  $s7, noEle      
      #Si no es cero, hace 3 prints: 1) the current node is: 2) the string to the curr  3) a new line
      la    $a0, currentIs # 1)
      jal   consolePrint
      move  $a0, $a3    # 2)
      jal   consolePrint
      la    $a0, emptyLine #3)
      jal   consolePrint
      
#----------------------------------------------------
# Start with showing the options to the users and let users choose what to do next
#----------------------------------------------------
optionMenu:
      # use print string syscall (to console) to show menu and prompt for input
      la    $a0, options
      jal   consolePrint
      
      # use read character syscall (from console) to get response.
      li    $v0, 5
      syscall
      
      # move response to the temporary register $t0
      move  $t0, $v0

#----------------------------------------------------
# Choose what to do based on user choice 
#----------------------------------------------------
      beq         $t0, 1, insertCat
      beq         $t0, 2, insertObjt
      beq         $t0, 3, next
      beq         $t0, 4, previous  
      beq         $t0, 5, del
      beq         $t0, 6, listCat
      beq         $t0, 7, listObj
      beq         $t0, 8, exit
      
      
#----------------------------------------------------
# Syscall to exit the program 
#---------------------------------------------------- 
exit:
      li    $v0, 17
      syscall

               
#//////////////// CODIGO DEL PROFE  
#(hay que hacer multiples de estas para cada lista? seria una lista para las categorias q apunta a otra lista de cada item de la categoria...)
#ademas esta pensada para solo enlazar una vez. habria q buscar la forma de linkear el END al START         

# void newnode(int number) (((como le paso el argumento a $a0????)))
insertCat:   move $t0, $a0       # preserva arg 1
             li $v0, 9           # 9 es sbrk (allocate heap memory)$v0 contains address of allocated memory  
             li $a0, 8           # $a0 = number of bytes to allocate / guarda 8 bytes ya q necesitamos 2 words, el dato y el puntero a siguiente
             syscall             # sbrk 8 bytes long
             sw $t0, ($v0)       # guarda el arg en new node  (guarda direccionm de $v0 ?) 
             lw $t1, slist       # ¿POR que este paso? Si slist es NULL en este momento. Le estaria pasando el null al $t1. Por que se comparara para ver si es el primero
             beq $t1, $0, first  # ? si la lista es vacia. si t1 es 0 seria el primero entonces saltamos a First
             sw $t1, 4($v0)      # inserta new node por el frente
             sw $v0, slist       # actualiza la lista
             jr $ra              # jump to register -> return adress (retorna a la direccion de llamada a funcion)

             ## NO ME ESTA QUEDANDO CLARO CUANDO SE DEJAN LOS VALORES EN LUGARES DE MEMORIA PARA QUE NO SE PIERDAN! lito en el SW lo pasa a memoria(asignado por so)


first:       sw $0, 4($v0)       # primer nodo inicializado a null
             sw $v0, slist       # apunta la lista a new node       
             jr $ra


insertObj:

#syscall to print something
consolePrint:
	li	$v0, 4
	syscall
	jr	$ra



#smalloc:
#             lw $t0, slist
#             beqz $t0, sbrk
#             move $v0, $t0
#             lw $t0, 12($t0)
#             sw $t0, slist
#             jr $ra


#sbrk:
#             li $a0, 16          # node size fixed 4 words
#             li $v0, 9
#             syscall             # return node address in v0
#             jr $ra
#

#sfree:
#             la $t0, slist
#             sw $t0, 12($a0)
#             sw $a0, slist       # $a0 node address in unused list
#             jr $ra