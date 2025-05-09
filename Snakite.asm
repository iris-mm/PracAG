
	# Hecho por Lucas Lorente e Iris Mu駉z

	# Basado en el videojuego "Snake"
	
.data

frameBuffer: .space 1024	# El frameBuffer ocupa toda la pantalla, es decir; 16x16 x 4 bytes para cada uno
color_fondo: .word 0xadd8ff
color_kite: .word 0xff0000
color_paredes: .word 0xffffff
color_lazo: .word 0xeba1d1

lazo: .word 0

x_k: .word 8			# Guardamos variables para las coordenadas x e y del personaje
y_k: .word 8

last_direction: .word 0


i_fil: .word 16			# Creamos dos variables para recorrer las filas y las columnas del tablero
j_col: .word 16


.text
.globl main 		 	
main: 
la $s0, frameBuffer
lw $s1, color_fondo
lw $s2, color_paredes
lw $s3, color_kite

lw $s6, last_direction

main_loop:
li $t2, 256		  	# Esto es el n鷐ero de p韝eles a pintar del fondo (16x16)
move $t0, $s0			# Creamos una variable para pintar sin afectar al frameBuffer

colorear_fondo:

sw $s1, 0($t0)            	# Guardar el color en la direcci髇 actual
addi $t0, $t0, 4          	# Mover a la siguiente posici贸n de p铆xel
addi $t2, $t2, -1         	# Decrementar contador
bgtz $t2, colorear_fondo    	# Repetir mientras queden p韝eles

################		# Cargamos i y j
sw $t1, i_fil
sw $t2, j_col
li $t3, 16			# N鷐ero de p韝eles a colorear por fila y columna

colorear_paredes: 
move $t0, $s0			# Reiniciamos $t0 a que apunte al inicio del frameBuffer

fila_superior:				
sw $s2, 0($t0)
addi $t0, $t0, 4
addi $t3, $t3, -1
bgtz $t3, fila_superior

################			
li $t1, 960			# Reiniciamos en todos los m閠odos las variables necesarias para pintar cada parte
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
lw $t8, 0($t9)			#Cargar estado de la entrada
beqz $t8, movimiento		#Saltar secci贸n si no se pulsa ninguna tecla

lw $t8, 4($t9)			#Cargar tecla pulsada

				#Se ejecuta la secci贸n correspondiente a la tecla pulsada
beq $t8, 97, izquierda 
beq $t8, 100, derecha
beq $t8, 119, arriba
beq $t8, 115, abajo 
j movimiento

				#Todas estas secciones cambian la direcci贸n m谩s reciente a la correspondiente
				#a la de la direcci贸n pulsada (no permite giros de 180潞)
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

				#Ejecuta la secci贸n correspondiente a la direcci贸n reciente
beq $s6, 97, m_izquierda 
beq $s6, 100, m_derecha
beq $s6, 119, m_arriba
beq $s6, 115, m_abajo 
j colisiones

				#Todas estas funciones actualizan las coordenadas x e y del personaje,
				#movi茅ndolo en la direcci贸n correspondiente
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
				#Si las coordenadas del personaje son iguales a las de las paredes, ha habido colisi贸n
lw $s4, x_k
lw $s5, y_k
beq $s4, $zero, end
beq $s5, $zero, end
beq $s4, 15, end
beq $s5, 15, end

dibujar_personaje:
la $s0, frameBuffer

				# Todo esto calcula el n鷐ero de celda a partir de las coordenadas

lw $s4, x_k
lw $s5, y_k
li $t9, 16
mult  $s5, $t9
mflo $s5
add $s5, $s5, $s4

				# Calcula el offset correspondiente a dicho n鷐ero de celda
li $t9, 4
mult $s5, $t9
mflo $t6
add $t7, $s0, $t6

				# Guarda el color del personaje en la direcci髇 de memoria correspondiente
sw $s3, 0($t7)

				#Delay de 100 ms para que el juego vaya a una velocidad manejable
li $v0, 32 			
li $a0, 100
syscall

j main_loop

end:
li $v0,10
syscall

generar_lazo:
li $v0, 42       # syscall para n鷐ero aleatorio
li $a1, 14       # genera n鷐ero entre 0 y 13
syscall
addi $a0, 1
move $t0, $a0

li $v0, 42       # syscall para n鷐ero aleatorio
li $a1, 14       # genera n鷐ero entre 0 y 13
syscall
addi $a0, 1
move $t1, $a0

	

	

	


    
