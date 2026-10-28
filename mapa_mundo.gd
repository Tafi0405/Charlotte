
extends Control


func _ready() -> void:
	PlayerData.cargar_progreso()


func _on_tb_niv_1_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/pafu.tscn")


func _on_tb_niv_2_pressed() -> void:
	if PlayerData.nivel_1_completado:
		get_tree().change_scene_to_file("res://Scenes/piso.tscn")
	else:
		print("Primero debes completar el nivel 1.")


func _on_tb_niv_3_pressed() -> void:
	pass


func _on_tb_niv_4_pressed() -> void:
	pass


func _on_b_atras_pressed() -> void:
	get_tree().change_scene_to_file("res://menu_principal.tscn")
