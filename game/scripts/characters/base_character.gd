## base_character.gd
## Nodo base para héroes y enemigos. Conecta datos, stats, efectos y posición en grid.

class_name BaseCharacter
extends Node2D

# ============================================================
# SEÑALES
# ============================================================
signal health_changed(new_health: int, max_health: int)
signal stress_changed(new_stress: int, max_stress: int)
signal died
signal turn_started
signal turn_ended
signal moved(from: Vector2i, to: Vector2i)

# ============================================================
# NODOS HIJOS (asignados en la escena)
# ============================================================
@onready var stats: CharacterStats = $CharacterStats
@onready var effect_manager: Node = $EffectManager

# ============================================================
# DATOS Y ESTADO
# ============================================================
@export var data: CharacterData

var is_hero: bool = true
var grid_position: Vector2i = Vector2i.ZERO

## Espacios de conjuro de este personaje
var spell_slots: SpellSlots = SpellSlots.new()

## Movimiento gastado en este turno (en tiles)
var _tiles_moved: int = 0
var _has_acted: bool    = false
var _has_bonus_acted: bool = false
var _has_reacted: bool  = false

## Tiradas de muerte (D&D 2024)
var _death_save_successes: int = 0
var _death_save_failures: int  = 0
var _is_stable: bool = false

# ============================================================
# LIFECYCLE
# ============================================================

func _ready() -> void:
	if data:
		initialize(data)

func initialize(character_data: CharacterData) -> void:
	data = character_data
	is_hero = character_data.is_hero
	stats.initialize(character_data)
	spell_slots.setup(
		SpellSlots.caster_type_for_class(character_data.class_id),
		character_data.level
	)

# ============================================================
# COMBATE — DAÑO Y CURACIÓN
# ============================================================

func take_damage(amount: int) -> void:
	if _is_stable or is_dying():
		# Daño adicional a criatura estable/agonizante añade fracasos
		_death_save_failures = mini(_death_save_failures + 1, 3)
		_check_death()
		return

	var previous_health := stats.current_health
	stats.current_health -= amount
	health_changed.emit(stats.current_health, stats.max_health)

	# Concentración: check si recibe daño mientras concentra
	if stats.is_concentrating() and amount > 0:
		stats.make_concentration_check(amount)

	if stats.current_health <= 0 and previous_health > 0:
		_on_reach_zero_hp()

func heal(amount: int) -> void:
	stats.current_health += amount
	health_changed.emit(stats.current_health, stats.max_health)
	EventBus.healing_applied.emit(self, amount)

func apply_stress(amount: int) -> void:
	stats.current_stress += amount
	stress_changed.emit(stats.current_stress, stats.max_stress)
	EventBus.stress_changed.emit(self, stats.current_stress)
	if stats.current_stress >= Constants.AFFLICTION_THRESHOLD:
		_trigger_stress_response()

func reduce_stress(amount: int) -> void:
	stats.current_stress -= amount
	stress_changed.emit(stats.current_stress, stats.max_stress)
	EventBus.stress_changed.emit(self, stats.current_stress)

# ============================================================
# RASGOS DE CLASE — MECÁNICAS ACTIVAS
# ============================================================

## PALADÍN: Imponer las Manos
## Gasta PG del reservorio (5×nivel) para curar a un objetivo adyacente.
func lay_on_hands(target: BaseCharacter, amount: int) -> bool:
	if not stats.spend_class_resource("lay_on_hands", amount):
		return false
	target.heal(amount)
	EventBus.narrator_bark.emit(
		"%s impone las manos: %d PG curados." % [get_display_name(), amount], 2.5
	)
	return true

## PALADÍN: Castigo de Paladín (ex-Divine Smite)
## Bonus tras golpear: gasta espacio de conjuro para daño radiante extra.
## Devuelve los dados de daño extra (cuenta los dados).
func use_paladin_smite(slot_level: int) -> int:
	if not spell_slots.spend(slot_level):
		return 0
	var dice := 2 + (slot_level - 1)  # 2d8 base + 1d8 por nivel extra
	EventBus.narrator_bark.emit(
		"¡Castigo de Paladín! %dd8 daño radiante." % dice, 2.5
	)
	return dice

