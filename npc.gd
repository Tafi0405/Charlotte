extends StaticBody2D

@export var npc_id: String = "npc_1" # Identificador en el JSON
@export var caja_dialogo_scene: PackedScene = preload("res://caja_dialogo.tscn")
var caja_dialogo_instancia = null

var in_conversation: bool = false
var fase_actual: String = "fase_1"
var datos_dialogos: Dictionary = {}

func _ready() -> void:
	cargar_json_dialogos()
	
	if caja_dialogo_scene:
		caja_dialogo_instancia = caja_dialogo_scene.instantiate()
		add_child(caja_dialogo_instancia)
		caja_dialogo_instancia.opcion_seleccionada.connect(_on_opcion_seleccionada)

func cargar_json_dialogos() -> void:
	# Cambiamos la ruta a dialogo_1.json para que apunte al archivo nuevo
	if FileAccess.file_exists("res://json/dialogo_1.json"):
		var archivo = FileAccess.open("res://json/dialogo_1.json", FileAccess.READ)
		var json = JSON.new()
		var resultado = json.parse(archivo.get_as_text())
		if resultado == OK:
			datos_dialogos = json.get_data()
		else:
			print("Error al analizar el JSON de diálogos.")
	else:
		print("No se encontró el archivo dialogo_1.json en res://")

func interactuar_con_npc() -> void:
	if caja_dialogo_instancia == null or datos_dialogos.is_empty():
		return

	if not in_conversation:
		in_conversation = true
		fase_actual = "fase_1"
		mostrar_fase_actual()

func mostrar_fase_actual() -> void:
	if not datos_dialogos.has(npc_id) or not datos_dialogos[npc_id].has(fase_actual):
		return
		
	var nodo_fase = datos_dialogos[npc_id][fase_actual]
	
	# Si es un nodo final (solo texto sin opciones)
	if nodo_fase.has("es_final") and nodo_fase["es_final"]:
		caja_dialogo_instancia.mostrar_texto(nodo_fase["texto"])
		await get_tree().create_timer(3.0).timeout
		in_conversation = false
		caja_dialogo_instancia.ocultar()
	else:
		# Muestra la pregunta y los dos botones con texto del JSON
		caja_dialogo_instancia.mostrar_opciones(
			nodo_fase["texto"],
			nodo_fase["opcion_1_texto"],
			nodo_fase["opcion_2_texto"]
		)

func _on_opcion_seleccionada(opcion: int) -> void:
	if not in_conversation:
		return
		
	var nodo_fase = datos_dialogos[npc_id][fase_actual]
	
	if opcion == 1:
		fase_actual = nodo_fase["opcion_1_siguiente"]
	elif opcion == 2:
		fase_actual = nodo_fase["opcion_2_siguiente"]
		
	mostrar_fase_actual()
