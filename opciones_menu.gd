extends Control

@onready var slider_musica: HSlider = $PanelContainer/VBoxContainer/HSliderMusica
@onready var slider_sfx: HSlider = $PanelContainer/VBoxContainer/HSliderSFX
@onready var btn_rebind_izq: Button = $PanelContainer/VBoxContainer/GridContainer/BotonRebindIzquierda
@onready var btn_rebind_der: Button = $PanelContainer/VBoxContainer/GridContainer/BotonRebindDerecha
@onready var btn_cerrar: Button = $PanelContainer/VBoxContainer/BotonCerrar
@onready var checkbox_fullscreen: CheckBox = $PanelContainer/VBoxContainer/CheckBoxFullscreen

var bus_musica_idx: int
var bus_sfx_idx: int
var accion_a_remapear: String = ""

const RESOLUCIONES = {
	0: Vector2i(854, 480),   # 480p
	1: Vector2i(1280, 720),  # 720p
	2: Vector2i(1920, 1080)  # 1080p
}

func _ready() -> void:
	bus_musica_idx = AudioServer.get_bus_index("Musica")
	bus_sfx_idx = AudioServer.get_bus_index("SFX")
	
	slider_musica.min_value = 0.0001
	slider_musica.max_value = 1.0
	slider_sfx.min_value = 0.0001
	slider_sfx.max_value = 1.0
	
	slider_musica.value = db_to_linear(AudioServer.get_bus_volume_db(bus_musica_idx))
	slider_sfx.value = db_to_linear(AudioServer.get_bus_volume_db(bus_sfx_idx))
	
	# Sincronizar el estado inicial del CheckBox con el modo actual de la ventana
	var es_pantalla_completa = (get_window().mode == Window.MODE_FULLSCREEN or get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN)
	checkbox_fullscreen.set_pressed_no_signal(es_pantalla_completa)	
	# Conectar señales
	slider_musica.value_changed.connect(_on_musica_value_changed)
	slider_sfx.value_changed.connect(_on_sfx_value_changed)
	btn_rebind_izq.pressed.connect(func(): _iniciar_remapeo("ui_left", btn_rebind_izq))
	btn_rebind_der.pressed.connect(func(): _iniciar_remapeo("ui_right", btn_rebind_der))
	btn_cerrar.pressed.connect(_on_cerrar_pressed)
		
	# NUEVO: Conectar la señal toggled del CheckBox
	checkbox_fullscreen.toggled.connect(_on_fullscreen_toggled)
	
	_actualizar_texto_botones()

func _on_resolucion_selected(index: int) -> void:
	if RESOLUCIONES.has(index):
		var nueva_resolucion = RESOLUCIONES[index]
		get_window().size = nueva_resolucion
		get_tree().root.content_scale_size = nueva_resolucion

# NUEVO: Función para alternar el modo de pantalla completa
func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		get_window().mode = Window.MODE_FULLSCREEN
	else:
		get_window().mode = Window.MODE_WINDOWED

func _on_musica_value_changed(val: float) -> void:
	AudioServer.set_bus_volume_db(bus_musica_idx, linear_to_db(val))

func _on_sfx_value_changed(val: float) -> void:
	AudioServer.set_bus_volume_db(bus_sfx_idx, linear_to_db(val))

func _iniciar_remapeo(accion: String, boton: Button) -> void:
	accion_a_remapear = accion
	boton.text = "Presiona una tecla..."

func _input(event: InputEvent) -> void:
	if accion_a_remapear != "" and event is InputEventKey and event.is_pressed():
		InputMap.action_erase_events(accion_a_remapear)
		InputMap.action_add_event(accion_a_remapear, event)
		accion_a_remapear = ""
		_actualizar_texto_botones()
		get_viewport().set_input_as_handled()

func _actualizar_texto_botones() -> void:
	btn_rebind_izq.text = _obtener_nombre_tecla("ui_left")
	btn_rebind_der.text = _obtener_nombre_tecla("ui_right")

func _obtener_nombre_tecla(accion: String) -> String:
	var eventos = InputMap.action_get_events(accion)
	if eventos.size() > 0:
		return eventos[0].as_text()
	return "Sin tecla"

func _on_cerrar_pressed() -> void:
	get_tree().change_scene_to_file("res://menu_principal.tscn")
