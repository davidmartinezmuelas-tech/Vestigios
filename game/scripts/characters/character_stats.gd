## character_stats.gd
## Nodo hijo de BaseCharacter. Gestiona stats en tiempo real con modificadores temporales.

class_name CharacterStats
extends Node

# ============================================================
# CARACTERÍSTICAS BASE
# ============================================================
var strength: int = 10
var dexterity: int = 10
var constitution: int = 10
var intelligence: int = 10
var wisdom: int = 10
var charisma: int = 10

# ============================================================
# PROGRESIÓN
# ============================================================
var level: int = 1
var proficiency_bonus: int = 2
var hit_dice_sides: int = 8

# ============================================================
# DEFENSA Y MOVIMIENTO
# ============================================================
var base_armor_class: int = 10
var speed_ft: int = 30

# ============================================================
# HP Y ESTRÉS
# ============================================================
var max_health: int = 0
var max_stress: int = 100

var current_health: int:
	get: return _current_health
	set(v): _current_health = clampi(v, 0, max_health)

var current_stress: int:
	get: return _current_stress
	set(v): _current_stress = clampi(v, 0, max_stress)

var _current_health: int = 0
var _current_stress: int = 0

# ============================================================
# MODIFICADORES TEMPORALES (efectos, condiciones)
# Keys: "str", "dex", "con", "int", "wis", "cha", "ac", "speed"
# ============================================================
var _temp_modifiers: Dictionary = {
	"str": 0, "dex": 0, "con": 0,
	"int": 0, "wis": 0, "cha": 0,
	"ac": 0, "speed": 0,
}

# ============================================================
# CONDICIONES ACTIVAS (por personaje)
## Clave: condition_id | Valor: {rounds_remaining: int}  (-1 = indefinido)
# ============================================================
var _active_conditions: Dictionary = {}

# ============================================================
# CONCENTRACIÓN (D&D 2024)
# ============================================================
## ID del conjuro que se está concentrando ("" si ninguno)
var concentration_spell_id: String = ""

func start_concentration(spell_id: String) -> void:
	concentration_spell_id = spell_id

func break_concentration() -> void:
	if concentration_spell_id.is_empty():
		return
	EventBus.effect_expired.emit(null, null)  # señal genérica; la escena reacciona
	concentration_spell_id = ""

func is_concentrating() -> bool:
	return not concentration_spell_id.is_empty()

## Tirada de salvación de CON para mantener concentración (D&D 2024).
## damage: daño recibido. CD = max(10, damage/2), máximo 30.
## Devuelve true si la mantiene, false si la pierde.
func make_concentration_check(damage: int) -> bool:
	var cd := clampi(maxi(10, damage / 2), 10, 30)
	var roll := RngManager.randi_range(1, 20)
	var con_mod := get_modifier("con")
	var save_bonus := con_mod + (proficiency_bonus if "con" in _saving_throw_proficiencies else 0)
	var total := roll + save_bonus
	if total < cd:
		break_concentration()
		return false
	return true

var _saving_throw_proficiencies: Array[String] = []

# ============================================================
# MAESTRÍA — TRACKING ENTRE TURNOS
# ============================================================
## MOLESTAR: ID del objetivo contra quien tenemos ventaja en el próximo ataque.
var mastery_advantage_vs: String = ""
## RALENTIZAR: si ya tiene la penalización de velocidad por maestría este turno.
var mastery_slowed: bool = false
## HENDER: si ya se ha usado el ataque extra de Hender este turno.
var mastery_cleave_used: bool = false

func clear_mastery_turn_state() -> void:
	mastery_slowed       = false
	mastery_cleave_used  = false
	mastery_advantage_vs = ""

# ============================================================
# INICIATIVA (2024: d20 + DEX mod + bonificador de iniciativa)
# ============================================================
var initiative_bonus: int = 0

func roll_initiative() -> int:
	return RngManager.randi_range(1, 20) + get_modifier("dex") + initiative_bonus

# ============================================================
# RECURSOS DE CLASE (Inspiración Bárdica, Ki, Furia, etc.)
## Inicializados desde ClassFeatureDatabase en initialize().
## Clave: resource_id | Valor: int (usos restantes)
# ============================================================
var _class_resources: Dictionary = {}
var _class_resource_max: Dictionary = {}

