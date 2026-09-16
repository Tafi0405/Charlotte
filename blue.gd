extends Control



func _on_BNivel2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/pafu.tscn")


func _on_BNivel1_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/piso.tscn")


func _on_b_atras_pressed() -> void:
	get_tree().change_scene_to_file("res://menu_principal.tscn")
