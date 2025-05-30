.data
# ============================================
# CONFIGURACION DE D-PAD 1 Y 2
# ============================================
    D_UP1:      .word D_PAD_0_UP
    D_DOWN1:    .word D_PAD_0_DOWN
    D_UP2:      .word D_PAD_1_UP
    D_DOWN2:    .word D_PAD_1_DOWN

# ============================================
# PUNTAJES DE JUGADORES
# ============================================
    Puntaje_J1: .word 0    
    Puntaje_J2: .word 0   

.text
main:
# ============================================
# CONFIGURACION DE LA MATRIZ LED
# ============================================
    li a0, LED_MATRIX_0_BASE
    li a1, LED_MATRIX_0_WIDTH
    li a2, LED_MATRIX_0_HEIGHT
    slli a3, a1, 2

# ============================================
# DEFINICION DE COLORES
# ============================================
    li s0, 0x00000000      # Fondo negro
    li s1, 0x00FF00FF      # Paddle rosado (jugador 1)
    li s8, 0x0000FFFF      # Paddle celeste (jugador 2)
    li gp, 0x0000FF00      # Bolita (verde neOn)

# ============================================
# INICIALIZAR PUNTAJES
# ============================================
    li t5, 0               # Puntaje jugador 1
    li t6, 0               # Puntaje jugador 2

# ============================================
# POSICION INICIAL DE LOS PADDLES
# ============================================
    li s2, 8
    li s3, 5
    li s4, 1

    li s5, 8
    li s6, 5
    li s7, 33

# ============================================
# POSICION INICIAL DE LA BOLITA
# ============================================
    li s9, 16
    li s10, 12
    li tp, 1
    li a6, 1
    mv a6, a6
    mv tp, tp

# ============================================
# BUCLE PRINCIPAL
# ============================================
loop:

# ============================================
# ACTUALIZAR POSICION
# ============================================
    add s9, s9, tp
    add s10, s10, a6

# ============================================
# REBOTES EN BORDES
# ============================================
    li a7, 0
    ble s9, a7, punto_j2

    li a7, 34
    bge s9, a7, punto_j1

    li a7, 0
    blt s10, a7, cambiar_dir_y
    li a7, 24
    bgt s10, a7, cambiar_dir_y

# ============================================
# REBOTES EN JUGADORES
# ============================================
    li t0, 1
    beq s9, t0, revisar_p1

    li t1, 33
    beq s9, t1, revisar_p2

    j continuar

# ============================================
# VERIFICACION DE COLISION CON JUGADOR 1
# ============================================
revisar_p1:
    bge s10, s2, revisar_p1_bajo
    j continuar
revisar_p1_bajo:
    add t2, s2, s3
    ble s10, t2, colision_paddle
    j continuar

# ============================================
# VERIFICACIoN DE COLISION CON JUGADOR 2
# ============================================
revisar_p2:
    bge s10, s5, revisar_p2_bajo
    j continuar
revisar_p2_bajo:
    add t3, s5, s6
    ble s10, t3, colision_paddle
    j continuar

# ============================================
# COLISION DETECTADA
# ============================================
colision_paddle:
    neg tp, tp
    j continuar

continuar:
# ============================================
# CALCULAR DIRECCION Y ENCENDER NUEVA LED
# ============================================
    mul a7, s10, a1
    add a7, a7, s9
    slli a7, a7, 2
    add ra, a0, a7
    sw gp, 0(ra)

# ============================================
# LECTURA DE BOTONES
# ============================================
    lw t0, D_UP1
    lw t0, 0(t0)
    lw t1, D_DOWN1
    lw t1, 0(t1)

    lw t2, D_UP2
    lw t2, 0(t2)
    lw t3, D_DOWN2
    lw t3, 0(t3)

# ============================================
# LOGICA DE MOVIMIENTO
# ============================================
    andi t4, t0, 1
    bnez t4, mover_arriba_p1
    bnez t1, mover_abajo_p1
    li t4, 0

    andi t5, t2, 1
    bnez t5, mover_arriba_p2
    bnez t3, mover_abajo_p2
    li t5, 0

    j dibujar_barra

# ============================================
# MOVIMIENTO JUGADOR 1
# ============================================
mover_arriba_p1:
    beqz s2, continuar_p1
    addi s2, s2, -1
    add t4, s2, s3
    li t5, 25
    bge t4, t5, continuar_p1
    mul t6, t4, a1
    slli t6, t6, 2
    add t6, t6, a0
    sw s0, 4(t6)
