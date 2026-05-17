## world_state.gd
## Estado persistente del mundo: partida activa, flags de lore, progreso.
##
## ROSTER vs PARTY:
##   _roster      → todos los personajes disponibles (hasta 6: 5 fijos + 1 custom)
##   _active_party → los que van a la misión actual (4 o 5, según la misión)
##   Los que no están en la party activa se quedan en el Bastión.

extends Node

# ============================================================
# ROSTER COMPLETO
## Array de character_id. El orden no importa aquí — FormationManager gestiona el orden.
# ============================================================
var _roster: Array[String] = []

# ============================================================
# PROTAGONISTA
## El personaje del jugador. Siempre va en misiones — no se puede dejar en el Bastión.
# ============================================================
var protagonist_id: String = ""

# ============================================================
# PARTY ACTIVA
## Subset del roster. El protagonista siempre ocupa el slot 0.
# ============================================================
var _active_party: Array[String] = []

# ============================================================
# RECURSOS
# ============================================================
var gold: int = 0

## Cofre compartido del campamento. Almacena item_ids.
## La data real de cada objeto vive en ItemDatabase / MagicItemDatabase.
var camp_chest: Array[String] = []

# ============================================================
# PROGRESO DE MUNDO
# ============================================================
var completed_dungeons: Array[String] = []
var cleared_rooms: Array[String] = []
var journal_entries: Array[String] = []

# ============================================================
# FLAGS DE LORE
# ============================================================
var lore_flags: Dictionary = {}

# ============================================================
# CONOCIMIENTO DE ENEMIGOS
# ============================================================
var enemy_knowledge: EnemyKnowledge = EnemyKnowledge.new()

# ============================================================
# CONDICIONES DE PARTY
## Efectos ambientales que dan ventaja/desventaja en habilidades concretas.
## Clave: condition_id | Valor: {type, affects_skills, label}
# ============================================================
var party_conditions: Dictionary = {}

## affects_skills: lista de habilidades afectadas.
## affects_attacks: si true, también afecta a las tiradas de ataque en combate.
func add_party_condition(condition_id: String, type: String, affects_skills: Array, label: String = "", affects_attacks: bool = false) -> void:
	party_conditions[condition_id] = {
		"type": type,
		"affects_skills": affects_skills,
		"label": label,
		"affects_attacks": affects_attacks,
	}

func remove_party_condition(condition_id: String) -> void:
	party_conditions.erase(condition_id)

func has_disadvantage_on_skill(skill_name: String) -> bool:
	for cond in party_conditions.values():
		if cond.get("type") == "disadvantage" and skill_name.to_lower() in cond.get("affects_skills", []):
			return true
	return false

func has_advantage_on_skill(skill_name: String) -> bool:
	for cond in party_conditions.values():
		if cond.get("type") == "advantage" and skill_name.to_lower() in cond.get("affects_skills", []):
			return true
	return false

func has_disadvantage_on_attacks() -> bool:
	for cond in party_conditions.values():
		if cond.get("type") == "disadvantage" and cond.get("affects_attacks", false):
			return true
	return false

func get_active_conditions() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for id in party_conditions:
		var entry := party_conditions[id].duplicate()
		entry["id"] = id
		result.append(entry)
	return result

# ============================================================
# COMBATE PENDIENTE
# ============================================================
var _pending_dungeon_id: String = ""
var _pending_room_data: Dictionary = {}

# ============================================================
# API PÚBLICA — ROSTER
# ============================================================

func add_to_roster(character_id: String) -> void:
	if character_id not in _roster and _roster.size() < Constants.MAX_ROSTER_SIZE:
		_roster.append(character_id)

func remove_from_roster(character_id: String) -> void:
	_roster.erase(character_id)
	_active_party.erase(character_id)

func get_roster() -> Array[String]:
	return _roster.duplicate()

## Personajes en el Bastión (en el roster pero no en la party activa)
func get_bench() -> Array[String]:
	return _roster.filter(func(id: String) -> bool: return id not in _active_party)

func is_in_roster(character_id: String) -> bool:
	return character_id in _roster

# ============================================================
# API PÚBLICA — PARTY ACTIVA
# ============================================================

## Configura la party para una misión. max_size = 4 o 5 según la misión.
## ids debe ser un subset del roster, en el orden de formación deseado.
func set_active_party(ids: Array[String], max_size: int = Constants.MAX_PARTY_SIZE) -> bool:
	for id in ids:
		if id not in _roster:
			push_error("WorldState: '%s' no está en el roster." % id)
			return false
	if ids.size() > max_size:
		push_error("WorldState: la misión permite máximo %d personajes." % max_size)
		return false

	# Asegurar que el protagonista está siempre incluido y en el slot 0
	var ordered := ids.duplicate()
	if not protagonist_id.is_empty() and protagonist_id in _roster:
		ordered.erase(protagonist_id)
		ordered.insert(0, protagonist_id)

	_active_party = ordered
	FormationManager.set_formation(_active_party)
	return true

func set_protagonist(character_id: String) -> void:
	protagonist_id = character_id
	if character_id not in _roster:
		add_to_roster(character_id)

func get_active_party() -> Array[String]:
	return _active_party.duplicate()

