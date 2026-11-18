
extends Node2D

signal libro_completo

@export var total_paginas: int = 3

# Visuales de las páginas colocadas
@export var visuales_paginas: Array[Node2D] = []

var paginas_colocadas: Array = []


func _ready() -> void:
	add_to_group("libro")

	# Recuperar siempre las páginas guardadas
	paginas_colocadas = PlayerData.paginas_colocadas.duplicate()

	_actualizar_visuales()


# ==========================================
# COMPROBAR SI ESTÁ COMPLETO
# ==========================================

func esta_completo() -> bool:
	return paginas_colocadas.size() >= total_paginas


# ==========================================
# COLOCAR PÁGINAS
# ==========================================

func colocar_paginas(jugador: Node) -> bool:

	if esta_completo() or jugador.paginas_en_mano.is_empty():
		return false

	var paginas_transferidas = 0

	while not jugador.paginas_en_mano.is_empty() and not esta_completo():

		var pagina_id = jugador.paginas_en_mano.pop_front()

		if not paginas_colocadas.has(pagina_id):
			paginas_colocadas.append(pagina_id)
			paginas_transferidas += 1

	if paginas_transferidas <= 0:
		return false

	print("Libro: ", paginas_colocadas.size(), "/", total_paginas)

	# Actualizar los datos persistentes
	PlayerData.paginas_colocadas = paginas_colocadas.duplicate()
	PlayerData.paginas_en_mano = jugador.paginas_en_mano.duplicate()

	# Actualizar los visuales
	_actualizar_visuales()

	# Guardar checkpoint en la posición actual de Charlotte
	PlayerData.guardar_checkpoint(jugador)

	# Comprobar si el libro está completo
	if esta_completo():
		libro_completo.emit()

	return true


# ==========================================
# ACTUALIZAR VISUALES
# ==========================================

func _actualizar_visuales() -> void:

	for i in visuales_paginas.size():

		if is_instance_valid(visuales_paginas[i]):
			visuales_paginas[i].visible = i < paginas_colocadas.size()
