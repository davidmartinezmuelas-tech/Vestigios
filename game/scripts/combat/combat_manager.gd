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

	# ── Componentes de conjuro (D&D 2024) ────────────────────
	# Material (M): no implementado — simplificación de diseño
	if is_spell:
		var block := _check_spell_components(spell, _active_character)
		if not block.is_empty():
			EventBus.narrator_bark.emit(block, 3.0)
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

## Comprueba si las condiciones del lanzador bloquean algún componente del conjuro.
## Devuelve string de error (no vacío = bloqueado) o "" si puede lanzar.
func _check_spell_components(spell: SpellData, caster: BaseCharacter) -> String:
	var comps: Array[String] = spell.components

	# VERBAL (V): bloqueado por ensordecido (no puede hablar) o zona de Silencio
	if "v" in comps:
		if caster.stats.has_condition("ensordecido") or caster.stats.has_condition("en_silencio"):
			return "%s no puede pronunciar los componentes verbales." % caster.get_display_name()

	# SOMÁTICO (S): bloqueado por apresado (manos inmovilizadas)
	if "s" in comps:
		if caster.stats.has_condition("apresado"):
			return "%s no puede realizar los gestos somáticos." % caster.get_display_name()

	return ""

func _resolve_action_bookkeeping(_user: BaseCharacter) -> void:
	_check_combat_end()

## El jugador termina el turno sin actuar.
func player_end_turn() -> void:
	if _state != CombatState.PLAYER_MOVE and _state != CombatState.PLAYER_ACTION:
		return
	_active_character.end_turn()
	_check_combat_end()

# ============================================================
# ACCIÓN: BUSCAR (Search)
## Prueba de Sabiduría (Percepción) activa.
## CD 10 → enemigos ocultos en rango
## CD 15 → también trampas en rango
## CD 20 → también objetos del entorno interactuables
# ============================================================

func player_search_action() -> void:
	if _state != CombatState.PLAYER_MOVE and _state != CombatState.PLAYER_ACTION:
		return
	if _active_character == null or not _active_character.can_act():
		return

	var char := _active_character
	var wis_mod     := char.stats.get_modifier("wis")
	var prof_bonus  := char.stats.proficiency_bonus
	var roll        := RngManager.randi_range(1, 20) + wis_mod + prof_bonus
	var search_range := 6  # 30ft = 6 casillas de radio

	var found_anything := false

	# CD 10+: objetos del entorno (barriles, lámparas, elementos interactuables)
	# Son estáticos y visibles si sabes dónde mirar
	if roll >= 10 and grid != null:
		var objs := grid.get_env_objects_in_range(char.grid_position, search_range)
		for obj in objs:
			if not obj.get("revealed", false):
				grid.reveal_env_object(obj["cell"])
				EventBus.narrator_bark.emit(
					"%s nota: %s — %s" % [char.get_display_name(), obj.get("name","?"), obj.get("description","")],
					3.0
				)
				found_anything = true

	# CD 15+: trampas y enemigos que se han OCULTADO (oculto)
	# Las trampas son estáticas pero disimuladas. Los ocultos se mueven poco.
	if roll >= 15:
		if grid != null:
			var traps := grid.get_traps_in_range(char.grid_position, search_range)
			for cell in traps:
				if not grid.is_trap_revealed(cell):
					grid.reveal_trap(cell)
					var trap := grid.get_trap(cell)
					EventBus.narrator_bark.emit(
						"¡%s detecta una trampa! (%s)" % [char.get_display_name(), trap.get("damage_dice", "?")],
						3.5
					)
					found_anything = true

		for enemy in _enemies:
			if not enemy.is_alive():
				continue
			if enemy.stats.has_condition("oculto"):
				if grid.get_distance(char.grid_position, enemy.grid_position) <= search_range:
					enemy.stats.remove_condition("oculto")
					EventBus.narrator_bark.emit(
						"%s localiza a %s, que se había ocultado." % [char.get_display_name(), enemy.get_display_name()],
						3.5
					)
					found_anything = true

	# CD 20+: enemigos INVISIBLES (invisibilidad mágica)
	# No se ven, pero se pueden detectar por sonido, desplazamiento de aire o presencia mágica.
	# Solo se revela su posición aproximada — siguen siendo invisibles pero atacables sin desventaja.
	if roll >= 20:
		for enemy in _enemies:
			if not enemy.is_alive():
				continue
			if enemy.stats.has_condition("invisible"):
				if grid.get_distance(char.grid_position, enemy.grid_position) <= search_range:
					# No eliminamos 'invisible' — solo añadimos 'posicion_revelada' para la UI
					enemy.stats.add_condition("posicion_revelada", 2)
					EventBus.narrator_bark.emit(
						"%s intuye la presencia de %s por sus movimientos. Posición aproximada revelada." % [
							char.get_display_name(), enemy.get_display_name()
						], 4.0
					)
					found_anything = true

	if not found_anything:
		var result_text := "No detecta nada fuera de lo normal." if roll < 15 else "El área parece despejada."
		EventBus.narrator_bark.emit(
			"%s busca... %s (tirada %d)" % [char.get_display_name(), result_text, roll],
			2.5
		)

	char.end_turn()
	_check_combat_end()

