# ============================================================
# Universidad de Costa Rica
# Estructuras de Computadores Digitales I 
# Estudiante: Brandon Jiménez Campos
# Carné: C33972
# Grupo: 1
# Tarea 4
#============================================================
#En este programa se toman los catetos de un triángulo rectángulo, se calcula la hipotenusa
# utilizando la aproximación con el método de Newton-Raphson para la raíz, mientras que el
# factorial se utilizó un bucle for, además también se calcula el seno y el coseno de este 
# ángulo.
# ============================================================

.data
cateto_a: .asciiz "Digite el valor del cateto a:\n"
cateto_b: .asciiz "Digite el valor del cateto b:\n"
hipotenusa: .asciiz "El valor de la hipotenusa es: "
angulo: .asciiz "El valor del angulo es: "
seno: .asciiz "El valor del seno del angulo opuesto al cateto menor es: "
coseno: .asciiz "El valor del coseno del angulo opuesto al cateto menor es: "
nueva_linea: .asciiz "\n"
radianes: .asciiz " radianes"

cero: .float 0.0
uno: .float 1.0
dos: .float 2.0
diez: .float 10.0
cuatro: .float 4.0

.text

main:

loop_main:
    la $a0, cateto_a
    addi $v0, $zero, 4
    syscall
    addi $v0, $zero, 6
    syscall
    mov.s $f31, $f0 #guardar cateto a
    
    la $a0, cateto_b
    addi $v0, $zero, 4
    syscall
    addi $v0, $zero, 6
    syscall
    mov.s $f30, $f0 #guardar cateto b
    
    la $t0, cero
    lwc1 $f2, 0($t0)
    c.eq.s $f31, $f2 #verificar si a es cero
    bc1f calcular
    c.eq.s $f30, $f2 #verificar si b es cero
    bc1t fin #ambos cero, salir
    
calcular:
    addi $sp, $sp, -4
    jal calc_hipotenusa #calcular hipotenusa
    jal calcu_angulo #calcular angulo
    add.s $f12, $f0, $f0 #copiar angulo
    sub.s $f12, $f12, $f0
    swc1 $f12, 0($sp) #guardar angulo
    jal calc_sen #calcular seno
    lwc1 $f12, 0($sp) #recuperar angulo
    jal calc_cos #calcular coseno
    j loop_main
    
fin:
    addi $v0, $zero, 10
    syscall

raiz:
    addi $sp, $sp, -16
    swc1 $f0, 12($sp) 
    swc1 $f1, 8($sp)
    swc1 $f2, 4($sp)
    swc1 $f3, 0($sp)
    lwc1 $f0, 16($sp) #$f0=N
    
    la $t0, dos
    lwc1 $f1, 0($t0) #$f1=2
    
    div.s $f2, $f0, $f1 #$f2=x=N/2 
    addi $t0, $zero, 20 #numero de iteraciones
    
iterRaiz:
    div.s $f3, $f0, $f2 #$f3=N/x
    add.s $f3, $f2, $f3 #$f3=x+N/x
    div.s $f2, $f3, $f1 #$f2=(x+N/x)/2
    beq $t0, $zero, retRaiz
    addi $t0, $t0, -1
    j iterRaiz
    
retRaiz:
    swc1 $f2, 16($sp)
    lwc1 $f3, 0($sp)
    lwc1 $f2, 4($sp)
    lwc1 $f1, 8($sp)
    lwc1 $f0, 12($sp) 
    addi $sp, $sp, 16
    jr $ra
        
calc_hipotenusa:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    mul.s $f4, $f31, $f31 #a al cuadrado
    mul.s $f5, $f30, $f30 #b al cuadrado
    add.s $f6, $f4, $f5 #sumar cuadrados
    
    # Usar método de Newton-Raphson
    addi $sp, $sp, -4
    swc1 $f6, 0($sp) #pasar N en el stack
    jal raiz
    lwc1 $f29, 0($sp) #recuperar resultado
    addi $sp, $sp, 4
     
    la $a0, hipotenusa
    addi $v0, $zero, 4
    syscall
     
    mov.s $f12, $f29 #preparar para imprimir
    addi $v0, $zero, 2
    syscall
    
    la $a0, nueva_linea
    addi $v0, $zero, 4
    syscall
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

factorial:
    addi $sp, $sp, -12
    swc1 $f12, 8($sp) #guardar n (flotante)
    swc1 $f1, 4($sp)
    swc1 $f2, 0($sp)
    
    la $t0, uno
    lwc1 $f0, 0($t0) #resultado inicia en 1.0
    lwc1 $f1, 0($t0) #contador inicia en 1.0
    
    lwc1 $f12, 8($sp) #cargar n
    
    la $t0, cero
    lwc1 $f2, 0($t0)
    c.le.s $f12, $f2 #si n <= 0
    bc1t fin_fact #retornar 1
    
