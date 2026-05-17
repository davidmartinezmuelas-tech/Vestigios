## combat_resolver.gd
## Resuelve ataques, conjuros y efectos de maestría (D&D 2024).
##
## FLUJO DE UN ATAQUE:
##   1. Tirada de ataque (1d20 + mod + competencia, con ventaja/desventaja)
##   2. Pifia (1) → fallo automático
##   3. ROZAR: si falla pero no es pifia → daño = mod característica
##   4. Comparar total con CA del objetivo (20 natural = hit siempre)
##   5. Crítico o acierto normal → calcular daño (crítico: dados x2)
##   6. Aplicar efecto de MAESTRÍA si has_weapon_mastery = true
##   7. Aplicar efectos del ability (condiciones, efectos, DOT)

class_name CombatResolver
extends Node

# ============================================================
# REFERENCIA AL GRID (para Empujar, Hender)
# ============================================================
var _grid: CombatGrid = null

func setup(grid: CombatGrid) -> void:
	_grid = grid

# ============================================================
# API PÚBLICA
# ============================================================

func resolve(user: BaseCharacter, ability: AbilityData, targets: Array[BaseCharacter]) -> void:
	match ability.ability_type:
		AbilityData.AbilityType.ATTACK, AbilityData.AbilityType.SPELL_ATTACK:
			for target in targets:
				_resolve_attack(user, ability, target)
		AbilityData.AbilityType.SAVING_THROW:
			for target in targets:
				_resolve_saving_throw(user, ability, target)
		AbilityData.AbilityType.HEAL:
			for target in targets:
				_resolve_heal(user, ability, target)
		AbilityData.AbilityType.BUFF, AbilityData.AbilityType.DEBUFF:
			for target in targets:
				_apply_effects(user, ability, target)

# ============================================================
# TIRADA DE ATAQUE
# ============================================================

func _resolve_attack(user: BaseCharacter, ability: AbilityData, target: BaseCharacter) -> void:
	# ── Ventaja / Desventaja ──────────────────────────────────
	var adv    := user.stats.has_attack_advantage()
	var disadv := user.stats.has_attack_disadvantage()

	# MOLESTAR: ventaja contra este objetivo específico
	var target_id := target.data.character_id if target.data else ""
	if not user.stats.mastery_advantage_vs.is_empty() and user.stats.mastery_advantage_vs == target_id:
		adv = true
		user.stats.mastery_advantage_vs = ""

	# Objetivo fuerza ventaja al atacante (aturdido, cegado, etc.)
	if target.stats.attackers_have_advantage():
		adv = true

	# Objetivo invisible: desventaja para el atacante
	# EXCEPTO si la posición ha sido revelada con la acción Buscar
	if target.stats.has_condition("invisible") and not target.stats.has_condition("posicion_revelada"):
		disadv = true

	# Tirar d20
	var d20: int
	if disadv and not adv:
		d20 = mini(RngManager.randi_range(1, 20), RngManager.randi_range(1, 20))
	elif adv and not disadv:
		d20 = maxi(RngManager.randi_range(1, 20), RngManager.randi_range(1, 20))
	else:
		d20 = RngManager.randi_range(1, 20)

	var is_pifia    := d20 == 1
	var is_critical := d20 == 20

	# ── Pifia: fallo automático, sin Rozar ───────────────────
	if is_pifia:
		EventBus.attack_missed.emit(user, target)
		return

	var attack_total := d20 + _attack_bonus(user, ability)

	# ── COBERTURA: comprobar si el objetivo tiene cover ───────
	var cover_bonus := _get_cover_bonus(user, target)
	if cover_bonus == CombatGrid.COVER_FULL:
		# Cobertura total — no se puede atacar
		EventBus.narrator_bark.emit(
			"%s tiene cobertura total — no puede ser atacado." % target.get_display_name(), 2.5
		)
		return
	var effective_ac := target.stats.armor_class + cover_bonus

	# ── Fallo normal: intentar Rozar ─────────────────────────
	if not is_critical and attack_total < effective_ac:
		_maybe_apply_rozar(user, ability, target)
		EventBus.attack_missed.emit(user, target)
		if cover_bonus > 0:
			EventBus.narrator_bark.emit(
				"Fallo — %s tiene %s." % [
					target.get_display_name(),
					CombatGrid.cover_label(cover_bonus)
				], 2.0
			)
		return

	# ── GOLPE ─────────────────────────────────────────────────
	var damage := _roll_damage(user, ability, is_critical)

	# ATAQUE FURTIVO (Pícaro): si procede, añadir dados extra
	var sneak_damage := _try_sneak_attack(user, target, ability, is_critical)
	damage += sneak_damage

	target.take_damage(damage)
	EventBus.damage_dealt.emit(target, damage, is_critical)

	if damage > 0:
		var stress := int(damage * Constants.STRESS_PER_DAMAGE)
		if stress > 0:
			target.apply_stress(stress)

	# Efectos del ability (condiciones, DOT, etc.)
	_apply_effects(user, ability, target)

	# Maestría — solo si el atacante la tiene
	if _has_mastery(user):
		_apply_mastery(user, ability, target, damage, is_critical)

