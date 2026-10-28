
extends Node

var health := 100
var toxicity := 0

# Nivel más alto al que se permite acceder.
# Al comenzar una partida, solo se desbloquea el nivel 1.
var nivel_maximo_desbloqueado: int = 1


func completar_nivel(nivel: int) -> void:
	nivel_maximo_desbloqueado = max(
		nivel_maximo_desbloqueado,
		nivel + 1
	)


func nivel_desbloqueado(nivel: int) -> bool:
	return nivel <= nivel_maximo_desbloqueado
