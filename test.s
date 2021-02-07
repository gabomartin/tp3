# void newnode(int number) (((como le paso el argumento a $a0????)))
newnode:     move $t0, $a0       # preserva arg 1
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


             .data 0x10001000
slist:       .word 0 # inicializado a null
numbers:     .word 1,2,3,4 # lista de enteros
             .text
main:        la $s0, numbers
             li $s1, 4
loop:        lw $a0, ($s0)
             jal newnode       #jump and link
             addi $s0, $s0, 4  #agrega 4 bytes para mover puntero (suposicion)
             addi $s1, $s1, -1
             bnez $s1, loop
             .end
