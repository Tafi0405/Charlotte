extends Area2D

# Coordenadas exactas a las que quieres enviar al jugador
@export var destino: Vector2 = Vector2(-1809.0, -1453.0)

func _ready():
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body):
	if body.is_in_group("player"):
		# Cambiamos la posición global del jugador al destino
		body.global_position = destino
