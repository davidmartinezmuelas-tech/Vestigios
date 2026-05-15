## bastion_manager.gd
## Gestiona el estado del Bastión: facilidades, defensores, turnos y eventos.
## Se integra con WorldState para serialización.

extends Node

# ============================================================
# SEÑALES
# ============================================================
signal facility_added(instance: BastionFacilityInstance)
signal facility_order_completed(instance: BastionFacilityInstance, result: Dictionary)
signal bastion_event_occurred(event_id: String, details: Dictionary)
signal defenders_changed(count: int)
signal bastion_level_changed(new_level: int)
signal npc_recruited(npc: BastionNPCData)

# ============================================================
# ESTADO
# ============================================================
var bastion_level: int = 1
var defenders: int = 0
var _facilities: Array[BastionFacilityInstance] = []
var _missions_since_last_order: int = 0
var _recruited_npcs: Array[BastionNPCData] = []

# ============================================================
# TABLA DE EVENTOS
# ============================================================
const EVENTS: Array[Dictionary] = [
	{"id": "all_is_well",         "min": 1,  "max": 50},
	{"id": "attack",              "min": 51, "max": 55},
	{"id": "criminal_hireling",   "min": 56, "max": 58},
	{"id": "extraordinary_opportunity", "min": 59, "max": 63},
	{"id": "friendly_visitors",   "min": 64, "max": 72},
	{"id": "guest",               "min": 73, "max": 76},
	{"id": "lost_hirelings",      "min": 77, "max": 79},
	{"id": "magical_discovery",   "min": 80, "max": 83},
	{"id": "refugees",            "min": 84, "max": 91},
	{"id": "request_for_aid",     "min": 92, "max": 98},
	{"id": "treasure",            "min": 99, "max": 100},
]

# ============================================================
# API PÚBLICA — FACILIDADES
# ============================================================

func add_facility(data: FacilityData) -> BastionFacilityInstance:
	if data.required_bastion_level > bastion_level:
		push_error("BastionManager: nivel de Bastión insuficiente para '%s'" % data.facility_id)
		return null

	var instance := BastionFacilityInstance.new()
	instance.facility_data = data
	instance.instance_id   = "%s_%d" % [data.facility_id, _count_of(data.facility_id)]
	_facilities.append(instance)
	facility_added.emit(instance)
	return instance

func get_facility(instance_id: String) -> BastionFacilityInstance:
	for f in _facilities:
		if f.instance_id == instance_id:
			return f
	return null

func get_all_facilities() -> Array[BastionFacilityInstance]:
	return _facilities.duplicate()

func issue_order(instance_id: String, order: FacilityData.Order, option_id: String = "") -> bool:
	var f := get_facility(instance_id)
	if f == null:
		return false
	return f.issue_order(order, option_id)

# ============================================================
# API PÚBLICA — TURNO DE BASTIÓN
# ============================================================

## Llama esto al volver de cada misión.
## Avanza todas las facilidades y resuelve eventos de las que están en Mantener.
func resolve_bastion_turn() -> void:
	_missions_since_last_order += 1
	_check_neglect()

	for facility in _facilities:
		facility.advance_mission()
		if facility.has_result():
			var result := facility.claim_result()
			facility_order_completed.emit(facility, result)

	# Evento del Bastión para cada facilidad en Mantener
	for facility in _facilities:
		if facility.current_order == FacilityData.Order.MAINTAIN:
			_roll_event(facility)

func collect_all_results() -> Array[Dictionary]:
	var results: Array[Dictionary] = []
	for facility in _facilities:
		if facility.has_result():
			results.append({
				"facility": facility.instance_id,
				"result":   facility.claim_result(),
			})
	return results

# ============================================================
# API PÚBLICA — DEFENSORES
# ============================================================

func add_defenders(count: int) -> void:
	defenders += count
	defenders_changed.emit(defenders)

func lose_defenders(count: int) -> void:
	defenders = maxi(0, defenders - count)
	defenders_changed.emit(defenders)

# ============================================================
# API PÚBLICA — NIVEL DEL BASTIÓN
# ============================================================

func upgrade_bastion() -> void:
	if bastion_level >= 4:
		return
	bastion_level += 1
	bastion_level_changed.emit(bastion_level)

# ============================================================
# API PÚBLICA — NPCS RECRUTADOS
# ============================================================

