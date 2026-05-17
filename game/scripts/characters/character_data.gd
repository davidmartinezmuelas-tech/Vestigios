## character_data.gd
## Resource con los datos base de un personaje (héroe o enemigo).
## Crear un .tres por personaje en data/characters/

class_name CharacterData
extends Resource

# ============================================================
# IDENTIDAD
# ============================================================
@export var character_id: String = ""
@export var display_name: String = ""
@export var is_hero: bool = true
## ID de la clase principal (usado para calcular espacios de conjuro)
## Valores: "bardo","hechicero","mago","clerigo","druida","paladin","explorador","brujo",
##          "barbaro","guerrero","monje","picaro" (sin conjuros estos últimos)
@export var class_id: String = ""
## ID de la subclase elegida (referencia a SubclassDatabase). Disponible a partir de nivel 3.
@export var subclass_id: String = ""
## Tiene el rasgo Maestría con Armas (Paladín, Explorador, Guerrero, Bárbaro, Pícaro nv1 en 2024)
@export var has_weapon_mastery: bool = false

## Devuelve los rasgos de subclase activos para el nivel actual.
func get_subclass_features() -> Array[Dictionary]:
	if subclass_id.is_empty() or level < 3:
		return []
	var result: Array[Dictionary] = []
	for lv in range(1, level + 1):
		for feat in SubclassDatabase.get_feature(subclass_id, lv):
			result.append(feat)
	return result

## Devuelve los conjuros siempre preparados por la subclase.
func get_subclass_always_prepared() -> Array[String]:
	if subclass_id.is_empty():
		return []
	return SubclassDatabase.get_always_prepared_spells(subclass_id)

# ============================================================
# PROGRESIÓN
# ============================================================
@export_group("Progresión")
## Nivel total del personaje (suma de todos los niveles de clase)
@export var level: int = 1
## Caras del dado de golpe de la clase principal (6, 8, 10 o 12)
@export var hit_dice_sides: int = 8
## Bonificador de competencia según nivel total
@export var proficiency_bonus: int = 2

## Multiclase — clase secundaria (vacío si solo hay una clase)
@export var multiclass_id: String = ""
## Niveles en la clase secundaria (level = nivel_principal + multiclass_level)
@export var multiclass_level: int = 0

## Nivel efectivo en una clase concreta.
func class_level(queried_class_id: String) -> int:
	if queried_class_id == class_id:
		return level - multiclass_level
	if queried_class_id == multiclass_id:
		return multiclass_level
	return 0

## Nivel total del personaje (principal + secundaria).
func total_level() -> int:
	return level

## Valida si este personaje puede multiclasear en otra clase.
## Comprueba los requisitos de AMBAS clases (D&D 2024).
func can_multiclass_into(new_class_id: String) -> bool:
	if new_class_id == class_id:
		return false  # no se puede repetir la misma clase
	# Requisitos de la clase actual
	var current_reqs := ClassDefinition.get_multiclass_requirements(class_id)
	for ability in current_reqs:
		if get(ability, 10) < current_reqs[ability]:
			return false
	# Requisitos de la clase nueva
	var new_reqs := ClassDefinition.get_multiclass_requirements(new_class_id)
	for ability in new_reqs:
		if get(ability, 10) < new_reqs[ability]:
			return false
	return true

## Texto del motivo por el que no puede multiclasear (para mostrar en UI).
func multiclass_blocked_reason(new_class_id: String) -> String:
	if new_class_id == class_id:
		return "Ya eres %s." % class_id
	var current_reqs := ClassDefinition.get_multiclass_requirements(class_id)
	for ability in current_reqs:
		if get(ability, 10) < current_reqs[ability]:
			return "Tu clase actual requiere %s %d." % [ability.to_upper(), current_reqs[ability]]
	var new_reqs := ClassDefinition.get_multiclass_requirements(new_class_id)
	for ability in new_reqs:
		if get(ability, 10) < new_reqs[ability]:
			return "%s requiere %s %d." % [new_class_id, ability.to_upper(), new_reqs[ability]]
	return ""

