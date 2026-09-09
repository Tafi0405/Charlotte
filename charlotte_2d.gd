extends CharacterBody2D

# =========================
# MOVIMIENTO
# =========================
@export var velocidad := 250.0
@export var aceleracion := 1200.0
@export var friccion := 1500.0

# =========================
# SALTO
# =========================
@export var fuerza_salto := 450.0
@export var gravedad := 1200.0

# Permite controlar cuánto se corta el salto
# cuando soltamos el botón.
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
		velocity.x = move_toward(
			velocity.x,
			direccion * velocidad,
			aceleracion * delta
		)
	else:
		velocity.x = move_toward(
			velocity.x,
			0,
			friccion * delta
		)


	# =========================
	# SALTO
	# =========================
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = -fuerza_salto


	# =========================
	# SALTO CORTO
	# =========================
	if Input.is_action_just_released("ui_accept") and velocity.y < 0:
		velocity.y = move_toward(
			velocity.y,
			0,
			gravedad_salto_corto * delta
		)


	# =========================
	# MOVER PERSONAJE
	# =========================
	move_and_slide()
