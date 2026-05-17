## rest_manager.gd
## Gestiona descansos cortos y largos (D&D 2024).
##
## DESCANSO CORTO (1 hora):
##   Gastar dados de golpe → recuperar PG (1dX + mod CON por dado)
##   Recarga rasgos marcados como "short_rest"
##   No recupera espacios de conjuro (excepto Brujo)
##
## DESCANSO LARGO (8 horas):
##   PG al máximo, todos los dados de golpe recuperados
##   Todos los espacios de conjuro recuperados
##   Cansancio -1 nivel
##   Recarga todos los rasgos

extends Node

# ============================================================
# SEÑALES
# ============================================================
signal short_rest_completed(characters: Array[BaseCharacter])
signal long_rest_completed(characters: Array[BaseCharacter])

# ============================================================
# SINTONÍA — cola de cambios pendientes para el descanso largo
## Clave: character_id | Valor: Array[{item_id: String, attune: bool}]
# ============================================================
var _attunement_queue: Dictionary = {}

func _ready() -> void:
	EventBus.attunement_change_requested.connect(_on_attunement_requested)

func _on_attunement_requested(character_id: String, item_id: String, attune: bool) -> void:
	if not _attunement_queue.has(character_id):
		_attunement_queue[character_id] = []
	# Reemplazar solicitud previa para el mismo item (evita duplicados)
	var _queue_arr: Array = _attunement_queue[character_id]
	_attunement_queue[character_id] = _queue_arr.filter(
		func(r: Dictionary) -> bool: return r["item_id"] != item_id
	)
	_attunement_queue[character_id].append({"item_id": item_id, "attune": attune})

# ============================================================
# DESCANSO CORTO
# ============================================================

## party: Array de BaseCharacter activos.
## hit_dice_to_spend: Diccionario {character_id → int} cuántos dados gastar por personaje.
func short_rest(party: Array[BaseCharacter], hit_dice_to_spend: Dictionary = {}) -> void:
	for character in party:
		if not character.is_alive() and not character.is_dying():
			continue

		var dice_count: int = hit_dice_to_spend.get(
			character.data.character_id if character.data else "", 0
		)
		if dice_count > 0:
			_spend_hit_dice(character, dice_count)

		# Recuperar slots de Magia de Pacto (Brujo)
		if character.spell_slots.get_caster_type() == SpellSlots.CasterType.PACT:
			character.spell_slots.restore_pact_slots()

		# Recuperar usos de rasgos de descanso corto (Canal Divinidad, etc.)
		_restore_short_rest_features(character)

	short_rest_completed.emit(party)
	EventBus.narrator_bark.emit("El grupo descansa una hora.", 3.0)

## Gasta dados de golpe para recuperar PG en un descanso corto.
func _spend_hit_dice(character: BaseCharacter, count: int) -> void:
	if character.data == null:
		return
	var con_mod: int = character.stats.get_modifier("con")
	var total_healed: int = 0
	for i in count:
		var roll := RngManager.randi_range(1, character.stats.hit_dice_sides)
		var healed := maxi(1, roll + con_mod)
		character.heal(healed)
		total_healed += healed
	EventBus.narrator_bark.emit(
		"%s recupera %d PG (dados de golpe)." % [character.get_display_name(), total_healed],
		3.0
	)

func _restore_short_rest_features(character: BaseCharacter) -> void:
	# Canalizar Divinidad (Paladín nivel 3+): recupera 1 uso en descanso corto
	# Se implementará en el sistema de rasgos de clase cuando llegue ese sprint
	pass

# ============================================================
# DESCANSO LARGO
# ============================================================

func long_rest(party: Array[BaseCharacter]) -> void:
	for character in party:
		# Estabilizar si estaba agonizando
		if character.is_dying():
			character._stabilize()

		if not character.is_alive():
			continue

		# PG al máximo
		var old_hp: int = character.stats.current_health
		character.stats.current_health = character.stats.max_health
		if character.stats.current_health != old_hp:
			character.health_changed.emit(character.stats.current_health, character.stats.max_health)

		# Estrés: reduce 10 puntos (mechanic propia de Vestigios)
		character.reduce_stress(10)

		# Todos los espacios de conjuro recuperados
		character.spell_slots.restore_all()

		# Cansancio: -1 nivel
		_reduce_exhaustion(character)

		# Limpiar condiciones que terminan con descanso largo
		_clear_long_rest_conditions(character)

		# Procesar sintonías solicitadas por el jugador
		_process_pending_attunements(character)

		# Persistir cambios en CharacterData
		if character.data:
			character.data.persistent_conditions = character.stats.get_active_conditions().filter(
				func(c: String) -> bool: return ConditionDefs.is_persistent(c)
			)

	long_rest_completed.emit(party)
	EventBus.narrator_bark.emit("El grupo descansa. Amanece un nuevo día.", 3.0)

func _reduce_exhaustion(character: BaseCharacter) -> void:
	for i in 5:
		var cond := "cansancio_%d" % (5 - i)
		if character.stats.has_condition(cond):
			character.stats.remove_condition(cond)
			var next_level := 4 - i
			if next_level > 0:
				character.stats.add_condition("cansancio_%d" % next_level)
			break

func _clear_long_rest_conditions(character: BaseCharacter) -> void:
	# Las condiciones de corta duración (veneno, etc.) dependen de su fuente;
	# aquí solo limpiamos las que expresamente duran hasta descanso largo
	character.stats.clear_post_combat_conditions()

# ============================================================
# SINTONÍA — procesamiento al completar descanso largo
# ============================================================

func _process_pending_attunements(character: BaseCharacter) -> void:
	if character.data == null:
		return
	var char_id := character.data.character_id
	var requests: Array = _attunement_queue.get(char_id, [])
	for req in requests:
		var item_id: String = req["item_id"]
		var should_attune: bool = req["attune"]
		if should_attune:
			_try_attune(character, item_id)
		else:
			_do_unattune(character, item_id)
	_attunement_queue.erase(char_id)

func _try_attune(character: BaseCharacter, item_id: String) -> void:
	if character.data == null:
		return
	var magic := MagicItemDatabase.find(item_id)
	if magic == null or magic.attunement == MagicItemData.Attunement.NONE:
		return
	if not character.data.can_attune_item(magic):
		EventBus.narrator_bark.emit(
			"%s no puede sintonizar más objetos (máximo 3)." % character.get_display_name(), 3.0
		)
		return
	character.data.attune(item_id)
	# Si el objeto está equipado, aplicar su bonus ahora
	character.stats.apply_equipment_bonus(item_id, character.data)
	EventBus.item_attuned.emit(character.data.character_id, item_id)
	EventBus.narrator_bark.emit(
		"%s sintoniza: %s." % [character.get_display_name(), item_id], 2.5
	)

func _do_unattune(character: BaseCharacter, item_id: String) -> void:
	if character.data == null:
		return
	character.stats.remove_equipment_bonus(item_id)
	character.data.unattune(item_id)
	EventBus.item_unattuned.emit(character.data.character_id, item_id)
	EventBus.narrator_bark.emit(
		"%s pierde la sintonía con: %s." % [character.get_display_name(), item_id], 2.5
	)