# ============================================================
# PUNTUACIONES DE CARACTERÍSTICA (1–20, modificador = (puntaje-10)/2 redondeado abajo)
# ============================================================
@export_group("Características")
@export_range(1, 30) var strength: int = 10
@export_range(1, 30) var dexterity: int = 10
@export_range(1, 30) var constitution: int = 10
@export_range(1, 30) var intelligence: int = 10
@export_range(1, 30) var wisdom: int = 10
@export_range(1, 30) var charisma: int = 10

# ============================================================
# DEFENSA
# ============================================================
@export_group("Defensa")
## Clase de Armadura base (incluye armadura + escudo si procede)
@export var armor_class: int = 10
## Tiradas de salvación con competencia: "str", "dex", "con", "int", "wis", "cha"
@export var saving_throw_proficiencies: Array[String] = []
## Competencias de habilidad (nombres snake_case: "percepcion", "intimidacion"...)
@export var skill_proficiencies: Array[String] = []
## Condiciones persistentes (sobreviven entre escenas: "resaca", "borracho"...)
@export var persistent_conditions: Array[String] = []

# ============================================================
# EQUIPAMIENTO — 12 slots
# Valor "" = vacío. Valor = item_id del objeto equipado.
# ============================================================
@export_group("Equipamiento")
@export var slot_mano_principal: String = ""
@export var slot_mano_secundaria: String = ""
@export var slot_armadura: String = ""
@export var slot_cabeza: String = ""
@export var slot_manos: String = ""
@export var slot_capa: String = ""
@export var slot_cuello: String = ""
@export var slot_anillo_1: String = ""
@export var slot_anillo_2: String = ""
@export var slot_botas: String = ""
@export var slot_cinturon: String = ""
@export var slot_complemento: String = ""

## Compatibilidad hacia atrás con equipped_armor_id (usar slot_armadura directamente cuando sea posible).
var equipped_armor_id: String:
	get: return slot_armadura
	set(v): slot_armadura = v

## Devuelve el item_id equipado en un slot, o "" si vacío.
func get_slot(slot: EquipmentSlot.Slot) -> String:
	match slot:
		EquipmentSlot.Slot.MANO_PRINCIPAL:  return slot_mano_principal
		EquipmentSlot.Slot.MANO_SECUNDARIA: return slot_mano_secundaria
		EquipmentSlot.Slot.ARMADURA:        return slot_armadura
		EquipmentSlot.Slot.CABEZA:          return slot_cabeza
		EquipmentSlot.Slot.MANOS:           return slot_manos
		EquipmentSlot.Slot.CAPA:            return slot_capa
		EquipmentSlot.Slot.CUELLO:          return slot_cuello
		EquipmentSlot.Slot.ANILLO_1:        return slot_anillo_1
		EquipmentSlot.Slot.ANILLO_2:        return slot_anillo_2
		EquipmentSlot.Slot.BOTAS:           return slot_botas
		EquipmentSlot.Slot.CINTURON:        return slot_cinturon
		EquipmentSlot.Slot.COMPLEMENTO:     return slot_complemento
	return ""

## Establece un slot. Usar siempre este método en lugar de asignar directamente.
func set_slot(slot: EquipmentSlot.Slot, item_id: String) -> void:
	match slot:
		EquipmentSlot.Slot.MANO_PRINCIPAL:  slot_mano_principal  = item_id
		EquipmentSlot.Slot.MANO_SECUNDARIA: slot_mano_secundaria = item_id
		EquipmentSlot.Slot.ARMADURA:        slot_armadura        = item_id
		EquipmentSlot.Slot.CABEZA:          slot_cabeza          = item_id
		EquipmentSlot.Slot.MANOS:           slot_manos           = item_id
		EquipmentSlot.Slot.CAPA:            slot_capa            = item_id
		EquipmentSlot.Slot.CUELLO:          slot_cuello          = item_id
		EquipmentSlot.Slot.ANILLO_1:        slot_anillo_1        = item_id
		EquipmentSlot.Slot.ANILLO_2:        slot_anillo_2        = item_id
		EquipmentSlot.Slot.BOTAS:           slot_botas           = item_id
		EquipmentSlot.Slot.CINTURON:        slot_cinturon        = item_id
		EquipmentSlot.Slot.COMPLEMENTO:     slot_complemento     = item_id

