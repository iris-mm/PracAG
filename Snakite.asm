	# Hecho por Lucas Lorente e Iris Muñoz
	# Basado en el videojuego "Snake"
	
.data

frameBuffer: .space 262144	# El frameBuffer ocupa toda la pantalla, es decir; 256x256 x 4 bytes para cada uno
color_fondo: .word 0xadd8ff
color_kite: .word 0xffffff

x_k: .word 8
y_k: .word 8

.text
.globl main 		 	# Variables globales
main: 
la $t0, frameBuffer
lw $t1, color_fondo
lw $t3, color_kite

main_loop:
li $t2, 256		  	# Esto es el número de píxeles a pintar del fondo (16x16)

colorear_fondo:

sw $t1, 0($t0)            	# Guardar el color en la dirección actual
addi $t0, $t0, 4          	# Mover a la siguiente posición de píxel
addi $t2, $t2, -1         	# Decrementar contador
bgtz $t2, colorear_fondo    	# Repetir mientras queden píxeles


dibujar_personaje:
la $t0, frameBuffer
				#Todo esto calcula el n�mero de celda a partir de las coordenadas
lw $t4, x_k
lw $t5, y_k
li $t9, 16
mult  $t5, $t9
mflo $t5
add $t5, $t5, $t4

				#Calcula el offset correspondiente a dicho n�mero de celda
li $t9, 4
mult $t5, $t9
mflo $t6
add $t7, $t0, $t6

				#Guarda el color del personaje en la direcci�n de memoria correspondiente
sw $t3, 0($t7)

end:
j end
	

	


    
