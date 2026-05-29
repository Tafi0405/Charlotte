extends CharacterBody2D

@export var walk_speed: float = 350.0
@export var run_speed: float = 600.0

func _physics_process(_delta: float) -> void:
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
