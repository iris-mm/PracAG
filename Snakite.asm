#####################################################################
#
# Proyecto de Arquitecturas Gráficas - URJC
#
# Autores:
# - Lorente Herranz, Lucas
# - Muñoz Montero, Iris
#
# Bitmap Display:
# - Unit width in pixels: 16
# - Unit height in pixels: 16
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10010000 (static data)
#
# Máximo objetivo alcanzado en el proyecto:
# - Juego base/1 ampliación/2 ampliaciones/3 ampliaciones (elegir el que proceda)
#
# Ampliaciones implementadas (si hay alguna)
# 3. Presentar objetos rompibles por pantalla que desaparecen al interactuar con ellos.
#
# Instrucciones del juego:
# - El jugador deberá utilizar las teclas 'w', 's', 'a', 'd' para moverse por el espacio.
#   El objetivo del juego es recolectar los lazos que aparecen aleatoriamente en pantalla
#   para hacer crecer a la cometa, tratando de no chocar con los límites en el proceso.
# - EL juego no tiene una condición de victoria, sino que al igual que el snake clásico; es infinito.
# - El jugador pierde cuando se choca con los límites de la pantalla o con su propio cuerpo
#
#####################################################################
	
.data

frameBuffer: .space 1024	# El frameBuffer ocupa toda la pantalla, es decir; 16x16 x 4 bytes para cada uno

colores:.word 0xadd8ff 		# Azul
	.word 0xff0000		# Rojo
	.word 0xffffff		# Blanco
	.word 0xeba1d1		# Rosa
	
posiciones: .space 256		# Espacio para el array de pos de la cuerda de la cometa

longitud: .word 1

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
la $s1, colores

la $s2, posiciones

lw $s3, longitud

lw $s6, last_direction



jal generar_lazo		# Se llama a la subrutina para que cree el primer lazo
lw $s7, lazo

li $t0, 136
sb $t0, 0($s2)			# Se carga la posicion inicial en el array

main_loop:

li $t2, 256		  	# Esto es el número de píxeles a pintar del fondo (16x16)
move $t0, $s0			# Creamos una variable para pintar sin afectar al frameBuffer

colorear_fondo:

lw $t3, 0($s1)			# Cargar el color azul del array
sw $t3, 0($t0)            	# Guardar el color en la dirección actual
addi $t0, $t0, 4          	# Mover a la siguiente posiciÃ³n de pÃ­xel
addi $t2, $t2, -1         	# Decrementar contador
bgtz $t2, colorear_fondo    	# Repetir mientras queden píxeles

################		# Cargamos i y j
sw $t1, i_fil
sw $t2, j_col
li $t3, 16			# Número de píxeles a colorear por fila y columna

lw $t4, 8($s1)			# Cargar color blanco del array
colorear_paredes: 
move $t0, $s0			# Reiniciamos $t0 a que apunte al inicio del frameBuffer

fila_superior:				
sw $t4, 0($t0)
addi $t0, $t0, 4
addi $t3, $t3, -1
bgtz $t3, fila_superior

################			
li $t1, 960			# Reiniciamos en todos los métodos las variables necesarias para pintar cada parte
add $t0, $s0, $t1
li $t3, 16
fila_inferior:				
sw $t4, 0($t0)
addi $t0, $t0, 4
addi $t3, $t3, -1
bgtz $t3, fila_inferior

################			
addi $t0, $s0, 0
li $t3, 16
col_superior:				
sw $t4, 0($t0)
addi $t0, $t0, 64
addi $t3, $t3, -1
bgtz $t3, col_superior

################
li $t1, 60			
add $t0, $s0, $t1
li $t3, 16
col_inferior:				
sw $t4, 0($t0)
addi $t0, $t0, 64
addi $t3, $t3, -1
bgtz $t3, col_inferior


# Controlador

li $t9, 0xffff0000
lw $t8, 0($t9)			#Cargar estado de la entrada
beqz $t8, movimiento		#Saltar secciÃ³n si no se pulsa ninguna tecla

