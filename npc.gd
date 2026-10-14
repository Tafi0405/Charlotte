extends StaticBody2D

@export var caja_dialogo_scene: PackedScene
var caja_dialogo_instancia = null

var player_in_range: bool = false
var in_conversation: bool = false
var fase_dialogo: int = 0

func _ready() -> void:
	if caja_dialogo_scene:
		caja_dialogo_instancia = caja_dialogo_scene.instantiate()
		add_child(caja_dialogo_instancia)
		caja_dialogo_instancia.opcion_seleccionada.connect(_on_opcion_seleccionada)

func interactuar_con_npc() -> void:
	if not in_conversation:
		in_conversation = true
		fase_dialogo = 1
		caja_dialogo_instancia.mostrar_opciones(
			"¡Hola Charlotte! ¿Buscas algo?",
			"1. Buscar medicina",
			"2. Solo explorar"
		)

func _on_opcion_seleccionada(opcion: int) -> void:
	if fase_dialogo == 1:
		if opcion == 1:
			caja_dialogo_instancia.mostrar_texto("NPC: Ten cuidado con la toxicidad.")
		elif opcion == 2:
			caja_dialogo_instancia.mostrar_texto("NPC: Explora con precaución.")
		
		fase_dialogo = 0
		in_conversation = false
		await get_tree().create_timer(2.5).timeout
		if not in_conversation:
			caja_dialogo_instancia.ocultar()