# ============================================================
# MAESTRÍA (D&D 2024) — 8 PROPIEDADES
# ============================================================

func _apply_mastery(
	user: BaseCharacter, ability: AbilityData, target: BaseCharacter,
	damage: int, _is_critical: bool
) -> void:

	match ability.mastery_property:

		## DEBILITAR: objetivo con desventaja en su próxima tirada de ataque
		## (antes del inicio del próximo turno del usuario)
		AbilityData.MasteryProperty.DEBILITAR:
			target.stats.add_condition("debilitado_maestria", 2)
			EventBus.narrator_bark.emit(
				"%s debilita a %s." % [user.get_display_name(), target.get_display_name()],
				2.0
			)

		## DERRIBAR: salvación CON o queda Derribado
		## CD = 8 + mod_característica del atacante + BC
		AbilityData.MasteryProperty.DERRIBAR:
			var cd := 8 + user.stats.get_modifier(ability.attack_ability) + user.stats.proficiency_bonus
			var roll := RngManager.randi_range(1, 20) + target.stats.get_modifier("con")
			if roll < cd:
				target.stats.add_condition("derribado", -1)
				EventBus.effect_applied.emit(target, null)
				EventBus.narrator_bark.emit(
					"¡%s derriba a %s!" % [user.get_display_name(), target.get_display_name()],
					2.5
				)

		## EMPUJAR: mueve al objetivo 2 casillas (≈3m) en línea recta
		## Solo contra criaturas de tamaño Grande o menor
		AbilityData.MasteryProperty.EMPUJAR:
			_apply_push(user, target, 2)

		## HENDER: ataque cuerpo a cuerpo gratis contra una segunda criatura adyacente
		## Sin mod de característica al daño (salvo negativo). Una vez por turno.
		AbilityData.MasteryProperty.HENDER:
			if not user.stats.mastery_cleave_used and ability.range_tiles <= 1:
				_apply_cleave(user, ability, target)

		## MELLAR: el extra de arma ligera se hace como parte de Atacar, no Acción Adicional
		## La economía de acción se gestiona en CombatManager. Aquí no hay efecto directo.
		AbilityData.MasteryProperty.MELLAR:
			pass

		## MOLESTAR: ventaja en el próximo ataque del usuario contra este mismo objetivo
		AbilityData.MasteryProperty.MOLESTAR:
			if damage > 0:
				var target_id := target.data.character_id if target.data else ""
				user.stats.mastery_advantage_vs = target_id

		## RALENTIZAR: velocidad -3m (no acumula si ya está ralentizado por maestría)
		AbilityData.MasteryProperty.RALENTIZAR:
			if damage > 0 and not target.stats.mastery_slowed:
				target.stats.add_temp_modifier("speed", -10)  # -10 ft ≈ -3 m
				target.stats.mastery_slowed = true
				EventBus.narrator_bark.emit(
					"%s queda ralentizado." % target.get_display_name(), 2.0
				)

		_:
			pass  # NONE, ROZAR se maneja antes del golpe

# ── ROZAR ──────────────────────────────────────────────────────

func _maybe_apply_rozar(user: BaseCharacter, ability: AbilityData, target: BaseCharacter) -> void:
	if ability.mastery_property != AbilityData.MasteryProperty.ROZAR:
		return
	if not _has_mastery(user):
		return
	var rozar_damage := maxi(0, user.stats.get_modifier(ability.attack_ability))
	if rozar_damage > 0:
		target.take_damage(rozar_damage)
		EventBus.damage_dealt.emit(target, rozar_damage, false)
		EventBus.narrator_bark.emit(
			"Rozar: %s causa %d daño a %s." % [
				user.get_display_name(), rozar_damage, target.get_display_name()
			],
			2.0
		)

# ── EMPUJAR ────────────────────────────────────────────────────

