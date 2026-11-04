extends Area2D

func _ready() -> void:
	monitoring = true
	body_entered.connect(_on_body_entered)

	print("CHECKPOINT CARGADO: ", get_path())


func _on_body_entered(body: Node2D) -> void:
	print("CHECKPOINT DETECTÓ UN CUERPO: ", body.name)

	if not body.is_in_group("player"):
		print("El cuerpo detectado no pertenece al grupo player.")
		return

	PlayerData.health = body.currentHealth
	PlayerData.toxicity = body.currentToxicity
	PlayerData.posicion_guardada = body.global_position
	PlayerData.escena_guardada = get_tree().current_scene.scene_file_path

	PlayerData.guardar_progreso()

	print("CHECKPOINT GUARDADO: ", body.global_position)
