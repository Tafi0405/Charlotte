extends CharacterBody2D

# =========================
# MOVIMIENTO
# =========================
@export var velocidad := 750.0

# =========================
# SALTO
# =========================
@export var fuerza_salto := 1200.0
@export var gravedad := 1200.0
@export var gravedad_salto_corto := 1800.0


func _physics_process(delta):

	# =========================
	# GRAVEDAD
	# =========================
	if not is_on_floor():
		velocity.y += gravedad * delta


	# =========================
	# MOVIMIENTO HORIZONTAL
	# =========================
	var direccion := Input.get_axis("ui_left", "ui_right")

	if direccion != 0:
		velocity.x = direccion * velocidad
	else:
		velocity.x = 0


	# =========================
	# SALTO
	# =========================
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = -fuerza_salto


	# =========================
	# SALTO CORTO
	# =========================
	if Input.is_action_just_released("ui_accept") and velocity.y < 0:
		velocity.y = 0


	# =========================
	# MOVIMIENTO
	# =========================
	move_and_slide()
