extends Node3D

# ==============================================================================
# SCRIPT PRINCIPAL DEL MUNDO Y GESTOR DE PERSONAJES Y CAMARAS
# ==============================================================================
# Este script se encarga de:
# 1. Gestionar el menu de seleccion de personajes en la interfaz de usuario (UI).
# 2. Activar el movimiento del personaje elegido y desactivar a los demas.
# 3. Controlar los modos de camara: Primera Persona (1ra) y Tercera Persona (3ra).
# 4. Permitir alternar de camara con la tecla V / C, rueda del raton o boton UI.
# 5. Ocultar la malla del personaje activo en 1ra persona para evitar obstrucciones visuales.
# 6. Gestionar la captura y liberacion del cursor del raton (ESC para liberar).

# Referencias a los nodos de personajes en la escena
@onready var personajes: Array[CharacterBody3D] = [
	$Crash_Clasico_Personaje,
	$Trish_DMC1_Personaje,
	$Crash_Skeleton_Personaje,
	$Katamari_Personaje,
	$Crash_Tag_Team_Personaje,
	$Crash_Nitro_Kart_Personaje
]

# Referencia a la camara principal de la escena
@onready var camara: Camera3D = $Camera3D

# Referencia a los elementos de la interfaz de usuario
@onready var etiqueta_activo: Label = $UI/PanelMenu/VBox/LabelActivo
@onready var boton_camara: Button = $UI/PanelMenu/VBox/HBoxBotones/BotonCambiarCamara

# Indice del personaje actualmente seleccionado (inicia en 0: Crash Clasico)
var indice_seleccionado: int = 0

# Estado del modo de camara: true = Primera Persona, false = Tercera Persona
var modo_primera_persona: bool = false

# Parametros de configuracion para la camara orbital (3ra persona)
var distancia_camara: float = 4.2
var distancia_camara_objetivo: float = 4.2
var altura_objetivo_3ra: float = 1.0
var sensibilidad_raton: float = 0.003
var rotacion_yaw: float = 0.0
var rotacion_pitch: float = deg_to_rad(-15.0)
var suavidad_camara: float = 12.0

func _ready() -> void:
	# Capturamos el cursor del raton al iniciar el juego
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# Seleccionamos al primer personaje por defecto
	seleccionar_personaje(0)
	
	# Actualizamos la interfaz del boton de camara
	actualizar_interfaz_camara()

func _unhandled_input(event: InputEvent) -> void:
	# --------------------------------------------------------------------------
	# 1. ROTACION DE CAMARA CON MOVIMIENTO DEL RATON
	# --------------------------------------------------------------------------
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotacion_yaw -= event.relative.x * sensibilidad_raton
		rotacion_pitch -= event.relative.y * sensibilidad_raton

		# Definimos los limites verticales de giro (pitch)
		var min_pitch: float = deg_to_rad(-85.0) if modo_primera_persona else deg_to_rad(-60.0)
		var max_pitch: float = deg_to_rad(85.0) if modo_primera_persona else deg_to_rad(45.0)
		rotacion_pitch = clamp(rotacion_pitch, min_pitch, max_pitch)

	# --------------------------------------------------------------------------
	# 2. ZOOM CON LA RUEDA DEL RATON (Cambio dinamico entre 1ra y 3ra persona)
	# --------------------------------------------------------------------------
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			# Rueda hacia arriba: Acercar camara
			if not modo_primera_persona:
				distancia_camara_objetivo -= 0.6
				# Si acercamos al maximo, entramos automaticamente a Primera Persona
				if distancia_camara_objetivo < 1.2:
					activar_primera_persona(true)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			# Rueda hacia abajo: Alejar camara
			if modo_primera_persona:
				# Si estamos en Primera Persona y alejamos la rueda, pasamos a Tercera Persona
				activar_primera_persona(false)
				distancia_camara_objetivo = 2.0
			else:
				distancia_camara_objetivo = clamp(distancia_camara_objetivo + 0.6, 1.5, 9.0)

	# --------------------------------------------------------------------------
	# 3. ATAJO DE TECLADO PARA CAMBIAR DE MODO DE CAMARA (Teclas V o C)
	# --------------------------------------------------------------------------
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_V or event.keycode == KEY_C:
			alternar_modo_camara()

	# --------------------------------------------------------------------------
	# 4. GESTION DEL CURSOR (ESC para liberar, Clic para recapturar)
	# --------------------------------------------------------------------------
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if event is InputEventMouseButton and event.pressed and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float) -> void:
	# --------------------------------------------------------------------------
	# ATAJOS DE TECLADO RAPIDOS PARA CAMBIAR DE PERSONAJE (Teclas 1 al 6)
	# --------------------------------------------------------------------------
	if Input.is_key_pressed(KEY_1):
		seleccionar_personaje(0)
	elif Input.is_key_pressed(KEY_2):
		seleccionar_personaje(1)
	elif Input.is_key_pressed(KEY_3):
		seleccionar_personaje(2)
	elif Input.is_key_pressed(KEY_4):
		seleccionar_personaje(3)
	elif Input.is_key_pressed(KEY_5):
		seleccionar_personaje(4)
	elif Input.is_key_pressed(KEY_6):
		seleccionar_personaje(5)

	# --------------------------------------------------------------------------
	# PROCESAMIENTO DE LA CAMARA EN EL MODO ACTIVO
	# --------------------------------------------------------------------------
	if indice_seleccionado >= 0 and indice_seleccionado < personajes.size():
		var objetivo: CharacterBody3D = personajes[indice_seleccionado]
		if is_instance_valid(objetivo):
			if modo_primera_persona:
				# ==============================================================
				# MODO PRIMERA PERSONA (1ra Persona)
				# ==============================================================
				# Obtenemos la altura de los ojos configurada en el personaje
				var alt_ojos: float = objetivo.altura_ojos if "altura_ojos" in objetivo else 1.3
				var pos_ojos: Vector3 = objetivo.global_position + Vector3(0.0, alt_ojos, 0.0)

				# Ubicamos la camara directamente en la posicion de los ojos
				camara.global_position = pos_ojos

				# Calculamos el vector frontal hacia donde mira el jugador
				var dir_mirada: Vector3 = Vector3(
					-sin(rotacion_yaw) * cos(rotacion_pitch),
					sin(rotacion_pitch),
					-cos(rotacion_yaw) * cos(rotacion_pitch)
				)

				# Orientamos la camara hacia el punto de mira
				camara.look_at(pos_ojos + dir_mirada, Vector3.UP)
			else:
				# ==============================================================
				# MODO TERCERA PERSONA (3ra Persona)
				# ==============================================================
				# Suavizamos la distancia de la camara (zoom)
				distancia_camara = lerp(distancia_camara, distancia_camara_objetivo, 10.0 * delta)

				# Punto central de enfoque sobre el personaje
				var punto_objetivo: Vector3 = objetivo.global_position + Vector3(0.0, altura_objetivo_3ra, 0.0)

				# Calculamos el desplazamiento esferico orbital
				var offset: Vector3 = Vector3(
					sin(rotacion_yaw) * cos(rotacion_pitch),
					-sin(rotacion_pitch),
					cos(rotacion_yaw) * cos(rotacion_pitch)
				) * distancia_camara

				var posicion_deseada: Vector3 = punto_objetivo + offset

				# Interpolamos suavemente la posicion de la camara
				camara.global_position = camara.global_position.lerp(posicion_deseada, suavidad_camara * delta)

				# Apuntamos la camara hacia el personaje
				camara.look_at(punto_objetivo, Vector3.UP)

