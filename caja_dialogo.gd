extends CanvasLayer

signal opcion_seleccionada(numero_opcion: int)

@onready var panel: Panel = $PanelDialogo
@onready var texto_label: RichTextLabel = $PanelDialogo/TextoDialogo
@onready var opciones_container: HBoxContainer = $PanelDialogo/OpcionesContainer
@onready var boton1: Button = $PanelDialogo/OpcionesContainer/BotonOpcion1
@onready var boton2: Button = $PanelDialogo/OpcionesContainer/BotonOpcion2

var tween_texto: Tween = null
@export var velocidad_escritura: float = 0.03

# Variables de control para adelantar y saltear
var texto_completado: bool = false
var saltear_todo: bool = false

func _ready() -> void:
	panel.hide()
	boton1.pressed.connect(_on_boton_1_pressed)
	boton2.pressed.connect(_on_boton_2_pressed)
	
	boton1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	boton2.size_flags_horizontal = Control.SIZE_EXPAND_FILL

func _unhandled_input(event: InputEvent) -> void:
	if not panel.visible:
		return
		
	# Detectamos la tecla de avance (puedes usar ui_accept o la tecla de interacción "E")
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("interactuar"):
		# Si se presiona Escape, se activa el salteo completo
		if Input.is_key_pressed(KEY_ESCAPE):
			saltear_todo = true
			if tween_texto and tween_texto.is_running():
				tween_texto.kill()
			ocultar()
			return

		# Si el texto aún se está escribiendo, lo adelantamos al instante
		if tween_texto and tween_texto.is_running():
			tween_texto.kill()
			texto_label.visible_characters = -1 # -1 Muestra todo el texto de golpe
			texto_completado = true

# Muestra texto plano (finales de diálogo) con soporte para adelantar/saltear
func mostrar_texto(texto: String) -> bool:
	panel.show()
	opciones_container.hide()
	await _escribir_texto(texto)
	return saltear_todo

# Muestra pregunta y opciones
func mostrar_opciones(texto_pregunta: String, texto_opcion1: String, texto_opcion2: String) -> bool:
	panel.show()
	opciones_container.hide()
	
	boton1.text = texto_opcion1
	boton2.text = texto_opcion2
	
	await _escribir_texto(texto_pregunta)
	
	if not saltear_todo:
		opciones_container.show()
		
	return saltear_todo

func _escribir_texto(texto: String) -> void:
	if saltear_todo:
		return

	texto_completado = false
	texto_label.text = texto
	texto_label.visible_characters = 0
	
	var total_caracteres = texto.length()
	tween_texto = create_tween()
	tween_texto.tween_property(texto_label, "visible_characters", total_caracteres, total_caracteres * velocidad_escritura)
	
	# Espera a que termine la animación o a que el jugador la adelante
	while tween_texto and tween_texto.is_running() and not texto_completado and not saltear_todo:
		await get_tree().process_frame

func ocultar() -> void:
	panel.hide()
	saltear_todo = false

func _on_boton_1_pressed() -> void:
	opcion_seleccionada.emit(1)

func _on_boton_2_pressed() -> void:
	opcion_seleccionada.emit(2)
