
extends Node2D


func _ready() -> void:
	add_to_group("pagina")

	# Evitar que reaparezcan páginas recogidas o colocadas
	var id = obtener_id()

	if PlayerData.paginas_en_mano.has(id) or PlayerData.paginas_colocadas.has(id):
		queue_free()


# ==========================================
# IDENTIFICADOR ÚNICO
# ==========================================

func obtener_id() -> String:
	return str(get_tree().current_scene.get_path_to(self))


# ==========================================
# RECOGER PÁGINA
# ==========================================

func recoger(jugador: Node) -> void:

	var id = obtener_id()

	if jugador.paginas_en_mano.has(id):
		return

	if PlayerData.paginas_colocadas.has(id):
		return

	jugador.paginas_en_mano.append(id)

	# Sincronizar y guardar el inventario
	PlayerData.paginas_en_mano = jugador.paginas_en_mano.duplicate()
	PlayerData.guardar_progreso()

	print("Página recogida: ", id)
	print("Páginas en mano: ", jugador.paginas_en_mano.size())

	queue_free()
