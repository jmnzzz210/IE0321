# ============================================================
# Universidad de Costa Rica
# Estructuras de Computadores Digitales I 
# Estudiante: Brandon Jiménez Campos
# Carné: C33972
# Grupo: 1
# Tarea 3
# --------------------------------------------------------------------------------------------------------------------------------
# Descripción:
# A través de este programa se puede calcular el promedio de un array, el cual contiene
# solamente números positivos y cuando se encuentre un número negativo indica que se ha 
# llegado al final del array, en las salidas de la función se pueden encontrar $v0 la parte entera
# del promedio y en $v1 el residuo del mismo, además contiene la ayuda de que si la suma no 
# se puede realizar devuelve -1 la función en ambas salidas
# ============================================================

.data
	array:.asciiz"Array: "
	promedio: .asciiz"Parte entera del promedio: "
	residuo:.asciiz"Residuo del mismo: "
	nueva_linea:.asciiz"\n"
	error:.asciiz"No se pudo obtener promedio (overflow)"
	espacio:.asciiz " "
	coma:.asciiz ","

	array0:.word 1 2 3 4 5 6 7 8 -1
	array1:.word 77 77 77 77 77 77 -77
	array2:.word 2 2 2 4 4 4 -1
	array3:.word 0x7FFFFFFF 1 2 -1 #se utiliza el máximo positivo para generar overflow
	array4:.word  -1
	array5:.word 0 0 0 -1
	array6:.word 77 100 -1

.text 
main:
 	# cargar el array que se va a utilizar
 	la $a0, array0
 	jal imprimir
 	
 	la $a0, array1
 	jal imprimir
 	
 	la $a0, array2
 	jal imprimir
 	
 	la $a0, array3
 	jal imprimir
 	
 	la $a0, array4
 	jal imprimir
 	
 	la $a0, array5
 	jal imprimir
 	
 	la $a0, array6
 	jal imprimir
 	
 	addi $v0, $zero, 10
    	syscall
 	
 imprimir:
 	# Reservar espacios en la pila
 	addi $sp, $sp, -8
 	sw $ra, 0($sp)
 	sw $a0, 4($sp)
 	
 	# imprimir la palabra array
 	la $a0, array
 	addi $v0, $zero, 4
 	syscall
 	
 	# imprimir el array a utilizar
 	lw $a0, 4($sp)
 	jal imprimir_arr
 	
 	#irse a la función para calcular el promedio
 	lw $a0, 4($sp)
 	jal promedio_func
 	addi $t1, $v0, 0 # guardar la parte entera del promedio en t1
 	addi $t2, $v1, 0 # guardar el residuo del promedio
 	
 	#imprimir salto de línea
 	la $a0, nueva_linea
 	addi $v0, $zero, 4
 	syscall
 	
 	# verificar que el resultado devuelto por la función no sea error
 	slt $t3, $t1, $zero # $t3 = 1, si el valor devuelto por la función de promedio es negativo
 	bne $t3, $0, impr_error
 	
 	# imprimir el promedio 
	la $a0, promedio
	addi $v0, $zero, 4
	syscall
	
	# imprimir el número devuelto por la funcion
	addi $a0, $t1, 0
	addi $v0, $zero, 1 
	syscall
	
	#imprimir salto de línea
 	la $a0, nueva_linea
 	addi $v0, $zero, 4
 	syscall
 	
 	# imprimir el residuo
	la $a0, residuo
	addi $v0, $zero, 4
	syscall
	
	#imprimir residuo devuelto por la funcion
	addi $a0, $t2, 0
	addi $v0, $zero, 1
	syscall
	
	#imprimir salto de línea
 	la $a0, nueva_linea
 	addi $v0, $zero, 4
 	syscall
 	j fin

 impr_error:
 	# imprimir el promedio 
	la $a0, promedio
	addi $v0, $zero, 4
	syscall
	
	# imprimir error
	la $a0, error
	addi $v0, $zero, 4
	syscall
	
	#imprimir salto de línea
 	la $a0, nueva_linea
 	addi $v0, $zero, 4
 	syscall
 	
 	# imprimir el residuo
	la $a0, residuo
	addi $v0, $zero, 4
	syscall
	
	#imprimir error
	la $a0, error
	addi $v0, $zero, 4
	syscall
	
	#imprimir salto de línea
 	la $a0, nueva_linea
 	addi $v0, $zero, 4
 	syscall
 	