## Devuelve un Dictionary {slot_key: item_id} con todos los slots no vacíos.
func get_all_equipped() -> Dictionary:
	var result: Dictionary = {}
	for slot in EquipmentSlot.Slot.values():
		var id := get_slot(slot as EquipmentSlot.Slot)
		if not id.is_empty():
			result[EquipmentSlot.to_key(slot as EquipmentSlot.Slot)] = id
	return result

# ============================================================
# INVENTARIO PERSONAL
# Array de item_ids. La data real vive en ItemDatabase/MagicItemDatabase.
# ============================================================
@export_group("Inventario")
@export var personal_inventory: Array[String] = []
@export var gold: int = 0

func inventory_add(item_id: String) -> bool:
	if personal_inventory.size() >= Constants.MAX_PERSONAL_INVENTORY:
		return false
	personal_inventory.append(item_id)
	return true

func inventory_remove(item_id: String) -> bool:
	var idx := personal_inventory.find(item_id)
	if idx == -1:
		return false
	personal_inventory.remove_at(idx)
	return true

func inventory_has(item_id: String) -> bool:
	return item_id in personal_inventory

func inventory_count(item_id: String) -> int:
	var count := 0
	for id in personal_inventory:
		if id == item_id:
			count += 1
	return count

# ============================================================
# SINTONÍA (D&D 2024) — máximo 3 objetos por personaje
# ============================================================
@export_group("Sintonía")
@export var attuned_item_ids: Array[String] = []

func can_attune() -> bool:
	return attuned_item_ids.size() < Constants.MAX_ATTUNED_ITEMS

func attune(item_id: String) -> bool:
	if item_id in attuned_item_ids:
		return true
	if not can_attune():
		return false
	attuned_item_ids.append(item_id)
	return true

func unattune(item_id: String) -> void:
	attuned_item_ids.erase(item_id)

func is_attuned(item_id: String) -> bool:
	return item_id in attuned_item_ids

## Devuelve true si el personaje puede sintonizar este objeto mágico concreto.
func can_attune_item(magic_data: MagicItemData) -> bool:
	match magic_data.attunement:
		MagicItemData.Attunement.NONE:
			return false
		MagicItemData.Attunement.ANY:
			return can_attune()
		MagicItemData.Attunement.SPELLCASTER:
			return can_attune() and _is_spellcaster()
		MagicItemData.Attunement.SPECIFIC:
			return can_attune() and _meets_specific_attunement(magic_data.attunement_note)
	return false

func _is_spellcaster() -> bool:
	const SPELLCASTER_CLASSES: Array[String] = [
		"bardo", "hechicero", "mago", "clerigo", "druida",
		"paladin", "explorador", "brujo"
	]
	return class_id in SPELLCASTER_CLASSES or multiclass_id in SPELLCASTER_CLASSES

func _meets_specific_attunement(note: String) -> bool:
	var lower := note.to_lower()
	return class_id in lower or multiclass_id in lower

## Serializa equipamiento, inventario y sintonías para el sistema de guardado.
func equipment_to_dict() -> Dictionary:
	return {
		"slots":     get_all_equipped(),
		"inventory": personal_inventory.duplicate(),
		"attuned":   attuned_item_ids.duplicate(),
		"gold":      gold,
	}

## Restaura equipamiento desde Dictionary (llamado por SaveManager).
func equipment_from_dict(data: Dictionary) -> void:
	personal_inventory = []
	for id in data.get("inventory", []):
		personal_inventory.append(str(id))
	attuned_item_ids = []
	for id in data.get("attuned", []):
		attuned_item_ids.append(str(id))
	gold = data.get("gold", 0)
	var slots: Dictionary = data.get("slots", {})
	for key in slots:
		set_slot(EquipmentSlot.from_key(str(key)), str(slots[key]))