func init_class_resources(class_id: String, char_data: CharacterData) -> void:
	# Clase principal
	var primary_level := char_data.class_level(class_id)
	var resource_map: Dictionary = ClassFeatureDatabase.get_class_resources(class_id, primary_level, char_data)
	for key in resource_map:
		_class_resource_max[key] = resource_map[key]
		_class_resources[key]    = resource_map[key]

	# Clase secundaria (multiclase) — añade sus recursos propios
	if not char_data.multiclass_id.is_empty() and char_data.multiclass_level > 0:
		var secondary_map: Dictionary = ClassFeatureDatabase.get_class_resources(
			char_data.multiclass_id, char_data.multiclass_level, char_data
		)
		for key in secondary_map:
			# Combinar (sumar) recursos que ya existen, añadir los nuevos
			if _class_resource_max.has(key):
				_class_resource_max[key] += secondary_map[key]
				_class_resources[key]    += secondary_map[key]
			else:
				_class_resource_max[key] = secondary_map[key]
				_class_resources[key]    = secondary_map[key]

func get_class_resource(resource_id: String) -> int:
	return _class_resources.get(resource_id, 0)

func get_class_resource_max(resource_id: String) -> int:
	return _class_resource_max.get(resource_id, 0)

func spend_class_resource(resource_id: String, amount: int = 1) -> bool:
	var current: int = _class_resources.get(resource_id, 0)
	if current < amount:
		return false
	_class_resources[resource_id] = current - amount
	return true

func restore_class_resource(resource_id: String, amount: int = 9999) -> void:
	var max_val: int = _class_resource_max.get(resource_id, 0)
	_class_resources[resource_id] = mini(_class_resources.get(resource_id, 0) + amount, max_val)

func restore_all_class_resources() -> void:
	for key in _class_resource_max:
		_class_resources[key] = _class_resource_max[key]

## Cuántos ataques tiene este personaje por acción (Extra Attack).
func get_attack_count() -> int:
	return _class_resources.get("extra_attack", 1)

## Dados de Ataque Furtivo del Pícaro.
func get_sneak_attack_dice() -> int:
	return _class_resources.get("sneak_attack_dice", 0)

## Dado de Inspiración Bárdica (tamaño del dado).
func get_bardic_die() -> int:
	return _class_resources.get("bardic_inspiration_die", 6)

# ============================================================
# INICIALIZACIÓN
# ============================================================

func initialize(data: CharacterData) -> void:
	strength     = data.strength
	dexterity    = data.dexterity
	constitution = data.constitution
	intelligence = data.intelligence
	wisdom       = data.wisdom
	charisma     = data.charisma

	level             = data.level
	proficiency_bonus = data.proficiency_bonus
	hit_dice_sides    = data.hit_dice_sides
	base_armor_class  = data.armor_class
	speed_ft          = data.speed_ft
	max_stress        = data.max_stress

	max_health      = data.calculate_max_hp()
	_current_health = max_health
	_current_stress = 0

	_saving_throw_proficiencies = data.saving_throw_proficiencies.duplicate()
	concentration_spell_id = ""
	# Inicializar recursos de clase
	if not data.class_id.is_empty():
		init_class_resources(data.class_id, data)

	# Cargar condiciones persistentes del CharacterData
	_active_conditions.clear()
	for cond_id in data.persistent_conditions:
		_active_conditions[cond_id] = {"rounds_remaining": -1}

	# Requisito de Fuerza mínima para armaduras pesadas (D&D 2024)
	# Si FUE < requisito: velocidad -10ft (penalización de movimiento)
	_apply_armor_str_penalty(data)

	# Aplicar bonificadores de objetos mágicos equipados
	_apply_all_equipment_bonuses(data)

# ============================================================
# MODIFICADORES DE CARACTERÍSTICA (estático, útil desde cualquier sitio)
# ============================================================

static func modifier_for(score: int) -> int:
	return floori((score - 10) / 2.0)

## Devuelve el modificador de una característica por nombre, incluyendo efectos temporales.
func get_modifier(ability: String) -> int:
	var score: int = _get_score(ability) + _temp_modifiers.get(ability, 0)
	return modifier_for(score)

func get_score(ability: String) -> int:
	return _get_score(ability) + _temp_modifiers.get(ability, 0)

# ============================================================
# STATS CALCULADOS
# ============================================================

var armor_class: int:
	get: return base_armor_class + _temp_modifiers.get("ac", 0)

var speed: int:
	get: return maxi(0, speed_ft + _temp_modifiers.get("speed", 0))

