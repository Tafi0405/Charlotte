extends CharacterBody2D

@export var walk_speed: float = 350.0
@export var run_speed: float = 600.0

@export var maxHealth: int = 100
var currentHealth: int

@export var maxToxicity: int = 100
var currentToxicity: float = 0

var toxicityTimer: float = 0.0

# Tiempo necesario para perder 1 punto de salud
@export var walk_health_interval: float = 5.0
@export var run_health_interval: float = 2.5

var healthTimer: float = 0.0

signal healthChange
signal toxicityChange

# ==========================================
# OBJETO DE EQUILIBRIO
# ==========================================

var objeto_equilibrio = null


func _ready():
	add_to_group("player")
	
	currentHealth = maxHealth
	currentToxicity = 0
	
	currentHealth = PlayerData.health
	currentToxicity = PlayerData.toxicity


func _physics_process(delta: float) -> void:

	# ==========================================
	# MOVIMIENTO
	# ==========================================

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
	var is_running = false
	
	if Input.is_key_pressed(KEY_SHIFT):
		current_speed = run_speed
		is_running = true
	
	
	if direction != Vector2.ZERO:
		direction = direction.normalized()
	
	
	velocity = direction * current_speed
	move_and_slide()


	# ==========================================
	# INTERACCIÓN
	# ==========================================

	if Input.is_action_just_pressed("InteractuarSister"):

		# Si ya tiene un objeto, lo suelta
		if objeto_equilibrio != null:
			soltar_objeto()

		# Si no tiene uno, intenta recogerlo
		else:
			buscar_objeto()


	# ==========================================
	# SALUD
	# ==========================================

	if direction != Vector2.ZERO:
		healthTimer += delta
		
		var interval = walk_health_interval
		
		if is_running:
			interval = run_health_interval
		
		if healthTimer >= interval:
			healthTimer = 0.0
			currentHealth -= 1
			healthChange.emit()
			
			print("Salud:", currentHealth)
			
			if currentHealth <= 0:
				die()


	# ==========================================
	# TOXICIDAD
	# ==========================================

	if currentToxicity > 0:
		toxicityTimer += delta
		
		if toxicityTimer >= 600.0:
			toxicityTimer = 0.0
			currentToxicity -= 1
			
			if currentToxicity < 0:
				currentToxicity = 0
			
			toxicityChange.emit()


# ==========================================
# BUSCAR OBJETO
# ==========================================

func buscar_objeto():

	# Busca todos los objetos de equilibrio
	var objetos = get_tree().get_nodes_in_group("objeto_equilibrio")

	for objeto in objetos:

		# Distancia entre jugador y objeto
		var distancia = global_position.distance_to(objeto.global_position)

		# Distancia máxima para recogerlo
		if distancia <= 150.0:

			objeto_equilibrio = objeto
			
			objeto.agarrar(self)

			print("Objeto agarrado")

			return


# ==========================================
# SOLTAR OBJETO
# ==========================================

func soltar_objeto():

	if objeto_equilibrio != null:

		objeto_equilibrio.soltar()

		print("Objeto soltado")

		objeto_equilibrio = null


# ==========================================
# SALUD
# ==========================================

func add_toxicity(amount: float):
	currentToxicity = min(currentToxicity + amount, maxToxicity)
	toxicityChange.emit()
	
	if currentToxicity >= maxToxicity:
		overDose()


func die():
	print("Charlotte descendió a la locura...")


func overDose():
	print("Charlotte sufrió una sobredosis")
	get_tree().quit()


func save_data():
	PlayerData.health = currentHealth
	PlayerData.toxicity = currentToxicity


func _on_teleporter_body_entere(body: Node2D) -> void:
	pass