func _apply_push(pusher: BaseCharacter, target: BaseCharacter, tiles: int) -> void:
	if _grid == null:
		return
	var dir := (target.grid_position - pusher.grid_position)
	if dir == Vector2i.ZERO:
		return
	var step := Vector2i(clampi(dir.x, -1, 1), clampi(dir.y, -1, 1))
	var dest := target.grid_position
	for _i in tiles:
		var next := dest + step
		if _grid.is_in_bounds(next) and not _grid.is_occupied(next):
			dest = next
		else:
			break
	if dest != target.grid_position:
		_grid._occupants.erase(target.grid_position)
		_grid._occupants[dest] = target
		target.grid_position = dest
		target.grid_position = dest
		EventBus.narrator_bark.emit(
			"%s empuja a %s." % [pusher.get_display_name(), target.get_display_name()],
			2.0
		)

# ── HENDER ─────────────────────────────────────────────────────

func _apply_cleave(user: BaseCharacter, ability: AbilityData, first_target: BaseCharacter) -> void:
	if _grid == null:
		return
	# Buscar criatura enemiga adyacente al objetivo que también esté al alcance del usuario
	var adjacent := _grid.get_characters_in_range(first_target.grid_position, 1)
	for candidate in adjacent:
		if candidate == user or candidate == first_target:
			continue
		if candidate.is_hero == user.is_hero or not candidate.is_alive():
			continue
		if _grid.get_distance(user.grid_position, candidate.grid_position) > ability.range_tiles:
			continue

		# Ataque de Hender: tirada normal pero sin mod de característica al daño
		var d20 := RngManager.randi_range(1, 20)
		var total := d20 + _attack_bonus(user, ability)
		if d20 == 20 or total >= candidate.stats.armor_class:
			var base_dmg := _roll_dice(ability.damage_dice_count, ability.damage_dice_sides)
			var mod := user.stats.get_modifier(ability.attack_ability)
			if mod < 0:
				base_dmg += mod  # solo si es negativo
			base_dmg = maxi(1, base_dmg)
			candidate.take_damage(base_dmg)
			EventBus.damage_dealt.emit(candidate, base_dmg, d20 == 20)
			EventBus.narrator_bark.emit(
				"Hender: %s golpea a %s (%d daño)." % [
					user.get_display_name(), candidate.get_display_name(), base_dmg
				],
				3.0
			)

		user.stats.mastery_cleave_used = true
		break

# ============================================================
# TIRADA DE SALVACIÓN
# ============================================================

func _resolve_saving_throw(user: BaseCharacter, ability: AbilityData, target: BaseCharacter) -> void:
	var cd := ability.save_dc
	if cd == 0:
		cd = 8 + user.stats.proficiency_bonus + user.stats.get_modifier(ability.attack_ability)

	var base_roll := RngManager.randi_range(1, 20) + target.stats.get_modifier(ability.save_ability)

	# Cobertura en tiradas de DES (D&D 2024: +2/+5 al save, no a la CD)
	var cover_add := 0
	if ability.save_ability == "dex":
		cover_add = get_dex_save_cover_bonus(target, user.grid_position)

	var save_roll := base_roll + cover_add
	var passed    := save_roll >= cd

	var damage := _roll_damage(user, ability, false)
	if passed:
		damage = int(damage * ability.save_success_multiplier)

	if damage > 0:
		target.take_damage(damage)
		EventBus.damage_dealt.emit(target, damage, false)

	if not passed:
		_apply_effects(user, ability, target)

# ============================================================
# CURACIÓN
# ============================================================

func _resolve_heal(user: BaseCharacter, ability: AbilityData, target: BaseCharacter) -> void:
	var amount := _roll_dice(ability.damage_dice_count, ability.damage_dice_sides)
	if not ability.damage_ability.is_empty():
		amount += user.stats.get_modifier(ability.damage_ability)
	amount = maxi(1, amount)
	target.heal(amount)
	_apply_effects(user, ability, target)

# ============================================================
# FÓRMULAS
# ============================================================