lw $t8, 4($t9)			#Cargar tecla pulsada

				#Se ejecuta la secciÃ³n correspondiente a la tecla pulsada
beq $t8, 97, izquierda 
beq $t8, 100, derecha
beq $t8, 119, arriba
beq $t8, 115, abajo 
j movimiento

				#Todas estas secciones cambian la direcciÃ³n mÃ¡s reciente a la correspondiente
				#a la de la direcciÃ³n pulsada (no permite giros de 180Âº)
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

				# Ejecuta la secciÃ³n correspondiente a la direcciÃ³n reciente
beq $s6, 97, m_izquierda 
beq $s6, 100, m_derecha
beq $s6, 119, m_arriba
beq $s6, 115, m_abajo 
j colisiones

				# Todas estas funciones actualizan las coordenadas x e y del personaje,
				# moviÃ©ndolo en la direcciÃ³n correspondiente
m_izquierda:
lw $t0, x_k
addi $t0, $t0, -1
sw $t0, x_k
j mover_cuerpo

m_derecha:
lw $t0, x_k
addi $t0, $t0, 1
sw $t0, x_k
j mover_cuerpo

m_arriba:
lw $t0, y_k
addi $t0, $t0, -1
sw $t0, y_k
j mover_cuerpo

m_abajo:
lw $t0, y_k
addi $t0, $t0, 1
sw $t0, y_k
j mover_cuerpo

				# Rutina para mover las posiciones del cuerpo de la serpiente
mover_cuerpo:
				# Cargar la longitud actual de la serpiente
lw $s3, longitud

li $t1, 1
beq $s3, $t1, insertar_nueva_posicion
				# Mover las posiciones del cuerpo una casilla hacia atrás
move $t1, $s3   		# $t1 = longitud
addi $t1, $t1, -1		# Última posición válida
add $t0, $s2, $t1   		# $t0 apunta a la última posición válida del cuerpo


mover_posiciones:
bltz $t1, insertar_nueva_posicion  

lbu $t2, -1($t0)        	# Leer la posición anterior
sb $t2, 0($t0)          	# Guardarla en la posición actual

addi $t0, $t0, -1       	# Retroceder al segmento anterior
addi $t1, $t1, -1       	# Decrementar contador
j mover_posiciones

				
insertar_nueva_posicion:

lw $s4, x_k
lw $s5, y_k
li $t9, 16
mult  $s5, $t9
mflo $t5
add $t5, $t5, $s4

sb $t5, 0($s2)           	# Insertar la nueva posición en el array de posiciones

colisiones:

				# Comprobar colisiones con el cuerpo 
lw $s4, x_k
lw $s5, y_k
li $t9, 16
mult $s5, $t9
mflo $t5
add $t5, $t5, $s4     	        # Posición actual (0-255)
	
				# Recorre las posiciones
li $t0, 1             		# índice desde 1 (no contamos la cometa inicial)
lw $t1, longitud
addi $t1, $t1, -1      	        # Hasta longitud - 1

la $t2, posiciones    	 	

comprobar_cuerpo:
bgt $t0, $t1, continuar_colisiones

add $t3, $t2, $t0      		# Dirección de posiciones[i]
lbu $t4, 0($t3)        		# valor de posiciones[i]

beq $t4, $t5, end      		# Si coincide con posición actual, fin

addi $t0, $t0, 1
j comprobar_cuerpo

continuar_colisiones:
				# Si las coordenadas del personaje son iguales a las de las paredes, ha habido colisiÃ³n
lw $s4, x_k
lw $s5, y_k
beq $s4, $zero, end
beq $s5, $zero, end
beq $s4, 15, end
beq $s5, 15, end

dibujar_lazo:
				# Calculo direccion de memoria correspondiente a la casilla del lazo
li $t0, 4
mult $s7, $t0
mflo $t1
add $t2, $s0, $t1