## Recluta un NPC con nombre para el Bastión.
## El NPC debe haber sido encontrado en el mundo y cumplir su required_flag.
func recruit_npc(npc: BastionNPCData) -> bool:
	if is_npc_recruited(npc.npc_id):
		return false
	if not npc.required_flag.is_empty() and not WorldState.has_flag(npc.required_flag):
		return false
	_recruited_npcs.append(npc)
	npc_recruited.emit(npc)
	EventBus.narrator_bark.emit(
		"%s se ha mudado al Bastión." % npc.display_name, 4.0
	)
	return true

func is_npc_recruited(npc_id: String) -> bool:
	return _recruited_npcs.any(func(n: BastionNPCData) -> bool: return n.npc_id == npc_id)

func get_recruited_npcs() -> Array[BastionNPCData]:
	return _recruited_npcs.duplicate()

## Devuelve el NPC que mejora una facilidad concreta, si hay alguno.
func get_npc_for_facility(facility_id: String) -> BastionNPCData:
	for npc in _recruited_npcs:
		if npc.facility_affinity == facility_id:
			return npc
	return null

# ============================================================
# EVENTOS
# ============================================================

func _roll_event(facility: BastionFacilityInstance) -> void:
	var roll := RngManager.randi_range(1, 100)
	var event_id := "all_is_well"
	for entry in EVENTS:
		if roll >= entry["min"] and roll <= entry["max"]:
			event_id = entry["id"]
			break
	_resolve_event(event_id, facility)

func _resolve_event(event_id: String, facility: BastionFacilityInstance) -> void:
	var details: Dictionary = {"facility": facility.instance_id}

	match event_id:
		"attack":
			var dice := 6 if defenders == 0 else 6
			var lost := 0
			for i in dice:
				if RngManager.randi_range(1, 6) == 1:
					lost += 1
			if defenders > 0:
				lose_defenders(lost)
				details["defenders_lost"] = lost
			else:
				facility.damage()
				details["facility_damaged"] = true

		"lost_hirelings":
			facility.damage()
			details["auto_repair_next_turn"] = true

		"magical_discovery":
			details["reward"] = "potion_uncommon"

		"treasure":
			var t_roll := RngManager.randi_range(1, 100)
			details["treasure_table_roll"] = t_roll

		"friendly_visitors":
			details["gold_offer"] = RngManager.randi_range(1, 6) * 100

		"refugees":
			details["refugee_count"] = RngManager.randi_range(2, 8)
			details["gold_offer"]    = RngManager.randi_range(1, 6) * 100

		"request_for_aid":
			details["requires_defenders"] = true

		"guest":
			details["guest_type"] = RngManager.randi_range(1, 4)

	bastion_event_occurred.emit(event_id, details)

	# Reparación automática de facilidades dañadas por Lost Hirelings
	if event_id == "lost_hirelings":
		# Se repara en el siguiente turno
		pass

# ============================================================
# NEGLIGENCIA
# ============================================================

func _check_neglect() -> void:
	var max_neglect := LevelManager.get_level()
	if _missions_since_last_order >= max_neglect:
		EventBus.narrator_bark.emit(
			"El Bastión lleva demasiado tiempo sin atención. Los hirelings empiezan a marcharse.",
			5.0
		)

# ============================================================
# SERIALIZACIÓN
# ============================================================

func to_dict() -> Dictionary:
	return {
		"bastion_level": bastion_level,
		"defenders":     defenders,
		"missions_since_last_order": _missions_since_last_order,
		"facilities":    _facilities.map(func(f): return f.to_dict()),
		"recruited_npcs": _recruited_npcs.map(func(n: BastionNPCData) -> String: return n.npc_id),
	}

func from_dict(data: Dictionary, facility_catalog: Dictionary) -> void:
	bastion_level = data.get("bastion_level", 1)
	defenders     = data.get("defenders", 0)
	_missions_since_last_order = data.get("missions_since_last_order", 0)
	_facilities.clear()
	for f_data in data.get("facilities", []):
		var fdata: FacilityData = facility_catalog.get(f_data.get("facility_id"))
		if fdata == null:
			continue
		var instance := BastionFacilityInstance.new()
		instance.facility_data    = fdata
		instance.instance_id      = f_data.get("instance_id", "")
		instance.is_operational   = f_data.get("is_operational", true)
		instance.current_order    = f_data.get("current_order", FacilityData.Order.MAINTAIN)
		instance.current_option_id = f_data.get("current_option_id", "")
		instance.missions_remaining = f_data.get("missions_remaining", 0)
		instance.pending_result   = f_data.get("pending_result", {})
		_facilities.append(instance)

# ============================================================
# INTERNO
# ============================================================

func _count_of(facility_id: String) -> int:
	return _facilities.filter(func(f): return f.facility_data.facility_id == facility_id).size()
