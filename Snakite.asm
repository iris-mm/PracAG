	# Hecho por Lucas Lorente e Iris Muñoz
	# Basado en el videojuego "Snake"
	
.data

frameBuffer: .space 262144	# El frameBuffer ocupa toda la pantalla, es decir; 256x256 x 4 bytes para cada uno
color_fondo: .word 0xadd8ff
color_kite: .word 0xffffff
color_paredes: .word 0xffffff

x_k: .word 8			# Guardamos variables para las coordenadas x e y del personaje
y_k: .word 8

i_fil: .word 16			# Creamos dos variables para recorrer las filas y las columnas del tablero
j_col: .word 16

.text
.globl main 		 	
main: 
la $s0, frameBuffer
lw $s1, color_fondo
lw $s2, color_paredes
lw $s3, color_kite


main_loop:
li $t2, 256		  	# Esto es el número de píxeles a pintar del fondo (16x16)
move $t0, $s0			# Creamos una variable para pintar sin afectar al frameBuffer

colorear_fondo:

sw $s1, 0($t0)            	# Guardar el color en la dirección actual
addi $t0, $t0, 4          	# Mover a la siguiente posiciÃ³n de pÃ­xel
addi $t2, $t2, -1         	# Decrementar contador
bgtz $t2, colorear_fondo    	# Repetir mientras queden píxeles

################		# Cargamos i y j
sw $t1, i_fil
sw $t2, j_col
li $t3, 16			# Número de píxeles a colorear por fila y columna

colorear_paredes: 
move $t0, $s0			# Reiniciamos $t0 a que apunte al inicio del frameBuffer

fila_superior:				
sw $s2, 0($t0)
addi $t0, $t0, 4
addi $t3, $t3, -1
bgtz $t3, fila_superior

################			
li $t1, 960			# Reiniciamos en todos los métodos las variables necesarias para pintar cada parte
add $t0, $s0, $t1
li $t3, 16
fila_inferior:				
sw $s2, 0($t0)
addi $t0, $t0, 4
addi $t3, $t3, -1
bgtz $t3, fila_inferior

################			
addi $t0, $s0, 0
li $t3, 16
col_superior:				
sw $s2, 0($t0)
addi $t0, $t0, 64
addi $t3, $t3, -1
bgtz $t3, col_superior

################
li $t1, 60			
add $t0, $s0, $t1
li $t3, 16
li $t3, 16
col_inferior:				
sw $s2, 0($t0)
addi $t0, $t0, 64
addi $t3, $t3, -1
bgtz $t3, col_inferior

# Controlador

li $t9, 0xffff0000
lw $t8, 0($t9)
beqz $t8, fin_entrada

lw $t8, 4($t9)



fin_entrada:

dibujar_personaje:
la $s0, frameBuffer
				# Todo esto calcula el número de celda a partir de las coordenadas
lw $s4, x_k
lw $s5, y_k
li $t9, 16
mult  $s5, $t9
mflo $s5
add $s5, $s5, $s4

				# Calcula el offset correspondiente a dicho número de celda
li $t9, 4
mult $s5, $t9
mflo $t6
add $t7, $s0, $t6

				# Guarda el color del personaje en la dirección de memoria correspondiente
sw $s3, 0($t7)

end:
j end
	

	


    
