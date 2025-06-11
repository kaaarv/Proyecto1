# Digitales
# Manual del Juego "Ping Pong" en Ripes

## Descripción del Proyecto

Este proyecto implementa un juego de **Ping Pong** (similar al clásico *Pong*) utilizando **ensamblador RISC-V**. El juego se ejecuta en una matriz LED y utiliza entradas de teclado para controlar los paddles de dos jugadores. La bolita se mueve dentro de la matriz, rebotando en las paredes y los paddles, mientras los jugadores intentan evitar que la bolita salga de su lado.


## Tabla de Contenidos

- [Configuración Inicial](#configuración-inicial)
- [Funcionamiento del Juego](#funcionamiento-del-juego)
- [Control de Jugadores](#control-de-jugadores)
- [Movimiento de la Bolita](#movimiento-de-la-bolita)
- [Colisiones y Rebotes](#colisiones-y-rebotes)
- [Dibujo en la Matriz LED](#dibujo-en-la-matriz-led)
- [Estructura del Código](#estructura-del-código)
- [Cómo Ejecutar el Juego](#cómo-ejecutar-el-juego)

---

## Configuración Inicial

Comenzamos realizando las configuraciones necesarias para cada uno de los elementos del juego:

### 1. Configuración del D-Pad
Se definen las direcciones de memoria para los botones de los controles (D-Pad) de ambos jugadores:

- `D_UP1` y `D_DOWN1`: Controlan el movimiento del **jugador 1**.  
- `D_UP2` y `D_DOWN2`: Controlan el movimiento del **jugador 2**.

### 2. Configuración de la Matriz LED

Dimensiones de la matriz LED:

- `LED_MATRIX_0_BASE`: Dirección base de la matriz.  
- `LED_MATRIX_0_WIDTH`: Ancho de la matriz.  
- `LED_MATRIX_0_HEIGHT`: Alto de la matriz.

### 3. Definición de Colores

Los colores se representan como valores hexadecimales:

- **Negro** (`0x00000000`): Fondo.  
- **Rosado** (`0x00FF00FF`): Paddle del jugador 1.  
- **Celeste** (`0x0000FFFF`): Paddle del jugador 2.  
- **Verde neón** (`0x0000FF00`): Bolita.

### 4. Posición Inicial

- **Jugador 1**: Columna fija, fila inicial superior.  
- **Jugador 2**: Columna fija, fila inicial superior.  
- **Bolita**: Comienza en el centro con dirección diagonal (abajo/derecha).

---

## Funcionamiento del Juego

El juego opera dentro de un bucle principal que:

- Actualiza la posición de la bolita.
- Verifica colisiones con bordes o paddles.
- Lee las entradas de los jugadores.
- Redibuja todo en la matriz LED.
- Repite indefinidamente.

---

## Control de Jugadores

Cada jugador controla su paddle mediante los botones de dirección:

### Jugador 1
- `D_UP1`: Mueve el paddle hacia arriba.
- `D_DOWN1`: Mueve el paddle hacia abajo.

### Jugador 2
- `D_UP2`: Mueve el paddle hacia arriba.
- `D_DOWN2`: Mueve el paddle hacia abajo.


---

## Movimiento de la Bolita

La bolita se mueve automáticamente en cada ciclo del bucle principal. Su dirección se define con dos variables:

- `tp`: Dirección horizontal (`1` = derecha, `-1` = izquierda).  
- `a6`: Dirección vertical (`1` = abajo, `-1` = arriba).

Su nueva posición se calcula sumando estas direcciones a sus coordenadas (`s9` para columna y `s10` para fila).

---

## Colisiones y Rebotes

### 1. Rebotes en los Bordes

- Colisión con los bordes verticales: se invierte `tp`.
- Colisión con los bordes horizontales: se invierte `a6`.

### 2. Rebotes en los Paddles

- Si la bolita coincide con la posición de un paddle, se invierte `tp`.
---

## Dibujo en la Matriz LED

### 1. Paddles

- Se dibujan como barras verticales.
- **Jugador 1**: color rosado.  
- **Jugador 2**: color celeste.

### 2. Bolita

- Un solo LED encendido con color verde neón.
- Antes de moverla, se apaga su LED anterior.

---
### 3. Puntaje
Los puntajes de los jugadores se representan como LEDs en los extremos de la matriz:
- Puntos del jugador 1: LEDs en el lado izquierdo.
- Puntos del jugador 2: LEDs en el lado derecho. 

## Estructura del Código

### Sección `.data`

Define constantes, colores, posiciones iniciales y direcciones de entrada/salida.

### Sección `.text`

Código ejecutable dividido en:

- **Configuración inicial**: Inicializa el entorno de juego.
- **Bucle principal (`loop`)**: Controla lógica del juego y renderizado.
- **Movimiento de jugadores**: Lee el D-Pad y actualiza la posición.
- **Rebotes**: Cambia dirección según colisiones.
- **Dibujo**: Actualiza matriz LED.
-  **Puntuación y reinicio de la bolita**: Agrega punto y reinicia la bola


---

## Cómo Ejecutar el Juego

### 1. Compilación

Compila con un ensamblador RISC-V, como:
-Ripes
-QEMU


```bash
riscv64-unknown-elf-gcc -o pingo.elf pingo.s
