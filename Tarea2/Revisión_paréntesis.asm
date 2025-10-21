# ============================================================
# Universidad de Costa Rica
# Estructuras de Computadores Digitales I 
# Estudiante: Brandon Jiménez Campos
# Carné: C33972
# Grupo: 1
# Tarea 2
# ------------------------------------------------------------
# Descripción:
# Este programa revisa si el string suministrado utiliza correctamente los paréntesis (cualquier tipo) y a través de la salida $v0 da la respuesta de si es
# utilizado correctamente o no lo es, si $v0=1 sí utiliza los paréntesis correctamente, si $v0=0, están mal empleados, además de que se imprime en la
# terminal si están bien empleados o no lo están.
# ============================================================

.data
linea:.asciiz "----------------------------------------------------------------------------------------------------------------------------\n"
encabezado:.asciiz "Prueba     | Resultado\n"
newLine:.asciiz "\n"
separador:.asciiz "   |   "
msj_valido:.asciiz "paréntesis válidos"
msj_invalido:.asciiz "paréntesis inválidos"

prueba0:.asciiz " "
prueba1:.asciiz "()"
prueba2:.asciiz "(){}{{{()}}()}"
prueba3:.asciiz "(hay [varios {niveles} de] parentesis)"
prueba4:.asciiz "(se cierra con un tipo {diferente}]"
prueba5:.asciiz "{este deja (un nivel abierto)!"
prueba6:.asciiz "este, por otro lado, cierra dos veces sin abrir])"
prueba7:.asciiz "[{este cierra en un orden incorrecto]}"

.text
main:
    # Escribir el encabezado 
    la $a0, linea
    addi $v0, $zero, 4
    syscall

    la $a0, encabezado
    addi $v0, $zero, 4
    syscall

    la $a0, linea
    addi $v0, $zero, 4
    syscall

    # Realizar pruebas 
    la $a0, prueba0 
    jal imprimir
    la $a0, prueba1
    jal imprimir
    la $a0, prueba2
    jal imprimir
    la $a0, prueba3
    jal imprimir
    la $a0, prueba4
    jal imprimir
    la $a0, prueba5
    jal imprimir
    la $a0, prueba6
    jal imprimir
    la $a0, prueba7
    jal imprimir

    # Terminar la tabla
    la $a0, linea
    addi $v0, $zero, 4
    syscall
    
    # Terminar el programa
    addi $v0, $zero, 10
    syscall

imprimir:
    # Reserva espacio en pila y guarda registros
    addi $sp, $sp, -8
    sw $a0, 4($sp)
    sw $ra, 0($sp)
    
    add $s0, $a0, $zero # Imprime el string que hace de prueba
    addi $v0, $zero, 4
    syscall
    
    la $a0, separador #imprimir el separador
    addi $v0, $zero, 4
    syscall
 
    add $a0, $s0, $zero #asigna el string a $a0 para enviarlo a la función de verificar
    jal verificar_parentesis
    
    beq $v0, $zero, imprimir_invalido
    
imprimir_valido:
    la $a0, msj_valido #cargar el string de parentesis validos en $a0
    j imprimir_resp

imprimir_invalido:
    la $a0, msj_invalido #cargar el string de parentesis invalidos en $a0

imprimir_resp:
    addi $v0, $zero, 4 # imprimir string
    syscall

    # Imprime salto de línea
    la $a0, newLine
    addi $v0, $zero, 4
    syscall
  
    lw $s1, 12($sp) #se retoma el valor de $s1
    lw $s0, 8($sp)
    lw $a0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 16 #se libera la memoria
    jr $ra

verificar_parentesis:
    addi $sp, $sp, -4      
    sw $ra, 0($sp)
    
    add $t3, $a0, $zero  # $t3 = string de la prueba 
    add $t4, $sp, $zero # $t4 = puntero de pila 
    
revisar_loop:
    lb $t0, 0($t3)  # se carga el bit actual
    addi $t1, $zero, 0 # $t1=0
    beq $t0, $t1, fin_string # si $t0=0 significa que está en null
    
    addi $t1, $zero, 40 # $t1 = (
    beq $t0, $t1, meter_a_pila 
    addi $t1, $zero, 91 # $t1 = [ 
    beq $t0, $t1, meter_a_pila  
    addi $t1, $zero, 123 # $t1 = {
    beq $t0, $t1, meter_a_pila
    
    addi $t1, $zero, 41 # $t1 = )
    beq $t0, $t1, verificar_cierre
    addi $t1, $zero, 93 # $t1 = ]
    beq $t0, $t1, verificar_cierre
    addi $t1, $zero, 125 # $t1 = }
    beq $t0, $t1, verificar_cierre
    # si no detecta ningún tipo de paréntesis continua al siguiente caracter
    j siguiente

meter_a_pila:
    addi $t4, $t4, -4 # se mueve 4 espacio antes para poder guardar el paréntesis
    sw $t0, 0($t4) # se guarda el paréntesis inicial
    j siguiente

verificar_cierre:
    beq $t4, $sp, invalido # si la pila está vacía irse a inválido
    lw $t2, 0($t4) # $t2 ahora es el último paréntesis abierto
    addi $t4, $t4, 4 # se elimina el paréntesis de la pila
    
    addi $t1, $zero, 41 # $t1 = )
    bne $t0, $t1, check_corchete #verificar si es " ) ", sino irse a revisar si es " ] "
    addi $t1, $zero, 40 # $t1= (
    bne $t2, $t1, invalido  # si el último paréntesis abierto no es " ( " irse a inválido 
    j siguiente
    
check_corchete:
    addi $t1, $zero, 93 # $t1 = ]
    bne $t0, $t1, check_llave  # si no es " ] ", irse a " } "
    addi $t1, $zero, 91 # $t1 = [
    bne $t2, $t1, invalido  # si el último paréntesis abierto no es " [ ", irse a inválido.
    j siguiente
    
check_llave:
    addi $t1, $zero, 123 # t1 = {
    bne $t2, $t1, invalido # si el último paréntesis abierto no es " { ", irse a inválido

siguiente:
    addi $t3, $t3, 1 #siguiente prueba
    j revisar_loop

fin_string:
    bne $t4, $sp, invalido  # si la pila no está vacía irse a inválido
    addi $v0, $zero, 1 # $v0 = 1 
    j terminar

invalido:
    addi $v0, $zero, 0 # $v0 = 0

terminar:
    lw $ra, 0($sp)
    addi $sp, $sp, 4 #devolver el espacio de la pila
    jr $ra
