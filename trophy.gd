extends RigidBody2D

@export var altura_cabeza := 60.0
@export var inclinacion_maxima := 30.0
@export var velocidad_inclinacion := 5.0
@export var tiempo_respawn := 1.0

var posicion_inicial: Vector2
var jugador = null
var agarrado := false


func _ready():

	add_to_group("objeto_equilibrio")

	posicion_inicial = global_position

	# El objeto comienza quieto
	freeze = true


func _physics_process(delta):

	if agarrado and jugador != null:

		# ==========================================
		# POSICIÓN SOBRE LA CABEZA
		# ==========================================

		global_position = jugador.global_position \
			+ Vector2(0, -altura_cabeza)


		# ==========================================
		# EQUILIBRIO
		# ==========================================

		var movimiento = jugador.velocity.x

		var inclinacion_objetivo = movimiento / 10.0

		inclinacion_objetivo = clamp(
			inclinacion_objetivo,
			-inclinacion_maxima,
			inclinacion_maxima
		)

		rotation = lerp_angle(
			rotation,
			deg_to_rad(inclinacion_objetivo),
			velocidad_inclinacion * delta
		)


		# ==========================================
		# PERDIÓ EL EQUILIBRIO
		# ==========================================

		if abs(rad_to_deg(rotation)) >= inclinacion_maxima:
			soltar()


# ==========================================
# AGARRAR
# ==========================================

func agarrar(personaje):

	jugador = personaje
	agarrado = true

	# El objeto se vuelve rígido
	freeze = true

	# Detener completamente la física
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0

	# ==========================================
	# DESACTIVAR COLISIÓN
	# ==========================================

	$CollisionShape2D.set_deferred(
		"disabled",
		true
	)

	# Colocarlo sobre la cabeza
	global_position = jugador.global_position \
		+ Vector2(0, -altura_cabeza)

	rotation = 0.0

	print("Objeto agarrado")


# ==========================================
# SOLTAR
# ==========================================

func soltar():

	if not agarrado:
		return

	agarrado = false
	jugador = null

	# Volver a activar colisión
	$CollisionShape2D.set_deferred(
		"disabled",
		false
	)

	# Reactivar física
	freeze = false

	linear_velocity = Vector2(0, 50)
	angular_velocity = 2.0

	print("Objeto soltado")

	# Esperar antes del respawn
	await get_tree().create_timer(
		tiempo_respawn
	).timeout

	respawnear()


# ==========================================
# RESPAWN
# ==========================================

func respawnear():

	global_position = posicion_inicial

	rotation = 0.0

	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0

	freeze = true

	print("Objeto respawneado")
