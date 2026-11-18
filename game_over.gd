extends Control

var causa_texto: String = ""

func _ready() -> void:
	# Busca automáticamente cualquier RichTextLabel dentro de esta escena
	var texto_causa = get_node_or_null("CanvasLayer/ColorRect/PanelContainer/RichTextLabel")
	
	if texto_causa:
		texto_causa.text = causa_texto
	else:
		print("Error: Revisa bien los nombres de los nodos en tu escena GameOver.tscn")
func _on_b_volver_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/pafu.tscn")

func _on_b_lobby_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu_principal.tscn")
