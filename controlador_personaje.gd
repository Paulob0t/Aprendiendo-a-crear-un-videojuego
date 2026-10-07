extends CharacterBody3D

# ==============================================================================
# SCRIPT DE MOVIMIENTO Y CONTROL DE PERSONAJES (CharacterBody3D)
# ==============================================================================
# Este script se encarga de controlar las fisicas y el movimiento en 3D de cada personaje.
# Soporta movimiento en 4 direcciones (WASD / Flechas), salto, gravedad, rotacion automatica,
# y acciones de apuntar y disparar.
# La variable 'esta_activo' define si el jugador tiene el control de este personaje.

# Velocidad de movimiento del personaje (en metros por segundo)
@export var velocidad: float = 6.0

# Fuerza del salto hacia arriba
@export var fuerza_salto: float = 5.0

# Nombre que se mostrara en el menu / interfaz
@export var nombre_personaje: String = "Personaje"

# Altura de los ojos para la vista en primera persona (en metros)
@export var altura_ojos: float = 1.3

# Indica si este personaje esta seleccionado actualmente para ser controlado
@export var esta_activo: bool = false

# Obtenemos la gravedad configurada en el motor de Godot (9.8 m/s2)
var gravedad: float = ProjectSettings.get_setting("physics/3d/default_gravity", 9.8)

func _physics_process(delta: float) -> void:
	# --------------------------------------------------------------------------
	# 1. APLICACION DE GRAVEDAD
	# --------------------------------------------------------------------------
	# Si el personaje no esta tocando el suelo, aplicamos la gravedad restando en el eje Y
	if not is_on_floor():
		velocity.y -= gravedad * delta

	# --------------------------------------------------------------------------
	# 2. CONTROL DE ENTRADAS Y MOVIMIENTO (Solo si esta activo)
	# --------------------------------------------------------------------------
	if esta_activo:
		# Salto: Se activa al presionar la barra espaciadora o la accion 'ui_accept'
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = fuerza_salto

		# Obtenemos el vector de movimiento 2D de las teclas presionadas
		# (ui_left: A / Flecha Izq, ui_right: D / Flecha Der, ui_up: W / Flecha Arriba, ui_down: S / Flecha Abajo)
		var input_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

		# Calculamos la direccion de movimiento 3D relativa a la orientacion de la camara activa
		var direccion: Vector3 = Vector3.ZERO
		var camara_actual: Camera3D = get_viewport().get_camera_3d()

		if camara_actual:
			# Obtenemos el vector frontal de la camara proyectado en el plano horizontal (X, Z)
			var cam_frente: Vector3 = -camara_actual.global_transform.basis.z
			cam_frente.y = 0.0
			cam_frente = cam_frente.normalized()

			# Obtenemos el vector lateral derecho de la camara proyectado en el plano horizontal (X, Z)
			var cam_derecha: Vector3 = camara_actual.global_transform.basis.x
			cam_derecha.y = 0.0
			cam_derecha = cam_derecha.normalized()

			# Calculamos la direccion resultante: W/S mueven adelante/atras de la vista, A/D mueven lateralmente
			# Nota: input_dir.y es negativo hacia adelante (W) y positivo hacia atras (S)
			direccion = (cam_derecha * input_dir.x + cam_frente * -input_dir.y).normalized()
		else:
			# Respaldo global si no hay camara 3D activa
			direccion = Vector3(input_dir.x, 0.0, input_dir.y).normalized()

		if direccion != Vector3.ZERO:
			# Asignamos la velocidad en los ejes X y Z
			velocity.x = direccion.x * velocidad
			velocity.z = direccion.z * velocidad

			# Rotacion suave: Hacemos que el personaje gire mirando hacia la direccion hacia donde se traslada
			var angulo_objetivo: float = atan2(direccion.x, direccion.z)
			rotation.y = lerp_angle(rotation.y, angulo_objetivo, 12.0 * delta)
		else:
			# Si soltamos las teclas, el personaje desacelera suavemente hasta frenar
			velocity.x = move_toward(velocity.x, 0.0, velocidad * 8.0 * delta)
			velocity.z = move_toward(velocity.z, 0.0, velocidad * 8.0 * delta)

		# ----------------------------------------------------------------------
		# 3. ACCIONES DE APUNTAR Y DISPARAR
		# ----------------------------------------------------------------------
		# Click Derecho: Apuntar
		if Input.is_action_pressed("apuntar"):
			print(nombre_personaje, ": apuntando")

		# Click Izquierdo: Disparar
		if Input.is_action_just_pressed("disparar"):
			print(nombre_personaje, ": pium pium")
	else:
		# Si el personaje NO esta seleccionado, desaceleramos a 0 en X y Z para que se quede quieto
		velocity.x = move_toward(velocity.x, 0.0, velocidad * 8.0 * delta)
		velocity.z = move_toward(velocity.z, 0.0, velocidad * 8.0 * delta)

	# --------------------------------------------------------------------------
	# 4. EJECUTAR FISICAS DE MOVIMIENTO
	# --------------------------------------------------------------------------
	# move_and_slide() procesa automaticamente las colisiones con el piso, paredes y otros personajes
	move_and_slide()