## GUERRERO: Tomar Aliento (Second Wind)
## Bonus: cura 1d10 + nivel del guerrero.
func use_second_wind() -> bool:
	if not stats.spend_class_resource("second_wind"):
		return false
	var healed := RngManager.randi_range(1, 10) + stats.level
	heal(healed)
	EventBus.narrator_bark.emit(
		"%s toma aliento: +%d PG." % [get_display_name(), healed], 2.5
	)
	use_bonus_action()
	return true

## GUERRERO: Acción Súbita (Action Surge)
## Concede una acción extra este turno.
func use_action_surge() -> bool:
	if not stats.spend_class_resource("action_surge"):
		return false
	_has_acted = false  # permite actuar de nuevo
	EventBus.narrator_bark.emit("%s usa Acción Súbita." % get_display_name(), 2.0)
	return true

## BARDO: Inspiración Bárdica
## Bonus: da a un aliado un dado de inspiración (d6-d12).
func give_bardic_inspiration(target: BaseCharacter) -> bool:
	if not stats.spend_class_resource("bardic_inspiration"):
		return false
	var die_sides := stats.get_bardic_die()
	target.stats.add_condition("bardic_inspired_%s" % name, -1)
	# Almacenamos el dado como tag en la condición; la UI lo mostrará
	EventBus.narrator_bark.emit(
		"%s inspira a %s (d%d)." % [get_display_name(), target.get_display_name(), die_sides],
		2.5
	)
	use_bonus_action()
	return true

## Consume la Inspiración Bárdica de un personaje y devuelve el resultado del dado.
func consume_bardic_inspiration() -> int:
	var condition_key := ""
	for cond in stats.get_active_conditions():
		if cond.begins_with("bardic_inspired_"):
			condition_key = cond
			break
	if condition_key.is_empty():
		return 0
	stats.remove_condition(condition_key)
	return RngManager.randi_range(1, 6)  # TODO: usar el dado correcto del inspirador

## MONJE/KI: Usar punto de Energía Marcial.
func use_ki(amount: int = 1) -> bool:
	return stats.spend_class_resource("ki_points", amount)

## MONJE: Ráfaga de Golpes (Flurry of Blows)
## Bonus: gasta 1 Ki → 2 ataques sin armas.
func use_flurry_of_blows() -> bool:
	if not use_ki(1):
		return false
	EventBus.narrator_bark.emit("%s desata una Ráfaga de Golpes." % get_display_name(), 2.5)
	use_bonus_action()
	return true

## MONJE: Golpe Aturdidor
## Tras golpear: gasta 1 Ki → objetivo hace CON save o queda Aturdido.
func use_stunning_strike(target: BaseCharacter) -> bool:
	if not use_ki(1):
		return false
	var cd := 8 + stats.proficiency_bonus + stats.get_modifier("wis")
	var roll := RngManager.randi_range(1, 20) + target.stats.get_modifier("con")
	if roll < cd:
		target.stats.add_condition("aturdido", 1)
		EventBus.narrator_bark.emit("¡Golpe Aturdidor! %s queda aturdido." % target.get_display_name(), 3.0)
	else:
		target.stats.add_temp_modifier("speed", -10)
		EventBus.narrator_bark.emit("Golpe Aturdidor: %s ralentizado." % target.get_display_name(), 2.5)
	return true

## EXPLORADOR: Enemigo Predilecto (Marca del Cazador gratis)
func use_favored_enemy() -> bool:
	if not stats.spend_class_resource("favored_enemy_uses"):
		return false
	EventBus.narrator_bark.emit("%s marca a su presa." % get_display_name(), 2.0)
	return true

# ============================================================
# TURNO — MOVIMIENTO Y ACCIÓN
# ============================================================

