## combat_manager.gd
## Orquesta el combate por turnos: inicio, movimiento, acción y fin.
## El orden de turnos viene de FormationManager (formación del partido).

class_name CombatManager
extends Node

# ============================================================
# SEÑALES
# ============================================================
signal combat_started
signal combat_ended(victory: bool)
signal round_started(round_number: int)
signal waiting_for_player_input(character: BaseCharacter)

# ============================================================
# NODOS HIJOS
# ============================================================
@onready var turn_manager: TurnManager = $TurnManager
@onready var combat_resolver: CombatResolver = $CombatResolver
@onready var grid: CombatGrid = $CombatGrid

# ============================================================
# ESTADO
# ============================================================
enum CombatState { IDLE, STARTING, PLAYER_MOVE, PLAYER_ACTION, ENEMY_TURN, RESOLVING, ENDED }

var _state: CombatState = CombatState.IDLE
var _heroes: Array[BaseCharacter] = []
var _enemies: Array[BaseCharacter] = []
var _current_round: int = 0
var _active_character: BaseCharacter = null
var _surprised: bool = false
var _attacks_this_turn: int = 0  # tracking de Extra Attack

# ============================================================
# API PÚBLICA — INICIO
# ============================================================

func start_combat(
	heroes: Array[BaseCharacter],
	enemies: Array[BaseCharacter],
	surprised: bool = false
) -> void:
	_heroes   = heroes
	_enemies  = enemies
	_surprised = surprised
	_current_round = 0
	_state = CombatState.STARTING

	var ordered := FormationManager.build_full_turn_order(heroes, enemies, surprised)
	turn_manager.set_turn_order(ordered)

	EventBus.combat_started.emit(_heroes, _enemies)
	combat_started.emit()
	_begin_round()

# ============================================================
# API PÚBLICA — ACCIONES DEL JUGADOR
# ============================================================

## Intenta mover al personaje activo a una celda del grid.
func player_move(destination: Vector2i) -> bool:
	if _state != CombatState.PLAYER_MOVE:
		return false
	if _active_character == null:
		return false

	var distance := grid.get_distance(_active_character.grid_position, destination)
	if not grid.move_character(_active_character, destination):
		return false

	_active_character.register_move(distance)

	# Si ya no puede moverse más, pasar a fase de acción
	if not _active_character.can_move():
		_state = CombatState.PLAYER_ACTION
		waiting_for_player_input.emit(_active_character)

	return true

## El jugador usa una habilidad o conjuro con el personaje activo.
func player_use_ability(ability: AbilityData, targets: Array[BaseCharacter], slot_level: int = -1) -> void:
	if _state != CombatState.PLAYER_MOVE and _state != CombatState.PLAYER_ACTION:
		return
	if _active_character == null or not _active_character.is_hero:
		return

	var is_spell := ability is SpellData
	var spell    := ability as SpellData

	# ── Economía de acción ───────────────────────────────────
	if is_spell and spell.is_bonus_action():
		if not _active_character.can_bonus_act():
			EventBus.narrator_bark.emit("Ya has usado tu acción adicional este turno.", 2.0)
			return
	elif is_spell and spell.is_reaction():
		if not _active_character.can_react():
			EventBus.narrator_bark.emit("Ya has usado tu reacción este turno.", 2.0)
			return
	else:
		if not _active_character.can_act():
			EventBus.narrator_bark.emit("Ya has actuado este turno.", 2.0)
			return

	# ── Truco (nivel 0): sin espacio de conjuro ───────────────
	if is_spell and spell.is_cantrip():
		_resolve_spell(_active_character, spell, targets, 0)
		return

	# ── Conjuro: consumir espacio ─────────────────────────────
	if is_spell:
		var needed_level := spell.spell_level if slot_level < spell.spell_level else slot_level
		var consumed := _active_character.spell_slots.spend(needed_level)
		if consumed == 0:
			EventBus.narrator_bark.emit("No te quedan espacios de conjuro de nivel %d." % needed_level, 2.5)
			return
		_resolve_spell(_active_character, spell, targets, consumed)
		return

	# ── Habilidad normal (no conjuro) ─────────────────────────
	_resolve_action(_active_character, ability, targets)

