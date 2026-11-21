extends Area2D

@onready var dibujo_grande: TextureRect = $CanvasLayer/TextureRect
var jugador_cerca: bool = false

func _ready() -> void:
	# Nos aseguramos de que el dibujo grande empiece oculto
	dibujo_grande.visible = false

func _process(_delta: float) -> void:
	# Si el jugador está cerca y presiona la tecla de interactuar
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		# Abre el dibujo si está cerrado, o lo cierra si ya está abierto
		dibujo_grande.visible = !dibujo_grande.visible

func _on_body_entered(body: Node2D) -> void:
	# Verifica que quien se acercó sea el jugador
	if body.is_in_group("player"):
		jugador_cerca = true

func _on_body_exited(body: Node2D) -> void:
	# Si el jugador se aleja, cerramos el dibujo automáticamente
	if body.is_in_group("player"):
		jugador_cerca = false
		dibujo_grande.visible = false
