extends RigidBody2D

@export var altura_cabeza: float = 60.0
@export var inclinacion_maxima: float = 30.0
@export var sensibilidad_equilibrio: float = 0.08
@export var velocidad_equilibrio: float = 3.0

var jugador: CharacterBody2D = null
var agarrado: bool = false
var cayendo: bool = false


func _ready():
	add_to_group("objeto_equilibrio")

	# El objeto comienza completamente estático
	freeze = true

	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0


func _physics_process(delta):

	if not agarrado:
		return

	if jugador == null:
		return

	# ==========================================
	# POSICIÓN SOBRE LA CABEZA
	# ==========================================

	global_position = jugador.global_position + Vector2(
		0,
		-altura_cabeza
	)

	# ==========================================
	# EQUILIBRIO
	# ==========================================

	var velocidad_x = jugador.velocity.x

	var inclinacion_objetivo = \
		-velocidad_x * sensibilidad_equilibrio

	inclinacion_objetivo = clamp(
		inclinacion_objetivo,
		-inclinacion_maxima,
		inclinacion_maxima
	)

	rotation = lerp_angle(
		rotation,
		deg_to_rad(inclinacion_objetivo),
		velocidad_equilibrio * delta
	)

	# ==========================================
	# COMPROBAR CAÍDA
	# ==========================================

	if abs(rad_to_deg(rotation)) >= inclinacion_maxima:
		caer()


# ==========================================
# AGARRAR
# ==========================================

func agarrar(personaje: CharacterBody2D):

	if agarrado:
		return

	if cayendo:
		return

	jugador = personaje
	agarrado = true

	# Mantenerlo estático
	freeze = true

	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0

	# Desactivar SOLO la colisión física
	$CollisionShape2D.set_deferred("disabled", true)

	# Colocarlo sobre la cabeza
	global_position = jugador.global_position + Vector2(
		0,
		-altura_cabeza
	)

	rotation = 0.0

	print("OBJETO AGARRADO")


# ==========================================
# CAER
# ==========================================

func caer():

	if not agarrado:
		return

	cayendo = true
	agarrado = false
	jugador = null

	# Reactivar colisión
	$CollisionShape2D.set_deferred("disabled", false)

	# Sigue siendo estático
	freeze = true

	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0

	print("OBJETO CAÍDO")

	await get_tree().create_timer(0.3).timeout

	cayendo = false


# ==========================================
# SOLTAR
# ==========================================

func soltar():

	if not agarrado:
		return

	agarrado = false
	jugador = null

	# El objeto queda exactamente donde está
	freeze = true

	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0

	$CollisionShape2D.set_deferred("disabled", false)

	print("OBJETO COLOCADO")