## Lanza un conjuro gestionando concentración y acción.
func _resolve_spell(user: BaseCharacter, spell: SpellData, targets: Array[BaseCharacter], slot_level: int) -> void:
	# Si requiere concentración, romper la anterior
	if spell.requires_concentration:
		if user.stats.is_concentrating():
			user.stats.break_concentration()
		user.stats.start_concentration(spell.ability_id)

	# Ajustar dados de daño por upcast
	var effective_spell := spell
	if slot_level > spell.spell_level and spell.upcast_dice_per_slot > 0:
		effective_spell = spell.duplicate() as SpellData
		effective_spell.damage_dice_count = spell.effective_upcast_dice(slot_level)

	# Resolver con el mismo resolver que las habilidades físicas
	EventBus.ability_used.emit(user, spell, targets)
	combat_resolver.resolve(user, effective_spell, targets)

	# Marcar acción usada según tipo
	if spell.is_bonus_action():
		user.use_bonus_action()
	elif spell.is_reaction():
		user.use_reaction()
	else:
		_resolve_action_bookkeeping(user)

func _resolve_action_bookkeeping(_user: BaseCharacter) -> void:
	_check_combat_end()

## El jugador termina el turno sin actuar.
func player_end_turn() -> void:
	if _state != CombatState.PLAYER_MOVE and _state != CombatState.PLAYER_ACTION:
		return
	_active_character.end_turn()
	_check_combat_end()

# ============================================================
# GETTERS
# ============================================================

func get_active_character() -> BaseCharacter:
	return _active_character

func get_heroes() -> Array[BaseCharacter]:
	return _heroes

func get_enemies() -> Array[BaseCharacter]:
	return _enemies

func get_round() -> int:
	return _current_round

func get_reachable_cells() -> Array[Vector2i]:
	if _active_character == null:
		return []
	return grid.get_reachable_cells(_active_character)

func get_targets_in_range(ability: AbilityData) -> Array[BaseCharacter]:
	if _active_character == null:
		return []
	return grid.get_characters_in_range(_active_character.grid_position, ability.range_tiles)

## Cuántos ataques le quedan al personaje activo en este turno.
func get_attacks_remaining() -> int:
	if _active_character == null:
		return 0
	return _active_character.stats.get_attack_count() - _attacks_this_turn

## Activar rasgo de clase desde la UI.
func player_use_class_feature(feature_id: String, target: BaseCharacter = null) -> bool:
	if _active_character == null or not _active_character.is_hero:
		return false
	match feature_id:
		"tomar_aliento":
			return _active_character.use_second_wind()
		"accion_subita":
			return _active_character.use_action_surge()
		"inspiracion_bardica":
			if target == null:
				return false
			return _active_character.give_bardic_inspiration(target)
		"imponer_manos":
			if target == null:
				return false
			return _active_character.lay_on_hands(target, 5)  # 5 PG por defecto
		"rafaga_de_golpes":
			return _active_character.use_flurry_of_blows()
		"golpe_aturdidor":
			if target == null:
				return false
			return _active_character.use_stunning_strike(target)
		"enemigo_predilecto":
			return _active_character.use_favored_enemy()
	return false

# ============================================================
# FLUJO INTERNO
# ============================================================

func _begin_round() -> void:
	_current_round += 1
	round_started.emit(_current_round)
	EventBus.round_started.emit(_current_round)

	# Reconstruir orden cada ronda respetando quién sigue vivo
	var all_alive := (_heroes + _enemies).filter(
		func(c: BaseCharacter) -> bool: return c.is_alive()
	)
	# Mantener el orden original, filtrando muertos
	var current_order := turn_manager.get_turn_order()
	var new_order: Array[BaseCharacter] = []
	for c in current_order:
		if c.is_alive():
			new_order.append(c)
	turn_manager.set_turn_order(new_order)

	_process_next_turn()

