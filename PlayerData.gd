
extends Node

var health := 100
var toxicity := 0

var nivel_1_completado: bool = false


func guardar_progreso() -> void:
	var datos = {
		"nivel_1_completado": nivel_1_completado
	}

	var archivo = FileAccess.open("user://progreso.json", FileAccess.WRITE)

	if archivo == null:
		push_error("No se pudo guardar el progreso.")
		return

	archivo.store_string(JSON.stringify(datos))
	archivo.close()


func cargar_progreso() -> void:
	if not FileAccess.file_exists("user://progreso.json"):
		return

	var archivo = FileAccess.open("user://progreso.json", FileAccess.READ)
	if archivo == null:
		return

	var datos = JSON.parse_string(archivo.get_as_text())
	archivo.close()

	if datos is Dictionary:
		nivel_1_completado = datos.get("nivel_1_completado", false)