# ============================================================
# ACCIÓN: ESTUDIAR (Study)
## Prueba de Inteligencia activa sobre un objetivo.
## CD 10 → rango aproximado de PG (sano/herido/crítico)
## CD 15 → resistencias e inmunidades conocidas
## CD 20 → revela una apertura (ventaja en el próximo ataque vs este objetivo)
# ============================================================

func player_study_action(target: BaseCharacter) -> void:
	if _state != CombatState.PLAYER_MOVE and _state != CombatState.PLAYER_ACTION:
		return
	if _active_character == null or not _active_character.can_act():
		return
	if target == null or not target.is_alive():
		return

	var char   := _active_character
	var int_mod    := char.stats.get_modifier("int")
	var prof_bonus := char.stats.proficiency_bonus
	var roll       := RngManager.randi_range(1, 20) + int_mod + prof_bonus

	var enemy_id := target.data.character_id if target.data else ""
	var knowledge := WorldState.enemy_knowledge

	if roll >= 20:
		# Estudio completo: revela todo + apertura táctica
		knowledge.study_enemy(enemy_id, [], [])
		# Aplica condición de "punto débil revelado" en el objetivo
		target.stats.add_condition("punto_debil_revelado", 3)
		EventBus.narrator_bark.emit(
			"%s estudia a %s — encuentra una apertura. Ventaja en los próximos ataques." % [
				char.get_display_name(), target.get_display_name()
			], 4.0
		)
	elif roll >= 15:
		# Revela resistencias/inmunidades (subida a FAMILIAR)
		knowledge.study_enemy(enemy_id, [], [])
		EventBus.narrator_bark.emit(
			"%s analiza a %s. Resistencias y vulnerabilidades reveladas." % [
				char.get_display_name(), target.get_display_name()
			], 3.5
		)
	elif roll >= 10:
		# Estado de salud aproximado
		knowledge.sight_enemy(enemy_id)
		var hp_pct := target.stats.health_percentage()
		var state_text := "parece sano" if hp_pct > 0.6 else ("está herido" if hp_pct > 0.25 else "está al límite")
		EventBus.narrator_bark.emit(
			"%s evalúa a %s — %s." % [
				char.get_display_name(), target.get_display_name(), state_text
			], 3.0
		)
	else:
		EventBus.narrator_bark.emit(
			"%s no consigue leer a %s. (tirada %d)" % [
				char.get_display_name(), target.get_display_name(), roll
			], 2.5
		)

	char.end_turn()
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

	if victory:
		# Limpiar condiciones post-combate de los héroes
		for hero in _heroes:
			if hero.is_alive() and hero.data != null:
				hero.stats.clear_post_combat_conditions()
				hero.data.persistent_conditions = hero.data.persistent_conditions.filter(
					func(c: String) -> bool: return not ConditionDefs.removes_after_combat(c)
				)

		# Generar loot de los enemigos derrotados
		_generate_loot()

	combat_ended.emit(victory)
	EventBus.combat_ended.emit(victory, {})

func _generate_loot() -> void:
	var loot_parts: Array[String] = []

	for enemy in _enemies:
		if enemy.data == null:
			continue

		var data := enemy.data

		# Loot table explícita (bosses y enemigos especiales)
		if data.loot_table != null:
			var result := data.loot_table.generate()
			if not result.is_empty():
				loot_parts.append(result)
			continue

		# Enemigos básicos: solo oro basado en CR
		# El equipo del enemigo queda destruido por el combate
		if not data.is_boss:
			var gold := _gold_for_cr(data.challenge_rating)
			if gold > 0:
				WorldState.add_gold(gold)
				loot_parts.append("%d PO" % gold)

	if not loot_parts.is_empty():
		EventBus.narrator_bark.emit(
			"Obtenéis: %s." % ", ".join(loot_parts), 3.5
		)

## Devuelve el oro aproximado que suelta un enemigo según su CR.
## Fórmula basada en la tabla de Individual Treasure (D&D 2024 DMG).
static func _gold_for_cr(cr: float) -> int:
	if cr <= 0:
		return 0
	if cr < 0.5:
		return RngManager.randi_range(1, 3)      # CR 1/8-1/4: 1-3 PO
	if cr < 1.0:
		return RngManager.randi_range(2, 6)      # CR 1/2: 2-6 PO
	if cr < 3.0:
		return RngManager.randi_range(3, 12)     # CR 1-2: 3-12 PO
	if cr < 6.0:
		return RngManager.randi_range(10, 30)    # CR 3-5: 10-30 PO
	if cr < 11.0:
		return RngManager.randi_range(30, 90)    # CR 6-10: 30-90 PO
	return RngManager.randi_range(100, 300)      # CR 11+: 100-300 PO
