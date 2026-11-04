
extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:

	if not body.is_in_group("player"):
		return

	# Guardar estadísticas
	PlayerData.health = body.currentHealth
	PlayerData.toxicity = body.currentToxicity

	# Guardar posición y escena
	PlayerData.posicion_guardada = body.global_position
	PlayerData.escena_guardada = get_tree().current_scene.scene_file_path

	# Guardar permanentemente
	PlayerData.guardar_progreso()

	print("CHECKPOINT ACTIVADO")
	print("Nueva posición: ", body.global_position)
