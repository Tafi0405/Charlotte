extends Control

@onready var slider_musica: HSlider = $PanelContainer/VBoxContainer/HSliderMusica
@onready var slider_sfx: HSlider = $PanelContainer/VBoxContainer/HSliderSFX
@onready var checkbox_fullscreen: CheckBox = $PanelContainer/VBoxContainer/CheckBoxFullscreen
@onready var btn_cerrar: Button = $PanelContainer/VBoxContainer/BotonCerrar

@onready var grid_controles: GridContainer = $PanelContainer/VBoxContainer/GridContainer

@onready var mapa_botones: Dictionary = {
	"ui_up": grid_controles.get_node("BotonRebindArriba"),
	"ui_down": grid_controles.get_node("BotonRebindAbajo"),
	"ui_left": grid_controles.get_node("BotonRebindIzquierda"),
	"ui_right": grid_controles.get_node("BotonRebindDerecha"),
	"interactuar": grid_controles.get_node("BotonRebindInteractuar"),
	"correr": grid_controles.get_node("BotonRebindCorrer")
}

var bus_musica_idx: int
var bus_sfx_idx: int
var accion_a_remapear: String = ""

# Ruta donde se guardará el archivo de configuración
const RUTA_CONFIG = "user://config.cfg"

func _ready() -> void:
	bus_musica_idx = AudioServer.get_bus_index("Musica")
	bus_sfx_idx = AudioServer.get_bus_index("SFX")
	
	slider_musica.min_value = 0.0001
	slider_musica.max_value = 1.0
	slider_sfx.min_value = 0.0001
	slider_sfx.max_value = 1.0
	
	# 1. Cargar configuraciones guardadas al iniciar
	_cargar_configuracion()
	
	# Conectar señales de audio
	slider_musica.value_changed.connect(_on_musica_value_changed)
	slider_sfx.value_changed.connect(_on_sfx_value_changed)
	
	# Conectar pantalla completa
	checkbox_fullscreen.toggled.connect(_on_fullscreen_toggled)
	
	# Conectar botones de remapeo
	for accion in mapa_botones:
		var boton: Button = mapa_botones[accion]
		if boton != null:
			boton.pressed.connect(func(): _iniciar_remapeo(accion, boton))
	
	btn_cerrar.pressed.connect(_on_cerrar_pressed)
	_actualizar_texto_botones()

func _on_musica_value_changed(val: float) -> void:
	AudioServer.set_bus_volume_db(bus_musica_idx, linear_to_db(val))
	_guardar_configuracion() # Guardar automáticamente al cambiar

func _on_sfx_value_changed(val: float) -> void:
	AudioServer.set_bus_volume_db(bus_sfx_idx, linear_to_db(val))
	_guardar_configuracion() # Guardar automáticamente al cambiar

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	_guardar_configuracion() # Guardar automáticamente al cambiar

func _iniciar_remapeo(accion: String, boton: Button) -> void:
	accion_a_remapear = accion
	boton.text = "Presiona una tecla..."

func _input(event: InputEvent) -> void:
	if accion_a_remapear != "" and event is InputEventKey and event.is_pressed():
		InputMap.action_erase_events(accion_a_remapear)
		InputMap.action_add_event(accion_a_remapear, event)
		
		accion_a_remapear = ""
		_actualizar_texto_botones()
		_guardar_configuracion() # Guardar automáticamente al remapear
		get_viewport().set_input_as_handled()

func _actualizar_texto_botones() -> void:
	for accion in mapa_botones:
		var boton: Button = mapa_botones[accion]
		if boton != null:
			boton.text = _obtener_nombre_tecla(accion)

func _obtener_nombre_tecla(accion: String) -> String:
	if not InputMap.has_action(accion):
		return "Sin acción"
	var eventos = InputMap.action_get_events(accion)
	if eventos.size() > 0:
		return OS.get_keycode_string(eventos[0].get_physical_keycode_with_modifiers()) if eventos[0].physical_keycode != 0 else eventos[0].as_text()
	return "Sin tecla"

# --- FUNCIONES DE GUARDADO Y CARGA ---

func _guardar_configuracion() -> void:
	var config = ConfigFile.new()
	
	# 1. Guardar Audio
	config.set_value("audio", "musica", slider_musica.value)
	config.set_value("audio", "sfx", slider_sfx.value)
	
	# 2. Guardar Pantalla Completa
	config.set_value("video", "fullscreen", checkbox_fullscreen.button_pressed)
	
	# 3. Guardar Controles (InputMap)
	for accion in mapa_botones:
		var eventos = InputMap.action_get_events(accion)
		if eventos.size() > 0:
			# Guardamos el evento como dato serializable (InputEvent)
			config.set_value("controles", accion, eventos[0])
			
	config.save(RUTA_CONFIG)

func _cargar_configuracion() -> void:
	var config = ConfigFile.new()
	var err = config.load(RUTA_CONFIG)
	
	if err != OK:
		# Si no existe el archivo aún, cargamos valores por defecto razonables
		slider_musica.value = db_to_linear(AudioServer.get_bus_volume_db(bus_musica_idx))
		slider_sfx.value = db_to_linear(AudioServer.get_bus_volume_db(bus_sfx_idx))
		checkbox_fullscreen.set_pressed_no_signal(false)
		return
		
	# 1. Cargar Audio
	var vol_musica = config.get_value("audio", "musica", 1.0)
	slider_musica.value = vol_musica
	AudioServer.set_bus_volume_db(bus_musica_idx, linear_to_db(vol_musica))
	
	var vol_sfx = config.get_value("audio", "sfx", 1.0)
	slider_sfx.value = vol_sfx
	AudioServer.set_bus_volume_db(bus_sfx_idx, linear_to_db(vol_sfx))
	
	# 2. Cargar Pantalla Completa
	var es_fullscreen = config.get_value("video", "fullscreen", false)
	checkbox_fullscreen.set_pressed_no_signal(es_fullscreen)
	if es_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
	# 3. Cargar Controles
	for accion in mapa_botones:
		if config.has_section_key("controles", accion):
			var evento_guardado = config.get_value("controles", accion)
			if evento_guardado is InputEvent:
				InputMap.action_erase_events(accion)
				InputMap.action_add_event(accion, evento_guardado)

func _on_cerrar_pressed() -> void:
	get_tree().change_scene_to_file("res://menu_principal.tscn")
