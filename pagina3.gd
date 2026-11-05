extends Node2D


func _ready() -> void:
	add_to_group("pagina")

	# Si ya fue recogida o colocada antes del checkpoint, no reaparece
	if PlayerData.hay_checkpoint_en_escena():
		var id = obtener_id()
		if PlayerData.paginas_en_mano.has(id) or PlayerData.paginas_colocadas.has(id):
			queue_free()


# ID único: ruta del nodo relativa a la escena
# (cada página debe tener un nombre distinto: Pagina1, Pagina2, Pagina3)
func obtener_id() -> String:
	return str(get_tree().current_scene.get_path_to(self))


func recoger(jugador: Node) -> void:
	jugador.paginas_en_mano.append(obtener_id())
	print("Página recogida: ", obtener_id())
	queue_free()   # el objeto desaparece