# ------------------------------------------------------------------------------
# GESTION DE MODOS DE CAMARA
# ------------------------------------------------------------------------------
func alternar_modo_camara() -> void:
	activar_primera_persona(not modo_primera_persona)

func activar_primera_persona(activar: bool) -> void:
	modo_primera_persona = activar
	
	if modo_primera_persona:
		# En primera persona ajustamos los limites de angulo vertical
		rotacion_pitch = clamp(rotacion_pitch, deg_to_rad(-85.0), deg_to_rad(85.0))
	else:
		# En tercera persona restauramos la distancia por defecto si estaba en cero
		if distancia_camara_objetivo < 1.5:
			distancia_camara_objetivo = 4.2
		rotacion_pitch = clamp(rotacion_pitch, deg_to_rad(-60.0), deg_to_rad(45.0))

	# Actualizamos la visibilidad de los modelos 3D y el texto del boton
	actualizar_visibilidad_mallas()
	actualizar_interfaz_camara()

func actualizar_visibilidad_mallas() -> void:
	# En primera persona, ocultamos la malla del personaje seleccionado para que no tape la vista.
	# En tercera persona, todas las mallas permanecen visibles.
	for i in range(personajes.size()):
		var p: CharacterBody3D = personajes[i]
		if is_instance_valid(p):
			var mesh_node: Node = p.get_node_or_null("MeshInstance3D")
			if is_instance_valid(mesh_node):
				if i == indice_seleccionado and modo_primera_persona:
					mesh_node.visible = false
				else:
					mesh_node.visible = true

func actualizar_interfaz_camara() -> void:
	if is_instance_valid(boton_camara):
		if modo_primera_persona:
			boton_camara.text = "Vista: 1ra Persona (V)"
		else:
			boton_camara.text = "Vista: 3ra Persona (V)"

# ------------------------------------------------------------------------------
# SELECCION DE PERSONAJES
# ------------------------------------------------------------------------------
func seleccionar_personaje(nuevo_indice: int) -> void:
	if nuevo_indice < 0 or nuevo_indice >= personajes.size():
		return

	indice_seleccionado = nuevo_indice

	# Recorremos la lista de personajes: activamos solo el seleccionado y desactivamos los demas
	for i in range(personajes.size()):
		var p: CharacterBody3D = personajes[i]
		if is_instance_valid(p):
			p.esta_activo = (i == indice_seleccionado)

	# Actualizamos la visibilidad del modelo segun el modo de camara actual
	actualizar_visibilidad_mallas()

	# Actualizamos la etiqueta de la interfaz de usuario
	var p_activo: CharacterBody3D = personajes[indice_seleccionado]
	if is_instance_valid(etiqueta_activo) and is_instance_valid(p_activo):
		etiqueta_activo.text = "Controlando a: " + p_activo.nombre_personaje

# ------------------------------------------------------------------------------
# CONEXIONES DE LOS BOTONES DE LA INTERFAZ (UI)
# ------------------------------------------------------------------------------
func _on_boton_crash_clasico_pressed() -> void:
	seleccionar_personaje(0)

func _on_boton_trish_pressed() -> void:
	seleccionar_personaje(1)

func _on_boton_crash_skeleton_pressed() -> void:
	seleccionar_personaje(2)

func _on_boton_katamari_pressed() -> void:
	seleccionar_personaje(3)

func _on_boton_crash_tag_team_pressed() -> void:
	seleccionar_personaje(4)

func _on_boton_crash_nitro_kart_pressed() -> void:
	seleccionar_personaje(5)

func _on_boton_cambiar_camara_pressed() -> void:
	alternar_modo_camara()
