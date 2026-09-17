extends StaticBody2D

var player_in_range: bool = false
var in_conversation: bool = false

# Referencia al nodo Label que acabas de crear
@onready var texto_flotante = $Label

func _ready() -> void:
	# Ocultamos el texto al iniciar el juego
	texto_flotante.hide()

func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		texto_flotante.text = "Presiona 'E' para hablar"
		texto_flotante.show()

func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		in_conversation = false
		texto_flotante.hide()

func interactuar_con_npc() -> void:
	if not in_conversation:
		in_conversation = true
		# Usamos \n para hacer un salto de línea
		texto_flotante.text = "¡Hola Charlotte! ¿Buscas algo?\n[1] Ayuda   [2] Irme"
		texto_flotante.show()

func responder(opcion: int) -> void:
	if not in_conversation:
		return
		
	if opcion == 1:
		texto_flotante.text = "Entendido, aquí tienes."
	elif opcion == 2:
		texto_flotante.text = "Entiendo, cuídate."
	
	in_conversation = false
