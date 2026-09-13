extends Node3D

# ==============================================================================
# SCRIPT PRINCIPAL DEL MUNDO Y GESTOR DE SELECCION DE PERSONAJES
# ==============================================================================
# Este script se encarga de:
# 1. Gestionar el menu de seleccion de personajes en la interfaz de usuario (UI).
# 2. Activar el movimiento del personaje elegido y desactivar a los demas.
# 3. Hacer que la camara 3D siga suavemente al personaje que estemos controlando.
# 4. Permitir cambiar de personaje tanto con clics en los botones como con teclas (1 al 6).

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

# Referencia al texto en pantalla que muestra el personaje activo
@onready var etiqueta_activo: Label = $UI/PanelMenu/VBox/LabelActivo

# Indice del personaje actualmente seleccionado (inicia en 0: Crash Clasico)
var indice_seleccionado: int = 0

# Distancia (offset) de la camara detras del personaje (X=0, Y=2.2 de alto, Z=4.2 de distancia)
var offset_camara: Vector3 = Vector3(0.0, 2.2, 4.2)

func _ready() -> void:
	# Al iniciar la escena, seleccionamos al primer personaje por defecto
	seleccionar_personaje(0)

func _process(delta: float) -> void:
	# --------------------------------------------------------------------------
	# 1. ATAJOS DE TECLADO RAPIDOS (Teclas del 1 al 6)
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
	# 2. SEGUIMIENTO SUAVE DE CAMARA
	# --------------------------------------------------------------------------
	if indice_seleccionado >= 0 and indice_seleccionado < personajes.size():
		var objetivo: CharacterBody3D = personajes[indice_seleccionado]
		if is_instance_valid(objetivo):
			# Posicion a donde queremos mover la camara
			var posicion_deseada: Vector3 = objetivo.global_position + offset_camara
			# lerp() interpola la posicion actual hacia la deseada de forma suave
			camara.global_position = camara.global_position.lerp(posicion_deseada, 6.0 * delta)
			
			# Hacemos que la camara apunte hacia el pecho/cabeza del personaje (altura + 1 metro)
			var punto_a_mirar: Vector3 = objetivo.global_position + Vector3(0.0, 1.0, 0.0)
			camara.look_at(punto_a_mirar, Vector3.UP)

# ------------------------------------------------------------------------------
# FUNCION PRINCIPAL PARA SELECCIONAR UN PERSONAJE
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
