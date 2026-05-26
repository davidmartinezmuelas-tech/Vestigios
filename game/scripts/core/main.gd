## main.gd
## OBSOLETO — main_scene es main_menu.tscn directamente (ver project.godot).
## Este script ya no se usa como punto de entrada. Se conserva por compatibilidad
## con main.tscn pero NO debe hacer change_scene ni lógica de arranque.

extends Node

func _ready() -> void:
	push_warning("main.gd: este nodo no deberia estar activo. Verificar main_scene en project.godot.")
