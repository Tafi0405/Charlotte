
extends Control


func _on_tb_niv_1_pressed() -> void:
	if PlayerData.nivel_desbloqueado(1):
		get_tree().change_scene_to_file("res://Scenes/pafu.tscn")


func _on_tb_niv_2_pressed() -> void:
	if PlayerData.nivel_desbloqueado(2):
		get_tree().change_scene_to_file("res://Scenes/piso.tscn")


func _on_tb_niv_3_pressed() -> void:
	if PlayerData.nivel_desbloqueado(3):
		get_tree().change_scene_to_file("")


func _on_tb_niv_4_pressed() -> void:
	if PlayerData.nivel_desbloqueado(4):
		get_tree().change_scene_to_file("")


func _on_b_atras_pressed() -> void:
	get_tree().change_scene_to_file("res://menu_principal.tscn")
