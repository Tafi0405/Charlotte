extends Node

var health: int = 100
var toxicity: float = 0

var nivel_1_completado: bool = false

# Datos del checkpoint
var posicion_guardada: Vector2 = Vector2.ZERO
var escena_guardada: String = ""

# Estado de páginas y libro en el checkpoint
var paginas_en_mano: Array = []
var paginas_colocadas: Array = []


func _ready() -> void:
	cargar_progreso()


# ==========================================
# ¿EL CHECKPOINT PERTENECE A LA ESCENA ACTUAL?
# ==========================================

func hay_checkpoint_en_escena() -> bool:
	var escena = get_tree().current_scene
	return escena != null and escena_guardada != "" and escena_guardada == escena.scene_file_path


# ==========================================
# GUARDAR PROGRESO
# ==========================================

func guardar_progreso() -> void:

	var datos = {
		"nivel_1_completado": nivel_1_completado,
		"health": health,
		"toxicity": toxicity,
		"posicion_x": posicion_guardada.x,
		"posicion_y": posicion_guardada.y,
		"escena": escena_guardada,
		"paginas_en_mano": paginas_en_mano,
		"paginas_colocadas": paginas_colocadas
	}

	var archivo = FileAccess.open("user://progreso.json", FileAccess.WRITE)

	if archivo == null:
		push_error("No se pudo guardar el progreso.")
		return

	archivo.store_string(JSON.stringify(datos))
	archivo.close()

	print("Progreso guardado correctamente.")


# ==========================================
# CARGAR PROGRESO
# ==========================================

func cargar_progreso() -> void:

	if not FileAccess.file_exists("user://progreso.json"):
		print("No existe un progreso guardado.")
		return

	var archivo = FileAccess.open("user://progreso.json", FileAccess.READ)

	if archivo == null:
		push_error("No se pudo leer el progreso.")
		return

	var datos = JSON.parse_string(archivo.get_as_text())
	archivo.close()

	if datos is Dictionary:

		nivel_1_completado = datos.get("nivel_1_completado", false)

		health = datos.get("health", 100)
		toxicity = datos.get("toxicity", 0)

		posicion_guardada = Vector2(
			float(datos.get("posicion_x", 0.0)),
			float(datos.get("posicion_y", 0.0))
		)

		escena_guardada = datos.get("escena", "")

		paginas_en_mano = datos.get("paginas_en_mano", [])
		paginas_colocadas = datos.get("paginas_colocadas", [])

		print("Progreso cargado correctamente.")
		print("Posición: ", posicion_guardada)
		print("Escena: ", escena_guardada)
