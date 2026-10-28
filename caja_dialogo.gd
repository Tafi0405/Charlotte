extends CanvasLayer

signal opcion_seleccionada(numero_opcion: int)

@onready var panel: Panel = $PanelDialogo
@onready var texto_label: RichTextLabel = $PanelDialogo/TextoDialogo
@onready var opciones_container: HBoxContainer = $PanelDialogo/OpcionesContainer
@onready var boton1: Button = $PanelDialogo/OpcionesContainer/BotonOpcion1
@onready var boton2: Button = $PanelDialogo/OpcionesContainer/BotonOpcion2

# Variable para controlar la animación del texto
var tween_texto: Tween = null
@export var velocidad_escritura: float = 0.03 # Segundos por cada letra

func _ready() -> void:
	panel.hide()
	boton1.pressed.connect(_on_boton_1_pressed)
	boton2.pressed.connect(_on_boton_2_pressed)
	
	# Forzar que ambos botones se expandan equitativamente
	boton1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	boton2.size_flags_horizontal = Control.SIZE_EXPAND_FILL

# Muestra texto plano letra por letra (para finales de diálogo)
func mostrar_texto(texto: String) -> void:
	panel.show()
	opciones_container.hide()
	_escribir_texto(texto)

# Muestra pregunta letra por letra y luego activa los botones
func mostrar_opciones(texto_pregunta: String, texto_opcion1: String, texto_opcion2: String) -> void:
	panel.show()
	opciones_container.hide() # Ocultamos los botones mientras escribe
	
	boton1.text = texto_opcion1
	boton2.text = texto_opcion2
	
	# Escribe el texto y al terminar muestra los botones
	await _escribir_texto(texto_pregunta)
	opciones_container.show()

# Función interna que anima el texto letra por letra
func _escribir_texto(texto: String) -> void:
	if tween_texto and tween_texto.is_running():
		tween_texto.kill()
	
	texto_label.text = texto
	texto_label.visible_characters = 0
	
	var total_caracteres = texto.length()
	tween_texto = create_tween()
	tween_texto.tween_property(texto_label, "visible_characters", total_caracteres, total_caracteres * velocidad_escritura)
	
	# Espera a que termine de escribirse por completo
	await tween_texto.finished

func ocultar() -> void:
	panel.hide()

func _on_boton_1_pressed() -> void:
	opcion_seleccionada.emit(1)

func _on_boton_2_pressed() -> void:
	opcion_seleccionada.emit(2)