## ── ATAQUE FURTIVO (Pícaro) ───────────────────────────────────
## Devuelve el daño extra en dados d6 si procede, 0 si no.
func _try_sneak_attack(user: BaseCharacter, target: BaseCharacter, ability: AbilityData, is_crit: bool) -> int:
	var sneak_dice := user.stats.get_sneak_attack_dice()
	if sneak_dice == 0:
		return 0
	# Solo con arma sutil o a distancia (comprobar también el arma equipada)
	var weapon := _resolve_weapon(user, ability)
	var is_finesse := ability.is_finesse or (weapon != null and weapon.is_finesse)
	if ability.range_tiles <= 1 and not is_finesse:
		return 0
	# ¿Tiene ventaja en el ataque O hay aliado adyacente?
	var has_advantage := user.stats.has_attack_advantage()
	var ally_adjacent := false
	if _grid != null:
		var nearby := _grid.get_characters_in_range(target.grid_position, 1)
		for c in nearby:
			if c != user and c != target and c.is_hero == user.is_hero and c.is_alive():
				ally_adjacent = true
				break
	if not has_advantage and not ally_adjacent:
		return 0
	if user.stats.has_attack_disadvantage():
		return 0  # ventaja + desventaja se anulan → no aplica
	var count := sneak_dice * 2 if is_crit else sneak_dice
	var extra := _roll_dice(count, 6)
	EventBus.narrator_bark.emit(
		"¡Ataque Furtivo! +%dd6 (%d daño extra)." % [sneak_dice, extra], 2.5
	)
	return extra

func _attack_bonus(user: BaseCharacter, ability: AbilityData) -> int:
	var bonus := user.stats.get_modifier(ability.attack_ability)
	if ability.uses_proficiency:
		bonus += user.stats.proficiency_bonus
	# Enhancement bonus de arma mágica equipada
	if user.data != null:
		bonus += user.stats.get_weapon_enhancement_bonus(user.data)
	return bonus

func _roll_damage(user: BaseCharacter, ability: AbilityData, is_critical: bool) -> int:
	var weapon := _resolve_weapon(user, ability)
	var dice_count: int
	var dice_sides: int
	if weapon != null:
		# Usar los dados del arma equipada
		dice_count = weapon.damage_dice_count
		dice_sides = weapon.damage_dice_sides
	else:
		dice_count = ability.damage_dice_count
		dice_sides = ability.damage_dice_sides
	var count := dice_count * 2 if is_critical else dice_count
	var dmg   := _roll_dice(count, dice_sides)
	if not ability.damage_ability.is_empty():
		dmg += user.stats.get_modifier(ability.damage_ability)
	# Enhancement bonus al daño
	if user.data != null:
		dmg += user.stats.get_weapon_enhancement_bonus(user.data)
	return maxi(1, dmg)

## Devuelve el WeaponData que el personaje usa para este ability.
## Solo aplica a abilities de tipo ATTACK; devuelve null para conjuros y curaciones.
func _resolve_weapon(user: BaseCharacter, ability: AbilityData) -> WeaponData:
	if user.data == null:
		return null
	if ability.ability_type != AbilityData.AbilityType.ATTACK:
		return null
	var main_weapon := user.stats.get_equipped_weapon(user.data)
	# Si el ability es de largo alcance y la mano principal es cuerpo a cuerpo,
	# intentar el slot COMPLEMENTO (ej: arco secundario)
	if ability.range_tiles > 2 and main_weapon != null and not main_weapon.is_ranged:
		var comp := user.stats.get_complement_weapon(user.data)
		if comp != null and comp.is_ranged:
			return comp
	return main_weapon

func _roll_dice(count: int, sides: int) -> int:
	if count <= 0 or sides <= 0:
		return 0
	var total := 0
	for _i in count:
		total += RngManager.randi_range(1, sides)
	return total

func _apply_effects(user: BaseCharacter, ability: AbilityData, target: BaseCharacter) -> void:
	for eff in ability.effects:
		if RngManager.roll() < eff.application_chance:
			target.effect_manager.apply_effect(eff)
			EventBus.effect_applied.emit(target, eff)

func _has_mastery(character: BaseCharacter) -> bool:
	return character.data != null and character.data.has_weapon_mastery

# ============================================================
# COBERTURA
# ============================================================

## Devuelve el bonus de cobertura del target respecto al atacante.
## Usa el grid si está disponible; si no, devuelve COVER_NONE.
func _get_cover_bonus(attacker: BaseCharacter, target: BaseCharacter) -> int:
	if _grid == null:
		return CombatGrid.COVER_NONE
	return _grid.get_cover_bonus(attacker.grid_position, target.grid_position)

## Devuelve el bonus de cobertura para tiradas de salvación de DES.
## Solo aplica la mitad del camino — la cobertura protege al defensor.
func get_dex_save_cover_bonus(target: BaseCharacter, origin_pos: Vector2i) -> int:
	if _grid == null:
		return 0
	var cover := _grid.get_cover_bonus(origin_pos, target.grid_position)
	if cover == CombatGrid.COVER_FULL:
		return 0  # cobertura total contra ataques, no contra AoE que te incluye
	return cover
