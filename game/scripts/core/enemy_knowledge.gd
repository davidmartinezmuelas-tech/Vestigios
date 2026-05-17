## enemy_knowledge.gd
## Rastrea qué sabe el jugador sobre cada tipo de enemigo.
## El conocimiento se gana en combate, por investigación o por rumores.
##
## NIVELES DE CONOCIMIENTO:
##   0 — Desconocido: solo nombre y HP actual visible
##   1 — Avistado: AC conocida, rango de HP conocido
##   2 — Familiar: habilidades conocidas al verlas usar
##   3 — Estudiado: resistencias, inmunidades y todas las habilidades

class_name EnemyKnowledge
extends RefCounted

enum KnowledgeLevel { UNKNOWN, SIGHTED, FAMILIAR, STUDIED }

## Clave: enemy_id  |  Valor: Dictionary con lo que se sabe
var _knowledge: Dictionary = {}

# ============================================================
# API PÚBLICA — GANAR CONOCIMIENTO
# ============================================================

## Llama esto al avistar a un tipo de enemigo por primera vez en combate.
func sight_enemy(enemy_id: String) -> void:
	if not _knowledge.has(enemy_id):
		_knowledge[enemy_id] = _empty_entry()
	var entry: Dictionary = _knowledge[enemy_id]
	if entry["level"] < KnowledgeLevel.SIGHTED:
		entry["level"] = KnowledgeLevel.SIGHTED

## Llama esto cuando un enemigo usa una habilidad en combate.
func reveal_ability(enemy_id: String, ability_id: String, ability_name: String) -> void:
	_ensure_entry(enemy_id)
	var entry: Dictionary = _knowledge[enemy_id]
	if ability_id not in entry["known_abilities"]:
		entry["known_abilities"][ability_id] = ability_name
	if entry["level"] < KnowledgeLevel.FAMILIAR:
		entry["level"] = KnowledgeLevel.FAMILIAR

## Llama esto al completar una investigación (Library/Trophy Room).
func study_enemy(enemy_id: String, resistances: Array[String], weaknesses: Array[String]) -> void:
	_ensure_entry(enemy_id)
	var entry: Dictionary = _knowledge[enemy_id]
	entry["known_resistances"] = resistances.duplicate()
	entry["known_weaknesses"]  = weaknesses.duplicate()
	entry["level"] = KnowledgeLevel.STUDIED

## Llama esto cuando el Pub revela información sobre un enemigo específico.
func reveal_rumor(enemy_id: String, hint: String) -> void:
	_ensure_entry(enemy_id)
	_knowledge[enemy_id]["rumors"].append(hint)
	if _knowledge[enemy_id]["level"] < KnowledgeLevel.SIGHTED:
		_knowledge[enemy_id]["level"] = KnowledgeLevel.SIGHTED

# ============================================================
# API PÚBLICA — CONSULTAR
# ============================================================

func get_level(enemy_id: String) -> KnowledgeLevel:
	return _knowledge.get(enemy_id, _empty_entry())["level"]

func is_known(enemy_id: String) -> bool:
	return _knowledge.has(enemy_id) and _knowledge[enemy_id]["level"] > KnowledgeLevel.UNKNOWN

func get_known_abilities(enemy_id: String) -> Dictionary:
	return _knowledge.get(enemy_id, _empty_entry())["known_abilities"]

func get_known_resistances(enemy_id: String) -> Array:
	return _knowledge.get(enemy_id, _empty_entry())["known_resistances"]

func get_known_weaknesses(enemy_id: String) -> Array:
	return _knowledge.get(enemy_id, _empty_entry())["known_weaknesses"]

func get_rumors(enemy_id: String) -> Array:
	return _knowledge.get(enemy_id, _empty_entry())["rumors"]

# ============================================================
# SERIALIZACIÓN
# ============================================================

func to_dict() -> Dictionary:
	return _knowledge.duplicate(true)

func from_dict(data: Dictionary) -> void:
	_knowledge = data.duplicate(true)

# ============================================================
# INTERNO
# ============================================================

func _ensure_entry(enemy_id: String) -> void:
	if not _knowledge.has(enemy_id):
		_knowledge[enemy_id] = _empty_entry()

func _empty_entry() -> Dictionary:
	return {
		"level":             KnowledgeLevel.UNKNOWN,
		"known_abilities":   {},
		"known_resistances": [],
		"known_weaknesses":  [],
		"rumors":            [],
	}
