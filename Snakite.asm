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
li $t2, 65536		  	# Esto es el número de píxeles a pintar del fondo (256x256)

colorear_fondo:
sw $t1, 0($t0)            	# Guardar el color en la dirección actual
addi $t0, $t0, 4          	# Mover a la siguiente posición de píxel
addi $t2, $t2, -1         	# Decrementar contador
bgtz $t2, colorear_fondo    	# Repetir mientras queden píxeles

dibujar_personaje

end:
j end
	

	


    
