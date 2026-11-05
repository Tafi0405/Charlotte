extends Node2D

signal libro_completo

@export var total_paginas: int = 3

# Opcional: arrastra aquí 3 nodos (Sprite2D) que se muestran al colocar cada página
@export var visuales_paginas: Array[Node2D] = []

var paginas_colocadas: Array = []


func _ready() -> void:
	add_to_group("libro")

	if PlayerData.hay_checkpoint_en_escena():
		paginas_colocadas = PlayerData.paginas_colocadas.duplicate()

	_actualizar_visuales()


func esta_completo() -> bool:
	return paginas_colocadas.size() >= total_paginas


# Devuelve true si se colocó al menos una página
func colocar_paginas(jugador: Node) -> bool:
	if esta_completo() or jugador.paginas_en_mano.is_empty():
		return false

	while not jugador.paginas_en_mano.is_empty() and not esta_completo():
		paginas_colocadas.append(jugador.paginas_en_mano.pop_front())

	print("Libro: ", paginas_colocadas.size(), "/", total_paginas)
	_actualizar_visuales()

	if esta_completo():
		libro_completo.emit()

	return true


func _actualizar_visuales() -> void:
	for i in visuales_paginas.size():
		visuales_paginas[i].visible = i < paginas_colocadas.size()