func _process_next_turn() -> void:
	_active_character = turn_manager.get_next_character()

	if _active_character == null:
		_begin_round()
		return

	_attacks_this_turn = 0  # reset de Extra Attack al inicio de cada turno
	_active_character.begin_turn()

	if _active_character.is_hero:
		_state = CombatState.PLAYER_MOVE
		waiting_for_player_input.emit(_active_character)
	else:
		_state = CombatState.ENEMY_TURN
		_run_enemy_turn(_active_character)

func _resolve_action(user: BaseCharacter, ability: AbilityData, targets: Array[BaseCharacter]) -> void:
	_state = CombatState.RESOLVING
	EventBus.ability_used.emit(user, ability, targets)
	combat_resolver.resolve(user, ability, targets)
	_attacks_this_turn += 1

	# Extra Attack: si puede atacar más veces esta acción, no consumir el turno
	var max_attacks := user.stats.get_attack_count()
	if ability.ability_type == AbilityData.AbilityType.ATTACK and _attacks_this_turn < max_attacks:
		_state = CombatState.PLAYER_ACTION  # puede volver a atacar
		waiting_for_player_input.emit(user)
		return

	user.end_turn()
	_check_combat_end()

func _run_enemy_turn(enemy: BaseCharacter) -> void:
	var abilities := enemy.get_abilities()
	if abilities.is_empty():
		enemy.end_turn()
		_process_next_turn()
		return

	# IA básica: moverse hacia el héroe más cercano y atacar si está en rango
	var nearest := _get_nearest_hero(enemy)
	if nearest == null:
		_end_combat(false)
		return

	var ability: AbilityData = abilities[0]
	var dist := grid.get_distance(enemy.grid_position, nearest.grid_position)

	# Moverse si el objetivo no está en rango
	if dist > ability.range_tiles:
		_move_toward(enemy, nearest.grid_position)

	# Atacar si ahora está en rango
	dist = grid.get_distance(enemy.grid_position, nearest.grid_position)
	if dist <= ability.range_tiles:
		_resolve_action(enemy, ability, [nearest])
	else:
		enemy.end_turn()
		_check_combat_end()

func _move_toward(character: BaseCharacter, target_cell: Vector2i) -> void:
	var reachable := grid.get_reachable_cells(character)
	if reachable.is_empty():
		return
	# Elegir la casilla alcanzable más cercana al objetivo
	reachable.sort_custom(func(a: Vector2i, b: Vector2i) -> bool:
		return grid.get_distance(a, target_cell) < grid.get_distance(b, target_cell)
	)
	var best := reachable[0]
	var dist := grid.get_distance(character.grid_position, best)
	grid.move_character(character, best)
	character.register_move(dist)

func _get_nearest_hero(enemy: BaseCharacter) -> BaseCharacter:
	var nearest: BaseCharacter = null
	var min_dist := 99999
	for hero in _heroes:
		if not hero.is_alive():
			continue
		var d := grid.get_distance(enemy.grid_position, hero.grid_position)
		if d < min_dist:
			min_dist = d
			nearest = hero
	return nearest

# ============================================================
# FIN DE COMBATE
# ============================================================

func _check_combat_end() -> void:
	var heroes_alive  := _heroes.any(func(h: BaseCharacter) -> bool: return h.is_alive())
	var enemies_alive := _enemies.any(func(e: BaseCharacter) -> bool: return e.is_alive())

	if not heroes_alive:
		_end_combat(false)
	elif not enemies_alive:
		_end_combat(true)
	else:
		_process_next_turn()

func _end_combat(victory: bool) -> void:
	_state = CombatState.ENDED

	# Limpiar condiciones post-combate (resaca, exhausto_nado, etc.) de los héroes
	if victory:
		for hero in _heroes:
			if hero.is_alive() and hero.data != null:
				hero.stats.clear_post_combat_conditions()
				# Sincronizar con CharacterData: limpiar persistent_conditions que se eliminan
				hero.data.persistent_conditions = hero.data.persistent_conditions.filter(
					func(c: String) -> bool: return not ConditionDefs.removes_after_combat(c)
				)

	combat_ended.emit(victory)
	EventBus.combat_ended.emit(victory, {})
