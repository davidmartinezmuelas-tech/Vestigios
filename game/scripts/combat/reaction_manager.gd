## reaction_manager.gd
## Gestiona las reacciones en combate (D&D 2024).
## Cada personaje tiene 1 reacción por ronda. Se reinicia al inicio de su turno.
##
## REACCIONES IMPLEMENTADAS:
##   Ataque de oportunidad — cuando un enemigo sale de tu alcance
##   (otras reacciones se añaden cuando se implementen los conjuros/rasgos)

class_name ReactionManager
extends Node

# ============================================================
# SEÑALES
# ============================================================
signal opportunity_attack_triggered(attacker: BaseCharacter, target: BaseCharacter)

# ============================================================
# ESTADO
# ============================================================
var _combat_manager: CombatManager = null
var _grid: CombatGrid = null

# ============================================================
# SETUP
# ============================================================

func setup(combat_manager: CombatManager, grid: CombatGrid) -> void:
	_combat_manager = combat_manager
	_grid = grid
	grid.character_moved.connect(_on_character_moved)

# ============================================================
# ATAQUE DE OPORTUNIDAD
# ============================================================

## Llamado por CombatGrid cuando un personaje se mueve.
## Comprueba si algún personaje adyacente puede y quiere reaccionar.
func _on_character_moved(character: BaseCharacter, from: Vector2i, _to: Vector2i) -> void:
	if _combat_manager == null or _grid == null:
		return

	# Solo provocan ataques de oportunidad al SALIR del alcance
	# (no al entrar, no al usar Destrabarse)
	if character.stats.has_condition("destrabado"):
		return

	var potential_reactors := _get_potential_reactors(character, from)
	for reactor in potential_reactors:
		if reactor.can_react():
			_trigger_opportunity_attack(reactor, character)
			break  # Solo 1 ataque de oportunidad por movimiento (limitación de implementación)

func _get_potential_reactors(mover: BaseCharacter, old_pos: Vector2i) -> Array[BaseCharacter]:
	var reactors: Array[BaseCharacter] = []
	# Buscar personajes adyacentes a la posición ANTERIOR (de donde salió)
	var nearby := _grid.get_characters_in_range(old_pos, 1)
	for character in nearby:
		if character == mover:
			continue
		# Solo reacciona si es enemigo y sigue vivo
		var is_enemy := character.is_hero != mover.is_hero
		if is_enemy and character.is_alive() and character.can_react():
			reactors.append(character)
	return reactors

func _trigger_opportunity_attack(attacker: BaseCharacter, target: BaseCharacter) -> void:
	attacker.use_reaction()
	opportunity_attack_triggered.emit(attacker, target)

	# Usar la primera habilidad de melé del atacante
	var melee_ability: AbilityData = _find_melee_ability(attacker)
	if melee_ability == null:
		return

	var resolver := _combat_manager.combat_resolver
	if resolver:
		resolver.resolve(attacker, melee_ability, [target])
		EventBus.narrator_bark.emit(
			"%s lanza un ataque de oportunidad contra %s." % [
				attacker.get_display_name(), target.get_display_name()
			],
			3.0
		)

func _find_melee_ability(character: BaseCharacter) -> AbilityData:
	for ability in character.get_abilities():
		if ability.range_tiles <= 1 and ability.ability_type == AbilityData.AbilityType.ATTACK:
			return ability
	return null

# ============================================================
# ACCIÓN DE DESTRABARSE
## Usar acción "Destrabarse" evita ataques de oportunidad ese turno.
# ============================================================

func use_disengage(character: BaseCharacter) -> void:
	character.stats.add_condition("destrabado", 1)  # dura 1 turno
	character.use_bonus_action()  # Destrabarse es acción adicional en 2024 para algunas clases
	EventBus.narrator_bark.emit(
		"%s se destraba — ningún ataque de oportunidad este turno." % character.get_display_name(),
		2.5
	)
