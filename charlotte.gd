extends CharacterBody2D

@export var walk_speed: float = 350.0
@export var run_speed: float = 600.0

@export var maxHealth: int = 100
var currentHealth: float

@export var healthDrainRate: float = 1.0

var healthTimer: float = 0.0

signal healthChange

func _ready():
	add_to_group("player")
	currentHealth = maxHealth

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO

	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		direction.x -= 1
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		direction.x += 1
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		direction.y -= 1
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		direction.y += 1

	var current_speed = walk_speed

	if Input.is_key_pressed(KEY_SHIFT):
		current_speed = run_speed

	if direction != Vector2.ZERO:
		direction = direction.normalized()

	velocity = direction * current_speed
	move_and_slide()

	# Sistema de desgaste de salud
	healthTimer += delta

	if healthTimer >= 1.0:
		healthTimer = 0.0
		currentHealth -= healthDrainRate
		healthChange.emit()

	if currentHealth <= 0:
		die()

func die():
	print("Charlotte descendió a la locura...")
	queue_free()
