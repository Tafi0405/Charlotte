extends CanvasLayer

func _ready():
	hide() # El menú empieza oculto al iniciar el juego

func _unhandled_input(event):
	# "ui_cancel" es la tecla Escape por defecto en Godot
	if event.is_action_pressed("ui_cancel"):
		toggle_pausa()

func toggle_pausa():
	# Invierte el estado actual de la pausa
	get_tree().paused = not get_tree().paused
	
	# Muestra u oculta el menú según el estado de la pausa
	visible = get_tree().paused

# Esto se ejecutará al pulsar el botón Continuar
func _on_boton_continuar_pressed():
	toggle_pausa()

# Esto se ejecutará al pulsar el botón Salir
func _on_boton_salir_pressed():
	get_tree().quit() # Cierra el juego por completo


func _on_botón_continuar_pressed() -> void:
	pass # Replace with function body.


func _on_botón_salir_pressed() -> void:
	pass # Replace with function body.
