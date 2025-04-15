li a0,LED_MATRIX_0_BASE
li a1, LED_MATRIX_0_WIDTH
li a2, LED_MATRIX_0_HEIGHT

li s0, 0x00000000
li t0, 0xffffffff
li tp, 0x000000ff
li t6, 0x0000ff00
li t3, 0x00ff0000

slli a3, a1,2
 
mv t1,zero
mv t2,a0
mv a6,a0
mv a7,zero

mv t5,zero
addi t4,a0,134
li a4, 875
 
TabBlanco:
    sw t0,0(t2)
    addi t2,t2,4
    addi t1, t1, 1
    bne t1, a4, TabBlanco

bolita:
    sw s0,4(a6)
    add a6,a6,a3
    addi a7, a7, 1
    bne a7, a2, jugador_1
    
jugador_1:
    sw t3,4(a6)
    add a6,a6,a3
    addi a7, a7, 1
    bne a7, a2, jugador_1
    
jugador_2:
    sw tp,0(t4)
    add t4,t4,a3
    addi t5, t5, 1
    bne t5, a2, jugador_2