# ============================================================
# MODIFICADORES TEMPORALES
# ============================================================

func add_temp_modifier(key: String, value: int) -> void:
	if _temp_modifiers.has(key):
		_temp_modifiers[key] += value

func remove_temp_modifier(key: String, value: int) -> void:
	if _temp_modifiers.has(key):
		_temp_modifiers[key] -= value

# ============================================================
# CONDICIONES POR PERSONAJE
# ============================================================

func add_condition(condition_id: String, rounds: int = -1) -> void:
	if condition_id in _active_conditions and condition_id != "cansancio":
		return  # No se acumulan (excepto cansancio que tiene niveles)
	_active_conditions[condition_id] = {"rounds_remaining": rounds}

func remove_condition(condition_id: String) -> void:
	_active_conditions.erase(condition_id)

func has_condition(condition_id: String) -> bool:
	return condition_id in _active_conditions

func get_active_conditions() -> Array[String]:
	return _active_conditions.keys()

## Avanza las condiciones con duración. Llámalo al inicio del turno.
func process_condition_durations() -> void:
	var to_remove: Array[String] = []
	for cond_id in _active_conditions:
		var entry: Dictionary = _active_conditions[cond_id]
		var rounds: int = entry.get("rounds_remaining", -1)
		if rounds > 0:
			entry["rounds_remaining"] = rounds - 1
			if rounds - 1 <= 0:
				to_remove.append(cond_id)
	for id in to_remove:
		_active_conditions.erase(id)

## Elimina todas las condiciones marcadas como "remove_after_combat".
func clear_post_combat_conditions() -> void:
	var to_remove: Array[String] = []
	for cond_id in _active_conditions:
		if ConditionDefs.removes_after_combat(cond_id):
			to_remove.append(cond_id)
	for id in to_remove:
		_active_conditions.erase(id)

# ── Consultas de efecto ──────────────────────────────────────

func has_attack_disadvantage() -> bool:
	var disadvantage_conds := [
		"apresado", "asustado", "aturdido", "cegado",
		"derribado", "envenenado", "borracho", "resaca", "exhausto_nado",
		"debilitado_maestria",
		"cansancio_3", "cansancio_4", "cansancio_5",
	]
	for c in disadvantage_conds:
		if has_condition(c):
			return true
	return false

func has_attack_advantage() -> bool:
	return has_condition("invisible")

func attackers_have_advantage() -> bool:
	var adv_conds := [
		"aturdido", "cegado", "inconsciente",
		"paralizado", "petrificado", "apresado",
		"punto_debil_revelado",  # acción Estudiar revela apertura táctica
	]
	for c in adv_conds:
		if has_condition(c):
			return true
	return false

func has_ability_check_disadvantage() -> bool:
	var conds := [
		"asustado", "envenenado", "borracho", "resaca", "exhausto_nado",
		"cansancio_1", "cansancio_2", "cansancio_3", "cansancio_4", "cansancio_5",
	]
	for c in conds:
		if has_condition(c):
			return true
	return false

func is_incapacitated() -> bool:
	return has_condition("incapacitado") or has_condition("aturdido") or \
		   has_condition("inconsciente") or has_condition("paralizado") or \
		   has_condition("petrificado")

func has_skill_disadvantage(skill_name: String) -> bool:
	for cond_id in _active_conditions:
		var def := ConditionDefs.get_def(cond_id)
		var skills: Array = def.get("skill_disadvantage", [])
		if skill_name.to_lower() in skills:
			return true
	return false

# ============================================================
# ESTADO
# ============================================================

func is_alive() -> bool:
	return _current_health > 0

func health_percentage() -> float:
	if max_health == 0:
		return 0.0
	return float(_current_health) / float(max_health)

func stress_percentage() -> float:
	if max_stress == 0:
		return 0.0
	return float(_current_stress) / float(max_stress)

# ============================================================
# INTERNO
# ============================================================

func _get_score(ability: String) -> int:
	match ability:
		"str": return strength
		"dex": return dexterity
		"con": return constitution
		"int": return intelligence
		"wis": return wisdom
		"cha": return charisma
	return 10

## Comprueba si la armadura equipada requiere más FUE de la que tiene el personaje.
## Si es así, aplica -10ft de velocidad (D&D 2024).
func _apply_armor_str_penalty(data: CharacterData) -> void:
	if data.slot_armadura.is_empty():
		return
	var armor := ItemDatabase.get_armor(data.slot_armadura)
	if armor == null:
		return
	var required_str := armor.requires_strength
	if required_str > 0 and data.strength < required_str:
		_temp_modifiers["speed"] = _temp_modifiers.get("speed", 0) - 10

