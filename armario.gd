
extends Area2D

@export var sprite_cerrado: Texture2D
@export var sprite_abierto: Texture2D

@onready var sprite: Sprite2D = $Sprite2D

var jugador_cerca := false
var abierto := false

func _ready():
	sprite.texture = sprite_cerrado
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(_delta):
	if jugador_cerca and Input.is_action_just_pressed("ui_accept"):
		cambiar_estado()

func cambiar_estado():
	abierto = !abierto

	if abierto:
		sprite.texture = sprite_abierto
	else:
		sprite.texture = sprite_cerrado

func _on_body_entered(body):
	if body is CharacterBody2D:
		jugador_cerca = true

func _on_body_exited(body):
	if body is CharacterBody2D:
		jugador_cerca = false
