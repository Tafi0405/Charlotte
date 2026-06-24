extends Area2D

@export var next_scene_path: String


func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		
		body.save_data()
		
		get_tree().change_scene_to_file(next_scene_path)
