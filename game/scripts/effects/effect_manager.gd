## effect_manager.gd
## Nodo hijo de BaseCharacter. Gestiona efectos temporales activos (DOT, buffs, debuffs).
## Aplica y elimina modificadores de stats, y procesa efectos al inicio de cada turno.

class_name EffectManager
extends Node

# ============================================================
# SEÑALES
# ============================================================
signal effect_applied(effect: EffectData)
signal effect_expired(effect: EffectData)

# ============================================================
# ESTADO
# ============================================================
## Lista de efectos activos: {data: EffectData, rounds_remaining: int}
var _active_effects: Array[Dictionary] = []

# Variable cacheada para acceder al personaje padre
var _character: BaseCharacter = null

func _ready() -> void:
	_character = get_parent() as BaseCharacter

# ============================================================
# API PÚBLICA
# ============================================================

func apply_effect(effect: EffectData) -> void:
	# Si ya tiene el mismo efecto, reinicia la duración
	for active in _active_effects:
		if active["data"].effect_id == effect.effect_id:
			active["rounds_remaining"] = effect.duration_rounds
			return

	_active_effects.append({
		"data": effect,
		"rounds_remaining": effect.duration_rounds,
	})
	_apply_stat_modifier(effect, true)
	effect_applied.emit(effect)
	EventBus.effect_applied.emit(_character, effect)

func remove_effect(effect_id: String) -> void:
	for i in _active_effects.size():
		if _active_effects[i]["data"].effect_id == effect_id:
			_apply_stat_modifier(_active_effects[i]["data"], false)
			var expired: EffectData = _active_effects[i]["data"]
			_active_effects.remove_at(i)
			effect_expired.emit(expired)
			EventBus.effect_expired.emit(_character, expired)
			return

func has_effect(effect_id: String) -> bool:
	return _active_effects.any(func(e): return e["data"].effect_id == effect_id)

func get_active_effects() -> Array[EffectData]:
	var result: Array[EffectData] = []
	for entry in _active_effects:
		result.append(entry["data"])
	return result

## Llama esto al inicio del turno del personaje.
## Procesa DOTs y decrementa duraciones.
func process_turn_start() -> void:
	var to_remove: Array[String] = []

	for entry in _active_effects:
		var effect: EffectData = entry["data"]
		_process_dot(effect)
		entry["rounds_remaining"] -= 1
		if entry["rounds_remaining"] <= 0:
			to_remove.append(effect.effect_id)

	for id in to_remove:
		remove_effect(id)

func clear_all_effects() -> void:
	for entry in _active_effects.duplicate():
		remove_effect(entry["data"].effect_id)

# ============================================================
# INTERNO
# ============================================================

func _process_dot(effect: EffectData) -> void:
	if _character == null or not _character.is_alive():
		return

	match effect.effect_type:
		EffectData.EffectType.BLEED, EffectData.EffectType.BURN:
			var damage := effect.value
			if damage > 0:
				_character.take_damage(damage)
				EventBus.damage_dealt.emit(_character, damage, false)

		EffectData.EffectType.POISON:
			var damage := effect.value
			if damage > 0:
				# El veneno ignora resistencias — se aplica directo a HP
				_character.stats.current_health -= damage
				_character.health_changed.emit(_character.stats.current_health, _character.stats.max_health)
				EventBus.damage_dealt.emit(_character, damage, false)

		EffectData.EffectType.STRESS_HEAL:
			if effect.value > 0:
				_character.reduce_stress(effect.value)

func _apply_stat_modifier(effect: EffectData, adding: bool) -> void:
	if effect.stat_to_modify.is_empty():
		return
	if _character == null:
		return

	var value: int = effect.stat_modifier_value if effect.stat_modifier_value is int else int(effect.stat_modifier_value)
	if not adding:
		value = -value

	_character.stats.add_temp_modifier(effect.stat_to_modify, value)