lw $t0, 12($s1)			# Cargamos el color rosa del array
sw $t0, 0($t2)			# Se guarda el color del lazo en la posicion correspondiente



colision_lazo:
lw $s4, x_k			
lw $s5, y_k
li $t9, 16
mult  $s5, $t9
mflo $t5
add $t5, $t5, $s4		# Calculo casilla jugador

bne $s7, $t5, eliminar_cuerpo	# Se comprueba si la casilla del jugador y la del lazo son iguales, si lo son, se aumenta la longitud

lw $s3, longitud
addi $s3, $s3, 1
sw $s3, longitud		# Se guarda la nueva longitud

addi $t4, $s3, -2          	# $s3 ya es longitud nueva, así que el anterior es -2
bltz $t4, skip_copy        	# Si era la primera (no hay anterior), no se copia

add $t5, $s2, $t4         	# Dirección de la posición anterior
lbu $t6, 0($t5)           	# Cargar valor de la posición anterior

add $t7, $s2, $s3          	# Dirección de la nueva posición 
addi $t7, $t7, -1          	# Apunta al nuevo segmento
sb $t6, 0($t7)             	# Guardar copia en el nuevo segmento

skip_copy:
				# Donde estaba el lazo se pinta azul (se borra)
li $t3, 4
mult $s7, $t3
mflo $t4
add $t5, $s0, $t4
lw $t6, 0($s1)       		# color azul
sw $t6, 0($t5)

add $t0, $s3, $s2	
sb $zero, 0($t0)		# Se borran los datos de la casilla situada fuera del limite de la longitud

jal generar_lazo

j dibujar_personaje

eliminar_cuerpo:
				# Cargar la longitud
lw $t0, longitud       		
addi $t0, $t0, -1

				# Acceder a la posición justo después del último segmento
add $t1, $s2, $t0     	 	# Dirección del byte que queremos pintar
lbu $t2, 0($t1)         	


				# Calcular dirección en el framebuffer (4 bytes por píxel)
li $t3, 4
mult $t2, $t3
mflo $t4               		# Offset dentro del framebuffer

add $t5, $s0, $t4      		# Dirección real en framebuffer para pintar

				# Pintar la celda con el color de fondo (azul)
lw $t6, 0($s1)         		# Color azul (primer color de 'colores')
sw $t6, 0($t5)         		# Guardar el color en la posición correspondiente

dibujar_personaje:
la $s0, frameBuffer
move $t0, $s2			# $t0 apunta al inicio del array de posiciones
lw $t1, longitud		# Copia de la longitud
lw $t2, 4($s1)			# Carga de color rojo

bucle_dibujo:
beqz $t1, fin_dibujo 		# Cuando el índice de longitud llega a 0, acaba el bucle

lbu $t3, 0($t0)			# Cargamos en $t3 el numero de celda actual
li $t4, 4
mult $t3, $t4 			# Calculamos el offset de la casilla
mflo $t5
add $t6, $s0, $t5 		# Calculamos la dirección
sw $t2, 0($t6) 			# Pintamos la posicion con el rojo

addi $t0, $t0, 1      		# Avanzar al siguiente byte de posiciones
addi $t1, $t1, -1     		# Decrementar longitud

j bucle_dibujo

fin_dibujo:

delay:
				# Delay de 100 ms para que el juego vaya a una velocidad manejable
li $v0, 32 			
li $a0, 100
syscall

j main_loop

end:
li $v0,10
syscall

generar_lazo:
li $v0, 42       		# syscall para número aleatorio
li $a1, 14       		# Genera número entre 0 y 13
syscall
addi $a0, $a0, 1
move $t0, $a0

li $v0, 42       		# syscall para número aleatorio
li $a1, 14       		# Genera número entre 0 y 13
syscall
addi $a0, $a0, 1
move $t1, $a0

li $t9, 16
mult  $t1, $t9
mflo $t1
add $s7, $t1, $t0		# Calculo casilla lazo

sw $s7, lazo

jr $ra


	

	

	


    