func get_active_party_size() -> int:
	return _active_party.size()

func is_in_active_party(character_id: String) -> bool:
	return character_id in _active_party

# ============================================================
# API PÚBLICA — RECURSOS
# ============================================================

func add_gold(amount: int) -> void:
	gold += amount
	EventBus.gold_changed.emit(amount, gold)

func spend_gold(amount: int) -> bool:
	if gold < amount:
		return false
	gold -= amount
	EventBus.gold_changed.emit(-amount, gold)
	return true

# ============================================================
# API PÚBLICA — COFRE DEL CAMPAMENTO
# ============================================================

func add_to_camp_chest(item_id: String) -> void:
	camp_chest.append(item_id)
	EventBus.camp_chest_changed.emit(camp_chest.duplicate())

func remove_from_camp_chest(item_id: String) -> bool:
	var idx := camp_chest.find(item_id)
	if idx == -1:
		return false
	camp_chest.remove_at(idx)
	EventBus.camp_chest_changed.emit(camp_chest.duplicate())
	return true

func camp_chest_has(item_id: String) -> bool:
	return item_id in camp_chest

func get_camp_chest() -> Array[String]:
	return camp_chest.duplicate()

## Mueve un objeto del cofre al inventario personal de un personaje.
func take_from_camp_chest(item_id: String, char_data: CharacterData) -> bool:
	if not remove_from_camp_chest(item_id):
		return false
	if not char_data.inventory_add(item_id):
		add_to_camp_chest(item_id)  # rollback
		return false
	return true

## Mueve un objeto del inventario personal al cofre.
func deposit_to_camp_chest(item_id: String, char_data: CharacterData) -> bool:
	if not char_data.inventory_remove(item_id):
		return false
	add_to_camp_chest(item_id)
	return true

## Compatibilidad hacia atrás con el antiguo add_item(Dictionary).
func add_item(item: Dictionary) -> void:
	var id: String = item.get("item_id", "")
	if not id.is_empty():
		add_to_camp_chest(id)

# ============================================================
# API PÚBLICA — FLAGS DE LORE
# ============================================================

func set_flag(flag: String, value: Variant = true) -> void:
	lore_flags[flag] = value

func get_flag(flag: String, default: Variant = false) -> Variant:
	return lore_flags.get(flag, default)

func has_flag(flag: String) -> bool:
	return lore_flags.has(flag)

# ============================================================
# API PÚBLICA — PROGRESO
# ============================================================

func mark_dungeon_completed(dungeon_id: String) -> void:
	if dungeon_id not in completed_dungeons:
		completed_dungeons.append(dungeon_id)

func mark_room_cleared(room_key: String) -> void:
	if room_key not in cleared_rooms:
		cleared_rooms.append(room_key)

func is_room_cleared(room_key: String) -> bool:
	return room_key in cleared_rooms

func add_journal_entry(entry: String) -> void:
	journal_entries.append(entry)
	EventBus.journal_entry_added.emit(entry)

# ============================================================
# API PÚBLICA — COMBATE PENDIENTE
# ============================================================

func set_pending_combat(dungeon_id: String, room_data: Dictionary) -> void:
	_pending_dungeon_id = dungeon_id
	_pending_room_data = room_data

func get_pending_combat() -> Dictionary:
	return {"dungeon_id": _pending_dungeon_id, "room_data": _pending_room_data}

# ============================================================
# SERIALIZACIÓN
# ============================================================

func to_dict() -> Dictionary:
	return {
		"roster":             _roster,
		"protagonist_id":     protagonist_id,
		"active_party":       _active_party,
		"gold":               gold,
		"camp_chest":         camp_chest,
		"completed_dungeons": completed_dungeons,
		"cleared_rooms":      cleared_rooms,
		"journal_entries":    journal_entries,
		"lore_flags":         lore_flags,
		"level_manager":      LevelManager.to_dict(),
		"bastion_manager":    BastionManager.to_dict(),
		"enemy_knowledge":    enemy_knowledge.to_dict(),
	}

func from_dict(data: Dictionary) -> void:
	_roster        = data.get("roster", [])
	protagonist_id = data.get("protagonist_id", "")
	_active_party  = data.get("active_party", [])
	gold           = data.get("gold", 0)
	# "camp_chest" nuevo; "inventory" es la clave antigua — compatibilidad hacia atrás
	var chest_raw: Array = data.get("camp_chest", data.get("inventory", []))
	camp_chest = []
	for entry in chest_raw:
		if entry is String:
			camp_chest.append(entry)
		elif entry is Dictionary and entry.has("item_id"):
			camp_chest.append(str(entry["item_id"]))
	completed_dungeons = data.get("completed_dungeons", [])
	cleared_rooms  = data.get("cleared_rooms", [])
	journal_entries = data.get("journal_entries", [])
	lore_flags     = data.get("lore_flags", {})
	if data.has("enemy_knowledge"):
		enemy_knowledge.from_dict(data["enemy_knowledge"])
	if data.has("level_manager"):
		LevelManager.from_dict(data["level_manager"])
	if not _active_party.is_empty():
		FormationManager.set_formation(_active_party)
