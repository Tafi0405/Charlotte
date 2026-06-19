extends Area2D

@export var next_scene_path: String

var changing := false

func _on_body_entered(body: Node2D) -> void:
	if changing:
		return

	if body.is_in_group("player"):
		changing = true
		get_tree().change_scene_to_file(next_scene_path)