loop_fact:
    c.le.s $f12, $f1 #comparar si contador > n
    bc1t fin_fact
    
    la $t0, uno
    lwc1 $f2, 0($t0)
    add.s $f1, $f1, $f2 #incrementar contador
    mul.s $f0, $f0, $f1 #multiplicar resultado por contador
    
    j loop_fact
    
fin_fact:
    lwc1 $f2, 0($sp)
    lwc1 $f1, 4($sp)
    addi $sp, $sp, 12
    jr $ra

potencia:
    addi $sp, $sp, -16
    sw $ra, 12($sp)
    swc1 $f12, 8($sp) #base
    sw $a0, 4($sp) #exponente
    swc1 $f1, 0($sp)
    
    la $t0, uno
    lwc1 $f0, 0($t0) #resultado inicia en 1
    
    beq $a0, $zero, fin_pot #si exp es 0, retorna 1
    
    lwc1 $f12, 8($sp) #cargar base
    
loop_pot:
    mul.s $f0, $f0, $f12 #multiplicar por la base
    addi $a0, $a0, -1 #decrementar exponente
    bne $a0, $zero, loop_pot
    
fin_pot:
    lwc1 $f1, 0($sp)
    lw $a0, 4($sp)
    lw $ra, 12($sp)
    addi $sp, $sp, 16
    jr $ra

calcu_angulo:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    c.lt.s $f31, $f30 #comparar cual cateto es menor
    bc1f usar_a
    
    add.s $f9, $f30, $f30 #usar b como el d
    sub.s $f9, $f9, $f30
    j calc_angulo
       
usar_a:
    add.s $f9, $f31, $f31 #usar a como el d
    sub.s $f9, $f9, $f31
       
calc_angulo:
    div.s $f10, $f9, $f29 #dividir d entre c
    add.s $f12, $f10, $f10 #copiar resultado
    sub.s $f12, $f12, $f10
    jal arcsen #calcular arcoseno

    la $a0, angulo
    addi $v0, $zero, 4
    syscall

    add.s $f12, $f0, $f0 #copiar angulo para imprimir
    sub.s $f12, $f12, $f0
    addi $v0, $zero, 2
    syscall
    
    la $a0, radianes
    addi $v0, $zero, 4
    syscall

    la $a0, nueva_linea
    addi $v0, $zero, 4
    syscall
    
    add.s $f28, $f0, $f0 #guardar angulo
    sub.s $f28, $f28, $f0

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

arcsen:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    add.s $f22, $f12, $f12 #guardar x
    sub.s $f22, $f22, $f12
    
    la $t0, cero
    lwc1 $f20, 0($t0) #inicializar suma en 0
    
    addi $t9, $zero, 0 #contador n = 0
    
arcsen_loop:
    addi $t0, $zero, 11
    slt $t1, $t9, $t0 #verificar si n < 11 (para incluir el 10)
    beq $t1, $zero, fin_arcsen
    
    sll $t1, $t9, 1 #calcular 2n
    
    addi $t2, $t1, 1 #calcular 2n+1
    
    # Factorial de 2n (flotante)
    mtc1 $t1, $f12
    cvt.s.w $f12, $f12
    jal factorial
    add.s $f4, $f0, $f0
    sub.s $f4, $f4, $f0
    
    # Factorial de n (flotante)
    mtc1 $t9, $f12
    cvt.s.w $f12, $f12
    jal factorial
    add.s $f6, $f0, $f0
    sub.s $f6, $f6, $f0
    
    mul.s $f6, $f6, $f6 #elevar al cuadrado
    
    la $t0, cuatro
    lwc1 $f12, 0($t0)
    addi $a0, $t9, 0
    jal potencia #4 elevado a n
    add.s $f8, $f0, $f0
    sub.s $f8, $f8, $f0
    
    add.s $f12, $f22, $f22 #recuperar x
    sub.s $f12, $f12, $f22
    addi $a0, $t2, 0
    jal potencia #x elevado a 2n+1
    add.s $f10, $f0, $f0
    sub.s $f10, $f10, $f0
    
    mul.s $f8, $f8, $f6 #multiplicar denominador
    mtc1 $t2, $f6
    cvt.s.w $f6, $f6
    mul.s $f8, $f8, $f6
    
    mul.s $f4, $f4, $f10 #multiplicar numerador
    
    div.s $f4, $f4, $f8 #dividir para obtener termino
    
    add.s $f20, $f20, $f4 #sumar termino a la suma
    
    addi $t9, $t9, 1 #incrementar contador
    j arcsen_loop

