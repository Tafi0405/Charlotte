extends CharacterBody2D

var Charlotte = null
var move = Vector2.ZERO
@export var vel = 150 # Es buena práctica usar @export para ajustar la velocidad desde el editor

func _physics_process(delta: float) -> void:
	move = Vector2.ZERO
	
	if Charlotte != null:
		# Usamos global_position para evitar errores si los nodos están dentro de carpetas/padres distintos
		move = global_position.direction_to(Charlotte.global_position)
	else:
		move = Vector2.ZERO
	
	# normalized() ya no es estrictamente necesario porque direction_to() devuelve un vector normalizado, 
	# pero lo multiplicamos por la velocidad y por delta para move_and_collide
	var movimiento_final = move * vel * delta
	
	# move_and_collide modifica el movimiento directamente con física de colisiones
	move_and_collide(movimiento_final)
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	# Validamos que el cuerpo que entra sea exactamente tu jugadora
	if body.name == "charlotte" or body.name == "Charlotte": 
		Charlotte = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	# Si el cuerpo que sale es el que estábamos persiguiendo, lo olvidamos
	if body == Charlotte:
		Charlotte = null
