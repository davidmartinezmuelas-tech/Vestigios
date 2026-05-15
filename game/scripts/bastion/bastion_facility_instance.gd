## bastion_facility_instance.gd
## Una facilidad activa en el Bastión del jugador.
## Guarda el estado (orden pendiente, progreso, resultado) de una facilidad concreta.

class_name BastionFacilityInstance
extends RefCounted

# ============================================================
# DATOS
# ============================================================
var facility_data: FacilityData
var instance_id: String = ""         # unique id (facility_id + "_0", "_1", etc.)

# ============================================================
# ESTADO
# ============================================================
var is_operational: bool = true      # false si fue dañada por un evento
var current_order: int = FacilityData.Order.MAINTAIN
var current_option_id: String = ""   # qué opción específica de la orden
var missions_remaining: int = 0      # misiones que quedan para completar la orden
var pending_result: Dictionary = {}  # resultado listo para recoger

# ============================================================
# API PÚBLICA
# ============================================================

func issue_order(order: FacilityData.Order, option_id: String = "") -> bool:
	if not is_operational:
		return false
	if order not in facility_data.available_orders:
		return false
	current_order   = order
	current_option_id = option_id
	missions_remaining = 1  # la mayoría de órdenes duran 1 misión
	pending_result  = {}
	return true

func advance_mission() -> void:
	if missions_remaining > 0:
		missions_remaining -= 1
	if missions_remaining == 0 and current_order != FacilityData.Order.MAINTAIN:
		_complete_order()

func has_result() -> bool:
	return not pending_result.is_empty()

func claim_result() -> Dictionary:
	var result := pending_result.duplicate()
	pending_result = {}
	return result

func damage() -> void:
	is_operational = false
	pending_result = {}

func repair() -> void:
	is_operational = true

# ============================================================
# SERIALIZACIÓN
# ============================================================

func to_dict() -> Dictionary:
	return {
		"facility_id":       facility_data.facility_id,
		"instance_id":       instance_id,
		"is_operational":    is_operational,
		"current_order":     current_order,
		"current_option_id": current_option_id,
		"missions_remaining": missions_remaining,
		"pending_result":    pending_result,
	}

# ============================================================
# INTERNO
# ============================================================

func _complete_order() -> void:
	match current_order:
		FacilityData.Order.RESEARCH:
			pending_result = {"type": "research", "option": current_option_id}
		FacilityData.Order.HARVEST:
			pending_result = {"type": "harvest", "option": current_option_id}
		FacilityData.Order.CRAFT:
			pending_result = {"type": "craft", "option": current_option_id}
		FacilityData.Order.EMPOWER:
			pending_result = {"type": "empower", "option": current_option_id}
		FacilityData.Order.RECRUIT:
			pending_result = {"type": "recruit", "option": current_option_id}
		FacilityData.Order.TRADE:
			pending_result = {"type": "trade", "option": current_option_id}
