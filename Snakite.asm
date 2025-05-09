	# Hecho por Lucas Lorente e Iris Muñoz
	# Basado en el videojuego "Snake"
	
.data

frameBuffer: .space 262144	# El frameBuffer ocupa toda la pantalla, es decir; 256x256 x 4 bytes para cada uno
color_fondo: .word 0xadd8ff
color_kite: .word 0xffffff
color_paredes: .word 0x00FF0000

x_k: .word 8			# Guardamos variables para las coordenadas x e y del personaje
y_k: .word 8

.text
.globl main 		 	
main: 
la $s0, frameBuffer
lw $s1, color_fondo
lw $s3, color_kite

main_loop:
li $t2, 256		  	# Esto es el número de píxeles a pintar del fondo (16x16)

colorear_fondo:

sw $s1, 0($s0)            	# Guardar el color en la dirección actual
addi $s0, $s0, 4          	# Mover a la siguiente posición de píxel
addi $t2, $t2, -1         	# Decrementar contador
bgtz $t2, colorear_fondo    	# Repetir mientras queden píxeles

colorear_paredes: 
li 


# Controlador

li $t9, 0xffff0000
lw $t8, 0($t9)
beqz $t8, fin_entrada

lw $t8, 4($t9)



fin_entrada:

dibujar_personaje:
la $s0, frameBuffer
				#Todo esto calcula el n�mero de celda a partir de las coordenadas
lw $s4, x_k
lw $s5, y_k
li $t9, 16
mult  $s5, $t9
mflo $s5
add $s5, $s5, $s4

				#Calcula el offset correspondiente a dicho n�mero de celda
li $t9, 4
mult $s5, $t9
mflo $t6
add $t7, $s0, $t6

				#Guarda el color del personaje en la direcci�n de memoria correspondiente
sw $s3, 0($t7)

end:
j end
	

	


    
