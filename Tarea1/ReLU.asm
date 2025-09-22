#Nombre: Brandon Jiménez Campos, Carné: C33972, Grupo 01 del curso Estructuras de Computadores Digitales
#Este código lo que realiza es que a través de un array, reemplaza los números negativos del array por ceros

.data
array: .word -5, 4, -3, -2, 1, 0, -1, 2, 3, -4
lenA: .word 10
separator:  .asciiz", "
newLine: .asciiz"\n"
original: .asciiz "\nArreglo original: "
arreglado: .asciiz "\nArreglo modificado: "

.text
main:
	addi $v0, $0, 4			#Imprimir un mensaje
	la $a0, original 			#Cargar la dirección
	syscall	
	
 	la $s0, array 				#Leer y cargar el arreglo 
 	lw $a1, lenA 				#Se carga el número de elementos del arreglo
 	jal funcReLU				#Se llama la función 
 	
 	addi $v0,$0, 10				#prepara al simulador para parar
 	syscall 					#simulador se detiene
 
 funcReLU:
 	addi $sp, $sp, -16 				#reservar espacio en la pila
 	sw $ra, 12($sp) 				#se guarda la dirección de retorno (para volver al main)
 	sw $s0,  8($sp) 				#se guarda la dirección del arreglo
 	sw $a1, 4($sp) 				#se guarda la dirección de la longitud del arreglo
 	add $t2, $a1, $0				#valor de la longitud del array 
 	
 	jal printArray 				#se va a la función para imprimir el arreglo original
 	
 	addi $v0, $0, 4				#Imprimir un mensaje
	la $a0, arreglado 				#Cargar la dirección
	syscall
	jal app_ReLU
	
	lw $s0, 8($sp) 				#se restaura el parámetro de la dirección del arreglo ya con el ReLU aplicado 
	lw $a1, 4($sp)				#se restaura el parámetro de la longitud del arreglo ya con el ReLU aplicado
	
	jal printArray					#se imprime el nuevo arreglo
	
	lw $ra, 12($sp)
	addi $sp, $sp, 16
	jr $ra 						#se vuelve al main
 	
 printArray:
	add $t0, $0, $0 				#i=0
	add $t1, $s0, $0				#direccion del array
	

	loopP:
		sll $t3, $t0, 2 				#i*4
		addu $t3, $t1, $t3			#$t3=dir(A+i*4)= dir (A[i])
		

		addi $v0, $0, 1			#Código 1: imprimir un entero
		lw $a0, 0($t3)			#Carga el valor de A[i] en $a0, para imprimir
		syscall					#Imprime el entero
						
		addi $t0, $t0, 1			#i++
		slt $t4, $t0, $t2  			#$t3=1 si i < lenA
		beq $t4, $0, printEnd
					

		addi $v0, $0, 4			#Código 4, imprime el string
		la $a0, separator			#Carga la dirección del separador
		syscall					#imprimir el separador

		j loopP					#volver al inicio del bucle

	printEnd:
		addi $v0, $0, 4			#Código 4: imprimir string
		la $a0, newLine			#Carga dirección de salto de línea
		syscall					#Imprime salto de línea
		jr $ra					#retorna a la función llamante
 	
 
 app_ReLU:
 	add $t0, $0, $0				#i=0
 	while: 
 		sll $t1, $t0, 2 				#i*4
 		add $t3, $s0, $t1 			#$t3=dir(A[i])
 		lw $t4, 0($t3)				#$t4 = A[i]
 		slt $t5, $t0, $t2			#$t5 = 1 si i < lenA
 		beq $t5, $0, endwhile  		#si $t5 = 0 se sale del while
 		slt $t6, $t4, $0			#$t6 = 1, si A[i] < 0
 		beq $t6, $0, endif 			#si $t6 = 0 salte al final del if
 		add $t4, $0, $0			#A[i] = 0
 		sw $t4, 0($t3)			#Actualizar el valor de A[i]
 		
 	endif:
 		addi $t0, $t0, 1 			#i++
 		j while
 	endwhile:
 		jr $ra	