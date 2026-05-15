## formation_manager.gd
## Gestiona el orden del partido en exploración y lo pasa al combate.
## El orden aquí ES el orden de turno en combate (sin tiradas de iniciativa).

extends Node

# ============================================================
# SEÑALES
# ============================================================
signal formation_changed(order: Array[String])

# ============================================================
# ESTADO
## Array de character_ids en orden de formación (índice 0 = frente)
# ============================================================
var _formation: Array[String] = []

# ============================================================
# API PÚBLICA — FORMACIÓN
# ============================================================

func set_formation(character_ids: Array[String]) -> void:
	_formation = character_ids.duplicate()
	formation_changed.emit(_formation)

func get_formation() -> Array[String]:
	return _formation.duplicate()

func swap(index_a: int, index_b: int) -> void:
	if index_a < 0 or index_b < 0:
		return
	if index_a >= _formation.size() or index_b >= _formation.size():
		return
	var tmp := _formation[index_a]
	_formation[index_a] = _formation[index_b]
	_formation[index_b] = tmp
	formation_changed.emit(_formation)

func move_to_front(character_id: String) -> void:
	var idx := _formation.find(character_id)
	if idx <= 0:
		return
	_formation.remove_at(idx)
	_formation.insert(0, character_id)
	formation_changed.emit(_formation)

func get_front() -> String:
	return _formation[0] if not _formation.is_empty() else ""

func get_back() -> String:
	return _formation[-1] if not _formation.is_empty() else ""

# ============================================================
# API PÚBLICA — COMBATE
# ============================================================

## Devuelve el orden de turno para el combate.
## surprised = true → orden invertido (el fondo queda expuesto al frente)
func get_combat_order(surprised: bool = false) -> Array[String]:
	var order := _formation.duplicate()
	if surprised:
		order.reverse()
	return order

## Construye la cola de turno mezclando héroes (en orden de formación)
## con enemigos intercalados según su posición inicial en el mapa.
## heroes y enemies son Arrays de BaseCharacter.
func build_full_turn_order(
	heroes: Array[BaseCharacter],
	enemies: Array[BaseCharacter],
	surprised: bool = false
) -> Array[BaseCharacter]:
	var hero_order := get_combat_order(surprised)

	# Ordenar héroes según la formación
	var sorted_heroes: Array[BaseCharacter] = []
	for character_id in hero_order:
		for hero in heroes:
			if hero.data and hero.data.character_id == character_id:
				sorted_heroes.append(hero)
				break

	# Héroes que no estén en la formación (por si acaso) van al final
	for hero in heroes:
		if not sorted_heroes.has(hero):
			sorted_heroes.append(hero)

	# Intercalar enemigos: un enemigo por cada héroe, resto al final
	# El orden exacto de enemigos lo define el diseñador de la sala
	var result: Array[BaseCharacter] = []
	var max_size := maxi(sorted_heroes.size(), enemies.size())
	for i in max_size:
		if i < sorted_heroes.size():
			result.append(sorted_heroes[i])
		if i < enemies.size():
			result.append(enemies[i])

	return result
