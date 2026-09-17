extends StaticBody2D  # <- Asegúrate de que esta línea esté así

var player_in_range: bool = false
var in_conversation: bool = false

func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		print("[NPC]: Charlotte está cerca.")

func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		in_conversation = false
		print("[NPC]: Charlotte se alejó.")

# ESTA ES LA FUNCIÓN QUE CHARLOTTE BUSCABA:
func interactuar_con_npc() -> void:
	if not in_conversation:
		in_conversation = true
		print("\n--- CONVERSACIÓN INICIADA ---")
		print("NPC: ¡Hola Charlotte! ¿Buscas algo?")
		print("Presiona [1] para responder | Presiona [2] para alejarte")
	else:
		print("NPC: Sigo esperando tu respuesta...")

func responder(opcion: int) -> void:
	if not in_conversation:
		return
		
	if opcion == 1:
		print("\nCharlotte: Necesito ayuda...")
		print("NPC: Entendido, aquí tienes.")
	elif opcion == 2:
		print("\nCharlotte: No tengo tiempo para esto.")
		print("NPC: Entiendo, cuídate.")
	
	in_conversation = false
	print("--- CONVERSACIÓN FINALIZADA ---")