continuar_p1:
    j dibujar_barra

mover_abajo_p1:
    add t4, s2, s3
    li t5, 25
    bge t4, t5, continuar_p1
    addi s2, s2, 1
    addi t4, s2, -1
    bltz t4, continuar_p1
    mul t6, t4, a1
    slli t6, t6, 2
    add t6, t6, a0
    sw s0, 4(t6)
    j continuar_p1

# ============================================
# MOVIMIENTO JUGADOR 2
# ============================================
mover_arriba_p2:
    beqz s5, continuar_p2
    addi s5, s5, -1
    add t4, s5, s6
    li t5, 25
    bge t4, t5, continuar_p2
    mul t6, t4, a1
    slli t6, t6, 2
    add t6, t6, a0
    slli a4, s7, 2
    add a5, t6, a4
    sw s0, 0(a5)
continuar_p2:
    j dibujar_barra

mover_abajo_p2:
    add t4, s5, s6
    li t5, 25
    bge t4, t5, continuar_p2
    addi s5, s5, 1
    addi t4, s5, -1
    bltz t4, continuar_p2
    mul t6, t4, a1
    slli t6, t6, 2
    add t6, t6, a0
    slli a4, s7, 2
    add a5, t6, a4
    sw s0, 0(a5)
    j continuar_p2

# ============================================
# DIBUJAR BARRAS
# ============================================
dibujar_barra:
    mv t4, s2
    mul t5, t4, a1
    slli t5, t5, 2
    add t5, t5, a0
    li t6, 0
dibujo_p1:
    sw s1, 4(t5)
    add t5, t5, a3
    addi t6, t6, 1
    blt t6, s3, dibujo_p1

    mv t4, s5
    mul t5, t4, a1
    slli t5, t5, 2
    add t5, t5, a0
    li t6, 0
    slli s11, s7, 2

dibujo_p2:
    add a5, t5, s11
    sw s8, 0(a5)
    add t5, t5, a3
    addi t6, t6, 1
    blt t6, s6, dibujo_p2

    jal ra, dibujar_puntaje

# ============================================
# APAGAR LED ANTERIOR
# ============================================
    mul a7, s10, a1
    add a7, a7, s9
    slli a7, a7, 2
    add ra, a0, a7
    sw s0, 0(ra)

    j loop

# ============================================
# CAMBIO DIRECCION X
# ============================================
cambiar_dir_x:
    neg tp, tp
    mv tp, tp
    j loop

# ============================================
# CAMBIO DIRECCION Y
# ============================================
cambiar_dir_y:
    neg a6, a6
    mv a6, a6
    j loop

# ============================================
# PUNTAJE: JUGADOR 1 y 2
# ============================================
punto_j1:
    la t0, Puntaje_J1     
    lw t1, 0(t0)          
    addi t1, t1, 1       
    sw t1, 0(t0)          
    j reiniciar_bolita

punto_j2:
    la t0, Puntaje_J2     
    lw t1, 0(t0)
    addi t1, t1, 1
    sw t1, 0(t0)
    j reiniciar_bolita

# ============================================
# REINICIAR BOLITA
# ============================================
reiniciar_bolita:
    li s9, 17
    li s10, 12
    li tp, 1
    li a6, 1
    j loop

# ============================================
# DIBUJAR PUNTAJE
# ============================================
dibujar_puntaje:
    la t0, Puntaje_J1     
    lw t1, 0(t0)         

    li t0, 0             
    li t2, 0              
dibujar_p1:
    bge t2, t1, dibujar_p2
    mul t3, zero, a1
    add t3, t3, t0
    slli t3, t3, 2
    add t3, a0, t3
    sw s1, 0(t3)
    addi t0, t0, 1
    addi t2, t2, 1
    j dibujar_p1

dibujar_p2:
    la t0, Puntaje_J2      
    lw t1, 0(t0)          
    li t0, 34             
    li t2, 0

dibujar_p2_loop:
    bge t2, t1, fin_dibujar_puntaje
    mul t3, zero, a1
    add t3, t3, t0
    slli t3, t3, 2
    add t3, a0, t3
    sw s8, 0(t3)
    addi t0, t0, -1
    addi t2, t2, 1
    j dibujar_p2_loop

fin_dibujar_puntaje:
    jr ra