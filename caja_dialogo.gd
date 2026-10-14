extends CanvasLayer

signal opcion_seleccionada(numero_opcion: int)

# Agregamos PanelDialogo/ antes de TextoDialogo porque está dentro del Panel
@onready var panel: Panel = $PanelDialogo
@onready var texto_label: RichTextLabel = $PanelDialogo/TextoDialogo
@onready var opciones_container: VBoxContainer = $PanelDialogo/OpcionesContainer
@onready var boton1: Button = $PanelDialogo/OpcionesContainer/BotonOpcion1
@onready var boton2: Button = $PanelDialogo/OpcionesContainer/BotonOpcion2

func _ready() -> void:
	panel.hide()
	boton1.pressed.connect(_on_boton_1_pressed)
	boton2.pressed.connect(_on_boton_2_pressed)

func mostrar_texto(texto: String) -> void:
	panel.show()
	texto_label.text = texto
	opciones_container.hide()

func mostrar_opciones(texto_pregunta: String, texto_opcion1: String, texto_opcion2: String) -> void:
	panel.show()
	texto_label.text = texto_pregunta
	boton1.text = texto_opcion1
	boton2.text = texto_opcion2
	opciones_container.show()

func ocultar() -> void:
	panel.hide()

func _on_boton_1_pressed() -> void:
	opcion_seleccionada.emit(1)

func _on_boton_2_pressed() -> void:
	opcion_seleccionada.emit(2)