# ============================================================
# ECONOMÍA
# ============================================================
@export_group("Economía")
@export var starting_gold: int = 0

# ============================================================
# LOOT
# ============================================================
@export_group("Loot")
## Si true: al morir puede soltar equipo y objetos mágicos.
## Si false (enemigo básico): solo oro — el combate destruyó su equipo.
@export var is_boss: bool = false
## Tabla de loot que genera al morir. nil = usar fórmula por CR.
@export var loot_table: LootTable = null

# ============================================================
# MOVIMIENTO
# ============================================================
@export_group("Movimiento")
## Velocidad en pies (30 ft por defecto)
@export var speed_ft: int = 30

# ============================================================
# CONJUROS Y TRUCOS
# ============================================================
@export_group("Conjuros")
## IDs de trucos conocidos (nivel 0, uso ilimitado). Se resuelven contra SpellDatabase.
@export var cantrip_ids: Array[String] = []
## IDs de conjuros preparados/conocidos (nivel 1+). Se resuelven contra SpellDatabase.
@export var spell_ids: Array[String] = []
## Dados de golpe disponibles para descanso corto
@export var hit_dice_remaining: int = 0

## Devuelve los SpellData resueltos de los trucos.
func get_cantrips() -> Array[SpellData]:
	var result: Array[SpellData] = []
	for id in cantrip_ids:
		var s := SpellDatabase.get(id)
		if s:
			result.append(s)
	return result

## Devuelve los SpellData resueltos de los conjuros.
func get_spells() -> Array[SpellData]:
	var result: Array[SpellData] = []
	for id in spell_ids:
		var s := SpellDatabase.get(id)
		if s:
			result.append(s)
	return result

# ============================================================
# ESTRÉS (mecánica propia del juego)
# ============================================================
@export_group("Estrés")
@export var max_stress: int = 100

# ============================================================
# EXPERIENCIA (solo enemigos)
# ============================================================
@export_group("Experiencia")
## XP que otorga al morir. 0 para héroes.
@export var xp_reward: int = 0
## Nivel de desafío aproximado (usado para referencia de diseño)
@export var challenge_rating: float = 0.0

# ============================================================
# HABILIDADES
# ============================================================
@export_group("Habilidades")
@export var abilities: Array[AbilityData] = []

# ============================================================
# ARTE
# ============================================================
@export_group("Arte")
@export var sprite: Texture2D

@export_subgroup("Retratos de diálogo")
@export var portrait_neutral: Texture2D
@export var portrait_happy: Texture2D
@export var portrait_angry: Texture2D
@export var portrait_scared: Texture2D
@export var portrait_focused: Texture2D  # para tiradas de habilidad

## Devuelve el retrato de la emoción pedida. Si no existe, devuelve neutral.
func get_portrait(emotion: String) -> Texture2D:
	match emotion:
		"happy":   return portrait_happy   if portrait_happy   else portrait_neutral
		"angry":   return portrait_angry   if portrait_angry   else portrait_neutral
		"scared":  return portrait_scared  if portrait_scared  else portrait_neutral
		"focused": return portrait_focused if portrait_focused else portrait_neutral
		_:         return portrait_neutral

# ============================================================
# FUNCIONES DE UTILIDAD (accesibles desde CharacterData directamente)
# ============================================================

static func ability_modifier(score: int) -> int:
	return floori((score - 10) / 2.0)

## HP máximo: nivel 1 usa el máximo del dado; niveles superiores usan la media (redondeada arriba) + CON
func calculate_max_hp() -> int:
	var con_mod := ability_modifier(constitution)
	var hp := hit_dice_sides + con_mod  # nivel 1: máximo del dado
	var avg_per_level := ceili(hit_dice_sides / 2.0) + 1  # media del dado (p.ej. d8 → 5)
	hp += (level - 1) * (avg_per_level + con_mod)
	return maxi(1, hp)