## Devuelve true si el personaje cumple el requisito de FUE para su armadura equipada.
func meets_armor_str_requirement(data: CharacterData) -> bool:
	if data.slot_armadura.is_empty():
		return true
	var armor := ItemDatabase.get_armor(data.slot_armadura)
	if armor == null:
		return true
	return data.strength >= armor.requires_strength

# ============================================================
# EQUIPAMIENTO — bonuses mágicos
# ============================================================

## Bonificadores actuales aplicados por objetos mágicos equipados.
## Clave: item_id | Valor: {key: String, value: int}
var _equipment_bonuses: Dictionary = {}

## Recorre todos los slots y aplica los bonificadores mágicos a _temp_modifiers.
func _apply_all_equipment_bonuses(data: CharacterData) -> void:
	_equipment_bonuses.clear()
	for slot in EquipmentSlot.Slot.values():
		var item_id := data.get_slot(slot as EquipmentSlot.Slot)
		if not item_id.is_empty():
			_try_apply_magic_bonus(item_id, data)

## Aplica el bonus de enhancement_bonus de un objeto mágico si procede.
func _try_apply_magic_bonus(item_id: String, data: CharacterData) -> void:
	var magic := MagicItemDatabase.find(item_id)
	if magic == null or magic.enhancement_bonus == 0:
		return
	if magic.attunement != MagicItemData.Attunement.NONE and not data.is_attuned(item_id):
		return
	var key := _magic_item_stat_key(magic)
	if key.is_empty() or not _temp_modifiers.has(key):
		return
	_temp_modifiers[key] += magic.enhancement_bonus
	_equipment_bonuses[item_id] = {"key": key, "value": magic.enhancement_bonus}

## Determina a qué stat de _temp_modifiers aplica un objeto mágico.
func _magic_item_stat_key(magic: MagicItemData) -> String:
	if not magic.affected_stat.is_empty():
		return magic.affected_stat
	match magic.item_type:
		ItemData.ItemType.ARMOR, ItemData.ItemType.SHIELD:
			return "ac"
		_:
			return ""

## Aplica el bonus de un objeto recién equipado sin reinicializar todo (para equip en runtime).
func apply_equipment_bonus(item_id: String, data: CharacterData) -> void:
	if _equipment_bonuses.has(item_id):
		return
	_try_apply_magic_bonus(item_id, data)

## Elimina el bonus de un objeto desequipado.
func remove_equipment_bonus(item_id: String) -> void:
	if not _equipment_bonuses.has(item_id):
		return
	var entry: Dictionary = _equipment_bonuses[item_id]
	var key: String = entry["key"]
	var value: int  = entry["value"]
	if _temp_modifiers.has(key):
		_temp_modifiers[key] -= value
	_equipment_bonuses.erase(item_id)

# ============================================================
# EQUIPAMIENTO — acceso a armas para CombatResolver
# ============================================================

## Devuelve el WeaponData del arma en mano principal, o null.
func get_equipped_weapon(data: CharacterData) -> WeaponData:
	var id := data.slot_mano_principal
	if id.is_empty():
		return null
	return ItemDatabase.get_weapon(id)

## Devuelve el WeaponData del arma en mano secundaria, o null.
func get_offhand_weapon(data: CharacterData) -> WeaponData:
	var id := data.slot_mano_secundaria
	if id.is_empty():
		return null
	return ItemDatabase.get_weapon(id)

## Devuelve el WeaponData del slot COMPLEMENTO (ej: arco secundario), o null.
func get_complement_weapon(data: CharacterData) -> WeaponData:
	var id := data.slot_complemento
	if id.is_empty():
		return null
	return ItemDatabase.get_weapon(id)

## Devuelve el enhancement_bonus del arma en mano principal (0 si no mágica o no sintonizada).
func get_weapon_enhancement_bonus(data: CharacterData) -> int:
	var id := data.slot_mano_principal
	if id.is_empty():
		return 0
	var magic := MagicItemDatabase.find(id)
	if magic == null:
		return 0
	if magic.attunement != MagicItemData.Attunement.NONE and not data.is_attuned(id):
		return 0
	return magic.enhancement_bonus
