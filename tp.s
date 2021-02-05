         .data
cat:  .asciiz "Introduzca nombre de categoria:\n"   
obj:   .asciiz "Introduzca el nombre del objeto:\n"


slist:  .word 0  # inicializado a null    (puntero al primer nodo)                                  <- punteros     
cclist: .word 0  #                        (circular category list)(apunta a la lista de categorías)        <- punteros 
wclist:          #                        (working category list)(la lista en la cual estamos trabajando)         <- punteros 
prevcat:    # punteros o funciones?       
nextcat:


.text

# void newnode(int number)

newcat:
delcat: 
newobject: 
delobject:

               
#//////////////// CODIGO DEL PROFE  
#(hay que hacer multiples de estas para cada lista? seria una lista para las categorias q apunta a otra lista de cada item de la categoria...)
#ademas esta pensada para solo enlazar una vez. habria q buscar la forma de linkear el END al START         

# void newnode(int number) (((como le paso el argumento a $a0????)))
newnode:     move $t0, $a0       # preserva arg 1
             li $v0, 9           # 9 es sbrk (allocate heap memory)$v0 contains address of allocated memory  
             li $a0, 8           # $a0 = number of bytes to allocate / guarda 8 bytes ya q necesitamos 2 words, el dato y el puntero a siguiente
             syscall             # sbrk 8 bytes long
             sw $t0, ($v0)       # guarda el arg en new node  (guarda direccionm de $v0 ?)
             lw $t1, slist
             beq $t1, $0, first  # ? si la lista es vacia
             sw $t1, 4($v0)      # inserta new node por el frente
             sw $v0, slist       # actualiza la lista
             jr $ra              # jump to register -> return adress (retorna a la direccion de llamada a funcion)

             ## NO ME ESTA QUEDANDO CLARO CUANDO SE DEJAN LOS VALORES EN LUGARES DE MEMORIA PARA QUE NO SE PIERDAN! lito en el SW lo pasa a memoria


first:       sw $0, 4($v0)       # primer nodo inicializado a null
             sw $v0, slist       # apunta la lista a new node
             jr $ra


             .data 0x10001000
slist:       .word 0 # inicializado a null
numbers:     .word 1,2,3 # lista de enteros
             .text
main:        la $s0, numbers
             li $s1, 3
loop:        lw $a0, ($s0)
             jal newnode       #jump and link
             addi $s0, $s0, 4  #agrega 4 bytes para mover puntero (suposicion)
             addi $s1, $s1, -1
             bnez $s1, loop
             .end





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