func begin_turn() -> void:
	_has_acted       = false
	_has_bonus_acted = false
	_has_reacted     = false
	_tiles_moved     = 0
	effect_manager.process_turn_start()
	stats.process_condition_durations()
	stats.clear_mastery_turn_state()

	# Tirada de muerte si está agonizando
	if is_dying():
		_roll_death_save()
		return  # agonizando: no hace acciones normales

	turn_started.emit()
	EventBus.turn_started.emit(self)

func end_turn() -> void:
	_has_acted = true
	turn_ended.emit()
	EventBus.turn_ended.emit(self)

func can_move() -> bool:
	return _tiles_moved < stats.speed_ft / CombatGrid.FEET_PER_TILE

func can_act() -> bool:
	return not _has_acted

func tiles_remaining() -> int:
	return (stats.speed_ft / CombatGrid.FEET_PER_TILE) - _tiles_moved

func register_move(tiles: int) -> void:
	_tiles_moved += tiles

# ============================================================
# ESTADO
# ============================================================

func is_alive() -> bool:
	return stats.is_alive() or _is_stable

func is_dying() -> bool:
	return stats.current_health <= 0 and not _is_stable and \
		   _death_save_successes < 3 and _death_save_failures < 3

func is_dead() -> bool:
	return _death_save_failures >= 3

func can_act() -> bool:
	return not _has_acted and not is_dying()

func can_bonus_act() -> bool:
	return not _has_bonus_acted and not is_dying()

func can_react() -> bool:
	return not _has_reacted

func use_bonus_action() -> void:
	_has_bonus_acted = true

func use_reaction() -> void:
	_has_reacted = true

func get_display_name() -> String:
	return data.display_name if data else "???"

func get_abilities() -> Array[AbilityData]:
	return data.abilities if data else []

func get_spells() -> Array[SpellData]:
	return data.spells if data else []

func get_cantrips() -> Array[SpellData]:
	return data.cantrips if data else []

# ============================================================
# TIRADAS DE MUERTE (D&D 2024)
# ============================================================

## Llamado automáticamente al inicio del turno si está agonizando.
func _roll_death_save() -> void:
	var roll := RngManager.randi_range(1, 20)

	if roll == 20:
		# 20 natural: recupera 1 PG y se levanta
		_stabilize_and_revive(1)
		EventBus.narrator_bark.emit("%s recupera el conocimiento." % get_display_name(), 3.0)
		return

	if roll == 1:
		# 1 natural: 2 fracasos
		_death_save_failures = mini(_death_save_failures + 2, 3)
	elif roll >= 10:
		_death_save_successes = mini(_death_save_successes + 1, 3)
	else:
		_death_save_failures = mini(_death_save_failures + 1, 3)

	_check_death()

func _check_death() -> void:
	if _death_save_failures >= 3:
		_die()
	elif _death_save_successes >= 3:
		_stabilize()

func _stabilize() -> void:
	_is_stable = true
	_death_save_successes = 0
	_death_save_failures  = 0
	EventBus.narrator_bark.emit("%s se estabiliza." % get_display_name(), 3.0)

func _stabilize_and_revive(hp: int) -> void:
	_is_stable = false
	_death_save_successes = 0
	_death_save_failures  = 0
	stats.current_health = hp
	health_changed.emit(stats.current_health, stats.max_health)
	stats.remove_condition("inconsciente")

func _die() -> void:
	_is_stable = false
	died.emit()
	EventBus.character_died.emit(self)
	stats.break_concentration()

# ============================================================
# INTERNO
# ============================================================

func _on_reach_zero_hp() -> void:
	stats.current_health = 0
	stats.break_concentration()
	stats.add_condition("inconsciente")
	health_changed.emit(0, stats.max_health)

	if not is_hero:
		# Enemigos mueren directamente al llegar a 0
		_die()
	else:
		# Héroes entran en estado agonizante
		_death_save_successes = 0
		_death_save_failures  = 0
		_is_stable = false
		EventBus.narrator_bark.emit(
			"%s cae. Tiradas de muerte..." % get_display_name(), 3.0
		)

func _trigger_stress_response() -> void:
	pass
