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

# Conecta la señal "pressed" de tu botón Continuar a esta función
func _on_botón_continuar_pressed() -> void:
	toggle_pausa()

# Conecta la señal "pressed" de tu botón Salir a esta función
func _on_botón_salir_pressed() -> void:
	print("El botón de salir funciona, intentando cerrar...")
	get_tree().quit()


func _on_button_pressed() -> void:
	pass # Replace with function body.
