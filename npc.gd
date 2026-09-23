extends StaticBody2D

var player_in_range: bool = false
var in_conversation: bool = false
var esperando_respuesta: bool = false
var procesando_cambio: bool = false # Seguro contra ejecuciones continuas

var fase_dialogo: int = 0
var eleccion_previa: int = 0

var dialogos_inicio: Array = [
	"¡Hola Charlotte! Qué bueno verte.",
	"¿Necesitas algo en particular?"
]
var indice_dialogo: int = 0

@onready var texto_flotante = $Label

func _ready() -> void:
	texto_flotante.hide()

func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		if not in_conversation:
			texto_flotante.text = "Presiona 'E' para hablar"
			texto_flotante.show()

func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		in_conversation = false
		esperando_respuesta = false
		procesando_cambio = false
		indice_dialogo = 0
		fase_dialogo = 0
		texto_flotante.hide()

func interactuar_con_npc() -> void:
	if esperando_respuesta or procesando_cambio:
		return

	if not in_conversation:
		in_conversation = true
		indice_dialogo = 0
		fase_dialogo = 1

	if fase_dialogo == 1:
		if indice_dialogo < dialogos_inicio.size():
			texto_flotante.text = dialogos_inicio[indice_dialogo]
			texto_flotante.show()
			indice_dialogo += 1
		else:
			texto_flotante.text = "[1] Buscar medicina   [2] Solo explorar"
			esperando_respuesta = true

func responder(opcion: int) -> void:
	if not in_conversation or not esperando_respuesta or procesando_cambio:
		return

	# Bloqueamos interacciones consecutivas en el mismo instante
	procesando_cambio = true
	
	if fase_dialogo == 1:
		eleccion_previa = opcion
		esperando_respuesta = false
		
		if opcion == 1:
			texto_flotante.text = "NPC: La toxicidad es alta aquí...\n¿Quieres un antídoto?\n[1] Sí, por favor   [2] No, estoy bien"
		elif opcion == 2:
			texto_flotante.text = "NPC: Hay zonas peligrosas cerca.\n¿Quieres un consejo?\n[1] Dame un consejo   [2] Seguir solo"
			
		fase_dialogo = 2
		# Breve espera para asegurar que la tecla fue soltada antes de la siguiente fase
		await get_tree().create_timer(0.2).timeout
		esperando_respuesta = true

	elif fase_dialogo == 2:
		esperando_respuesta = false
		
		if eleccion_previa == 1:
			if opcion == 1:
				texto_flotante.text = "NPC: Toma esto. Te ayudará."
			elif opcion == 2:
				texto_flotante.text = "NPC: De acuerdo. Si te sientes mal, avísame."
		elif eleccion_previa == 2:
			if opcion == 1:
				texto_flotante.text = "NPC: Evita el área oeste, hay trampas."
			elif opcion == 2:
				texto_flotante.text = "NPC: Mucha suerte en tu camino."

		in_conversation = false
		fase_dialogo = 0
		ocultar_texto_con_retraso()

	procesando_cambio = false

func ocultar_texto_con_retraso() -> void:
	await get_tree().create_timer(3.0).timeout
	if not in_conversation:
		texto_flotante.hide()