fin_arcsen:
    add.s $f0, $f20, $f20 #copiar resultado
    sub.s $f0, $f0, $f20
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
calc_sen:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    swc1 $f28, 4($sp)
    lwc1 $f12, 4($sp) #cargar angulo
    
    jal sen
    
    la $a0, seno
    addi $v0, $zero, 4
    syscall

    add.s $f12, $f0, $f0 #copiar resultado
    sub.s $f12, $f12, $f0
    addi $v0, $zero, 2
    syscall

    la $a0, nueva_linea
    addi $v0, $zero, 4
    syscall        

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
sen:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    add.s $f27, $f12, $f12 #guardar angulo
    sub.s $f27, $f27, $f12
    
    la $t0, cero
    lwc1 $f20, 0($t0) #inicializar suma
    
    addi $t9, $zero, 0 #contador n
    
sen_loop:
    addi $t0, $zero, 11
    slt $t1, $t9, $t0
    beq $t1, $zero, fin_sen
    
    andi $t1, $t9, 1 #determinar signo
    beq $t1, $zero, par
    
    addi $t1, $zero, -1 #signo negativo
    mtc1 $t1, $f1
    cvt.s.w $f1, $f1
    j sen_frac
    
par:
    addi $t1, $zero, 1 #signo positivo
    mtc1 $t1, $f1
    cvt.s.w $f1, $f1
    
sen_frac:
    sll $t1, $t9, 1 #calcular 2n
    addi $t1, $t1, 1 #calcular 2n+1
    
    # Factorial de 2n+1 (flotante)
    mtc1 $t1, $f12
    cvt.s.w $f12, $f12
    jal factorial
    add.s $f7, $f0, $f0
    sub.s $f7, $f7, $f0
     
    add.s $f12, $f27, $f27 #recuperar angulo
    sub.s $f12, $f12, $f27
    addi $a0, $t1, 0
    jal potencia #angulo elevado a 2n+1
    add.s $f8, $f0, $f0
    sub.s $f8, $f8, $f0
     
    mul.s $f1, $f1, $f8 #multiplicar signo por potencia
    div.s $f1, $f1, $f7 #dividir entre factorial
     
    add.s $f20, $f20, $f1 #sumar termino
    addi $t9, $t9, 1
    j sen_loop
     
fin_sen:
    add.s $f0, $f20, $f20 #copiar resultado
    sub.s $f0, $f0, $f20
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
     
calc_cos:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    swc1 $f28, 4($sp)
    lwc1 $f12, 4($sp) #cargar angulo
    
    jal cos
    
    la $a0, coseno
    addi $v0, $zero, 4
    syscall

    add.s $f12, $f0, $f0 #copiar resultado
    sub.s $f12, $f12, $f0
    addi $v0, $zero, 2
    syscall

    la $a0, nueva_linea
    addi $v0, $zero, 4
    syscall        

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
     
cos:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    add.s $f27, $f12, $f12 #guardar angulo
    sub.s $f27, $f27, $f12
    
    la $t0, cero
    lwc1 $f20, 0($t0) #inicializar suma
    
    addi $t9, $zero, 0 #contador n
    
cos_loop:
    addi $t0, $zero, 11
    slt $t1, $t9, $t0
    beq $t1, $zero, fin_cos
    
    andi $t1, $t9, 1 #determinar signo
    beq $t1, $zero, par_cos
    
    addi $t1, $zero, -1 #signo negativo
    mtc1 $t1, $f1
    cvt.s.w $f1, $f1
    j cos_frac
    
par_cos:
    addi $t1, $zero, 1 #signo positivo
    mtc1 $t1, $f1
    cvt.s.w $f1, $f1
    
cos_frac:
    sll $t1, $t9, 1 #calcular 2n
    
    # Factorial de 2n (flotante)
    mtc1 $t1, $f12
    cvt.s.w $f12, $f12
    jal factorial
    add.s $f7, $f0, $f0
    sub.s $f7, $f7, $f0
     
    add.s $f12, $f27, $f27 #recuperar angulo
    sub.s $f12, $f12, $f27
    addi $a0, $t1, 0
    jal potencia #angulo elevado a 2n
    add.s $f8, $f0, $f0
    sub.s $f8, $f8, $f0
     
    mul.s $f1, $f1, $f8 #multiplicar signo por potencia
    div.s $f1, $f1, $f7 #dividir entre factorial
     
    add.s $f20, $f20, $f1 #sumar termino
    addi $t9, $t9, 1
    j cos_loop
     
fin_cos:
    add.s $f0, $f20, $f20 #copiar resultado
    sub.s $f0, $f0, $f20
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
