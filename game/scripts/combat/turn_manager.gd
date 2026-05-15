## turn_manager.gd
## Gestiona el orden de turnos.
## El orden viene de FormationManager (formación del partido), no de tiradas de iniciativa.

class_name TurnManager
extends Node

# ============================================================
# SEÑALES
# ============================================================
signal turn_order_set(order: Array)

# ============================================================
# ESTADO
# ============================================================
var _turn_queue: Array[BaseCharacter] = []
var _current_index: int = 0

# ============================================================
# API PÚBLICA
# ============================================================

## Recibe el orden ya calculado por FormationManager.build_full_turn_order().
func set_turn_order(ordered_characters: Array[BaseCharacter]) -> void:
	_turn_queue = ordered_characters.filter(func(c: BaseCharacter) -> bool: return c.is_alive())
	_current_index = 0
	turn_order_set.emit(_turn_queue)

## Devuelve el siguiente personaje vivo, o null si la ronda terminó.
func get_next_character() -> BaseCharacter:
	while _current_index < _turn_queue.size():
		var character := _turn_queue[_current_index]
		_current_index += 1
		if character.is_alive():
			return character
	return null

func is_round_over() -> bool:
	return _current_index >= _turn_queue.size()

func restart_round() -> void:
	_current_index = 0

func get_turn_order() -> Array[BaseCharacter]:
	return _turn_queue

func get_current_index() -> int:
	return _current_index
