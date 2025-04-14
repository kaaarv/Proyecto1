li a0,LED_MATRIX_0_BASE
li a1, LED_MATRIX_0_WIDTH
li a2, LED_MATRIX_0_HEIGHT
 
li t0, 0x00ff0000
li tp, 0x000000ff
li t6, 0x0000ff00
 
slli a3, a1,2
slli t3, a1, 1
 
mv t1,zero
mv t2,a0
 
mv t5,zero
addi t4,a0,136
 
 
jugador_1:
    sw t0,0(t2)
    add t2,t2,a3
    addi t1, t1, 1
    bne t1, a2, jugador_1
    
jugador_2:
    sw tp,0(t4)
    add t4,t4,a3
    addi t5, t5, 1
    bne t5, a2, jugador_2