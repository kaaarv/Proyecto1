.data 
# ============================================
# CONFIGURACION DE D-PAD 1 Y 2
# ============================================
    D_UP1:      .word D_PAD_0_UP      # Tecla arriba(1)
    D_DOWN1:     .word D_PAD_0_DOWN       # Tecla abajo (1)
    D_UP2:      .word D_PAD_1_UP       # Tecla arriba(2)
    D_DOWN2:      .word D_PAD_1_DOWN       # Tecla abajo(2)
.text
main:
# ============================================
# CONFIGURACIÓN DE LA MATRIZ LED
# ============================================
    li a0, LED_MATRIX_0_BASE       # Dirección base de la matriz
    li a1, LED_MATRIX_0_WIDTH      # Ancho de la matriz
    li a2, LED_MATRIX_0_HEIGHT     # Alto de la matriz
    slli a3, a1, 2                 # a3 = ancho * 4 (bytes por fila)
 
# ============================================
# DEFINICIÓN DE COLORES
# ============================================
    li s0, 0x00000000      # Fondo negro
    li s1, 0x00FF00FF      # Paddle rosado (jugador 1)
    li s8, 0x0000FFFF      # Paddle celeste (jugador 2)
    li t6, 0x0000FF00                # Bolita (verde neón)
 
# ============================================
# POSICIÓN INICIAL DE LOS PADDLES
# ============================================
    li s2, 8               # Jugador 1: fila superior
    li s3, 5              # Jugador 1: altura
    li s4, 1               # Jugador 1: columna fija

    li s5, 8               # Jugador 2: fila superior
    li s6, 5              # Jugador 2: altura
    li s7, 33              # Jugador 2: columna fija
    
# ============================================


# ============================================
# POSICIÓN INICIAL DE LA BOLITA
# ============================================
    li s9, 16              # Columna inicial
    li s10, 12             # Fila inicial
    li t4, 1               # Dirección horizontal (1 = derecha, -1 = izquierda)
    li a6, 1               # Dirección vertical (1 = abajo, -1 = arriba)









# ============================================
# BUCLE PRINCIPAL
# ============================================


loop:
# --------- LECTURA DE BOTONES ---------
    # Jugador 1
    lw t0, D_UP1
    lw t0, 0(t0)
    lw t1, D_DOWN1
    lw t1, 0(t1)

    # Jugador 2
    lw t2, D_UP2
    lw t2, 0(t2)
    lw t3, D_DOWN2
    lw t3, 0(t3)

# --------- LÓGICA DE MOVIMIENTO ---------
    # Jugador 1
    andi t4, t0, 1
    bnez t4, mover_arriba_p1
    bnez t1, mover_abajo_p1
    li t4, 0  # No se movió

    # Jugador 2
    andi t5, t2, 1
    bnez t5, mover_arriba_p2
    bnez t3, mover_abajo_p2
    li t5, 0  # No se movió

    j dibujar_barra

# ============================================
# MOVIMIENTO JUGADOR 1
# ============================================
mover_arriba_p1:
    beqz s2, continuar_p1
    addi s2, s2, -1

    # Borrar fila inferior anterior
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

    # Borrar fila superior anterior
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

    # Borrar fila inferior anterior
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

    # Borrar fila superior anterior
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
# BARRAS EN LA MATRIZ LED
# ============================================

dibujar_barra:
    # Jugador 1 (Rosado)
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

    # Jugador 2 (Celeste)
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
  j loop

