	# Hecho por Lucas Lorente e Iris MuÃ±oz
	# Basado en el videojuego "Snake"
	
.data

frameBuffer: .space 262144	# El frameBuffer ocupa toda la pantalla, es decir; 256x256 x 4 bytes para cada uno
color_fondo: .word 0xadd8ff
color_kite: .word 0xffffff

x_k: .word 8
y_k: .word 8
last_direction: .word 0
.text
.globl main 		 	# Variables globales
main: 
la $s0, frameBuffer
lw $s1, color_fondo
lw $s3, color_kite

lw $s6, last_direction

main_loop:
li $t2, 256		  	# Esto es el nÃºmero de pÃ­xeles a pintar del fondo (16x16)

colorear_fondo:

sw $s1, 0($s0)            	# Guardar el color en la direcciÃ³n actual
addi $s0, $s0, 4          	# Mover a la siguiente posiciÃ³n de pÃ­xel
addi $t2, $t2, -1         	# Decrementar contador
bgtz $t2, colorear_fondo    	# Repetir mientras queden pÃ­xeles

<<<<<<< Updated upstream
=======
colorear_paredes: 


>>>>>>> Stashed changes

# Controlador

li $t9, 0xffff0000
lw $t8, 0($t9)			#Cargar estado de la entrada
beqz $t8, movimiento		#Saltar sección si no se pulsa ninguna tecla

lw $t8, 4($t9)			#Cargar tecla pulsada

				#Se ejecuta la sección correspondiente a la tecla pulsada
beq $t8, 97, izquierda 
beq $t8, 100, derecha
beq $t8, 119, arriba
beq $t8, 115, abajo 
j movimiento

				#Todas estas secciones cambian la dirección más reciente a la correspondiente
				#a la de la dirección pulsada (no permite giros de 180º)
izquierda:
beq $s6, 100, movimiento
move $s6, $t8
sw $s6, last_direction
j movimiento

derecha:
beq $s6, 97, movimiento
move $s6, $t8
sw $s6, last_direction
j movimiento

arriba:
beq $s6, 115, movimiento
move $s6, $t8
sw $s6, last_direction
j movimiento

abajo:
beq $s6, 119, movimiento
move $s6, $t8
sw $s6, last_direction
j movimiento


movimiento:
lw $s6, last_direction

				#Ejecuta la sección correspondiente a la dirección reciente
beq $s6, 97, m_izquierda 
beq $s6, 100, m_derecha
beq $s6, 119, m_arriba
beq $s6, 115, m_abajo 
j colisiones

				#Todas estas funciones actualizan las coordenadas x e y del personaje,
				#moviéndolo en la dirección correspondiente
m_izquierda:
lw $t0, x_k
addi $t0, $t0, -1
sw $t0, x_k
j colisiones

m_derecha:
lw $t0, x_k
addi $t0, $t0, 1
sw $t0, x_k
j colisiones

m_arriba:
lw $t0, y_k
addi $t0, $t0, -1
sw $t0, y_k
j colisiones

m_abajo:
lw $t0, y_k
addi $t0, $t0, 1
sw $t0, y_k
j colisiones

colisiones:
				#Si las coordenadas del personaje son iguales a las de las paredes, ha habido colisión
lw $s4, x_k
lw $s5, y_k
beq $s4, $zero, end
beq $s5, $zero, end
beq $s4, 15, end
beq $s5, 15, end

dibujar_personaje:
la $s0, frameBuffer
				#Todo esto calcula el número de celda a partir de las coordenadas
lw $s4, x_k
lw $s5, y_k
li $t9, 16
mult  $s5, $t9
mflo $s5
add $s5, $s5, $s4

				#Calcula el offset correspondiente a dicho número de celda
li $t9, 4
mult $s5, $t9
mflo $t6
add $t7, $s0, $t6

				#Guarda el color del personaje en la dirección de memoria correspondiente
sw $s3, 0($t7)

				#Delay de 100 ms para que el juego vaya a una velocidad manejable
li $v0, 32 			
li $a0, 100
syscall

j main_loop

end:
li $v0,10
syscall
	

	


    
