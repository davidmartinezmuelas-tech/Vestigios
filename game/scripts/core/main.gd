## main.gd
## Punto de entrada del juego. Decide si mostrar el menú principal o cargar partida.

extends Node

func _ready() -> void:
	# Conectar señales globales de guardado
	SaveManager.save_completed.connect(_on_save_completed)
	SaveManager.load_completed.connect(_on_load_completed)

	# Ir al menú principal
	GameManager.go_to_scene("res://scenes/core/main_menu.tscn")

func _on_save_completed(slot: int) -> void:
	print("Partida guardada en slot %d" % slot)

func _on_load_completed(slot: int) -> void:
	print("Partida cargada desde slot %d" % slot)