fin:
	# Devolver los espacios reservados de la pila
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	jr $ra
	
imprimir_arr:
 	addi $t0, $a0, 0 # $t0 = Dir_array
	imprimir_loop:
		lw $t1, 0 ($t0) # $t1 = A[i]
		lw $t2, 4($t0) # $t2 = A[i+1]
		slt $t3, $t1, $zero # $t3 = 1 sii A[i] < 0
		bne $t3, $zero, fin_impr
		slt $t3, $t2, $zero # $t3 = 1 sii A[i + 1] < 0
		bne $t3, $zero, ultimo_num
    		lw $a0, 0($t0) #Se carga en $a0 el valor de A[i]
    		
    		addi $v0, $zero, 1
    		syscall
    		
    		#imprimir coma
    		la $a0, coma
    		addi $v0, $zero, 4
    		syscall
    
    		# Imprimir espacio
    		la $a0, espacio
    		addi $v0, $zero, 4
    		syscall
    
    		# Verificar si el siguiente valor es -1 (fin del array)
    		addi $t0, $t0, 4 # siguiente valor del array
    		lw $t1, 0($t0)
    		slt $t2, $t1, $zero # $t2 = 1 sii A[i+1] < 0
   		beq $t2, $zero, imprimir_loop
   		
   	ultimo_num:
   		lw $a0, 0($t0)
   		
   		addi $v0, $zero, 1
   		syscall
   	fin_impr:
   		 jr $ra
 	
 promedio_func:
 	addi $t0, $zero, 0 #i=0, el cual también me va a servir como contador de números del array
 	addi $t1, $zero, 0 # $t1 = 0
 	addi $t2, $a0, 0 #Direccion del array guarda en $t2
 	
 	Sumatoria:
 		sll $t3, $t0, 2 #i*4
 		add $t3,  $t2, $t3 #$t3 = Dir(A[i])
 		lw $t3, 0($t3) #$t3 = A[i]
 		
 		#Verificar si es negativo
 		slt $t4, $zero, $t3 # $t4 = 1 sii 0 < A[i], $t4 = 0 sii 0 > A[i]
 		beq $zero, $t4, fin_sumatoria
 		
 		#Verificar que no haya overflow
 		lui $t4, 0x7FFF
 		ori $t4, 0xFFFF
 		subu $t4, $t4, $t3 # $t4 es la resta entre el valor máximo positivo con el A[i]
 		slt $t5, $t4, $t1 # $t5 = 1 sii $t4 < suma actual
 		bne $t5, $zero, overflow
 		
 		#Realiza la suma
 		addu $t1, $t1, $t3 # $t1 = Anteriores valores de A[i] + A[i]
 		addi $t0, $t0, 1 # i++
 		j Sumatoria
 		
 	fin_sumatoria:
 		# Aquí se tiene guardado en $t1 la suma de los números positivos del array y en $t0 se tiene la cantidad de números positivos que 
 		# contiene el array
 		beq $t0, $zero, arr_vacio
 		
 		div $t1, $t0 # se obtiene el promedio
 		mflo $v0 #guardar el cociente en $v0
 		mfhi $v1 #guardar el residuo en $v1
 		jr $ra
 		
 	overflow: #si se genera un overflow, $v0 = $v1 = -1
 		addi $v0, $zero, -1
 		addi $v1, $zero, -1
 		jr $ra
 		
 	arr_vacio: #si el array está vacío colocar ceros
 		addi $v0, $zero, 0
 		addi $v1, $zero, 0
 		jr $ra
