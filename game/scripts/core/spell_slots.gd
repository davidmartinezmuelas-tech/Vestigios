## spell_slots.gd
## Tablas de espacios de conjuro D&D 2024 y gestión por personaje.
## Separa la TABLA (datos estáticos por clase/nivel) del ESTADO (slots gastados).

class_name SpellSlots
extends RefCounted

# ============================================================
# TIPOS DE LANZADOR
# ============================================================
enum CasterType {
	NONE,   # Sin conjuros (guerrero base, monje base)
	HALF,   # Medio lanzador: Paladín, Explorador (slots 1-5)
	FULL,   # Lanzador completo: Bardo, Hechicero, Mago, Clérigo, Druida (slots 1-9)
	PACT,   # Magia de Pacto: Brujo (slots propios, se recuperan en descanso corto)
}

# ============================================================
# TABLAS DE ESPACIOS POR NIVEL DE CLASE (D&D 2024)
## Índice 0 = nivel de clase 1, índice 1 = nivel de clase 2, etc.
## Valor: Array[int] de 9 posiciones = slots de nivel 1 al 9
# ============================================================

## Lanzador completo (Bardo, Hechicero, Mago, Clérigo, Druida)
static var FULL_CASTER: Array[Array] = [
	[2,0,0,0,0,0,0,0,0],  # nv 1
	[3,0,0,0,0,0,0,0,0],  # nv 2
	[4,2,0,0,0,0,0,0,0],  # nv 3
	[4,3,0,0,0,0,0,0,0],  # nv 4
	[4,3,2,0,0,0,0,0,0],  # nv 5
	[4,3,3,0,0,0,0,0,0],  # nv 6
	[4,3,3,1,0,0,0,0,0],  # nv 7
	[4,3,3,2,0,0,0,0,0],  # nv 8
	[4,3,3,3,1,0,0,0,0],  # nv 9
	[4,3,3,3,2,0,0,0,0],  # nv 10
	[4,3,3,3,2,1,0,0,0],  # nv 11
	[4,3,3,3,2,1,0,0,0],  # nv 12
	[4,3,3,3,2,1,1,0,0],  # nv 13
	[4,3,3,3,2,1,1,0,0],  # nv 14
	[4,3,3,3,2,1,1,1,0],  # nv 15
	[4,3,3,3,2,1,1,1,0],  # nv 16
	[4,3,3,3,2,1,1,1,1],  # nv 17
	[4,3,3,3,3,1,1,1,1],  # nv 18
	[4,3,3,3,3,2,1,1,1],  # nv 19
	[4,3,3,3,3,2,2,1,1],  # nv 20
]

## Medio lanzador (Paladín, Explorador) — empieza en nivel 1 en 2024
static var HALF_CASTER: Array[Array] = [
	[2,0,0,0,0],           # nv 1
	[2,0,0,0,0],           # nv 2
	[3,0,0,0,0],           # nv 3
	[3,0,0,0,0],           # nv 4
	[4,2,0,0,0],           # nv 5
	[4,2,0,0,0],           # nv 6
	[4,3,0,0,0],           # nv 7
	[4,3,0,0,0],           # nv 8
	[4,3,2,0,0],           # nv 9
	[4,3,2,0,0],           # nv 10
	[4,3,3,0,0],           # nv 11
	[4,3,3,0,0],           # nv 12
	[4,3,3,1,0],           # nv 13
	[4,3,3,1,0],           # nv 14
	[4,3,3,2,0],           # nv 15
	[4,3,3,2,0],           # nv 16
	[4,3,3,3,1],           # nv 17
	[4,3,3,3,1],           # nv 18
	[4,3,3,3,2],           # nv 19
	[4,3,3,3,2],           # nv 20
]

## Magia de pacto (Brujo) — slots propios, se recuperan en descanso corto
static var PACT_MAGIC: Array[Dictionary] = [
	{"slots": 1, "level": 1},  # nv 1
	{"slots": 2, "level": 1},  # nv 2
	{"slots": 2, "level": 2},  # nv 3
	{"slots": 2, "level": 2},  # nv 4
	{"slots": 2, "level": 3},  # nv 5
	{"slots": 2, "level": 3},  # nv 6
	{"slots": 2, "level": 4},  # nv 7
	{"slots": 2, "level": 4},  # nv 8
	{"slots": 2, "level": 5},  # nv 9
	{"slots": 2, "level": 5},  # nv 10
	{"slots": 3, "level": 5},  # nv 11
	{"slots": 3, "level": 5},  # nv 12
	{"slots": 3, "level": 5},  # nv 13
	{"slots": 3, "level": 5},  # nv 14
	{"slots": 3, "level": 5},  # nv 15
	{"slots": 3, "level": 5},  # nv 16
	{"slots": 4, "level": 5},  # nv 17
	{"slots": 4, "level": 5},  # nv 18
	{"slots": 4, "level": 5},  # nv 19
	{"slots": 4, "level": 5},  # nv 20
]

# ============================================================
# ESTADO DE INSTANCIA (slots actuales de un personaje)
# ============================================================
var _caster_type: CasterType = CasterType.NONE
var _class_level: int = 1
## Slots disponibles ahora mismo: índice 0 = nivel 1, ..., índice 8 = nivel 9
var _current: Array[int] = []
var _max: Array[int] = []

## Para Brujo: slots de Magia de Pacto
var _pact_slots_current: int = 0
var _pact_slots_max: int     = 0
var _pact_slot_level: int    = 0

# ============================================================
# INICIALIZACIÓN
# ============================================================

func setup(caster_type: CasterType, class_level: int) -> void:
	_caster_type = caster_type
	_class_level = clampi(class_level, 1, 20)
	_rebuild()

## Versión multiclase: combina los niveles de hechicero de AMBAS clases.
## D&D 2024: niveles de lanzador completo cuentan enteros, medios cuentan la mitad (ceil).
## Luego se usa la tabla de lanzador completo con el nivel combinado.
func setup_multiclass(class_id: String, class_lv: int, mc_class_id: String, mc_lv: int) -> void:
	var combined := _combined_caster_level(class_id, class_lv, mc_class_id, mc_lv)

	# Brujos mantienen su Magia de Pacto separada — aquí calculamos solo los slots normales
	if class_id == "brujo" or mc_class_id == "brujo":
		# Los slots de Pacto se gestionan por separado; aquí calculamos el resto
		var non_warlock_id    := mc_class_id if class_id == "brujo" else class_id
		var non_warlock_level := mc_lv       if class_id == "brujo" else class_lv
		if combined > 0:
			setup(CasterType.FULL, clampi(combined, 1, 20))
		else:
			setup(CasterType.NONE, 1)
		# Añadir slots de Pacto del Brujo separadamente
		var warlock_lv := class_lv if class_id == "brujo" else mc_lv
		if warlock_lv > 0:
			var entry := PACT_MAGIC[clampi(warlock_lv - 1, 0, 19)]
			_pact_slots_max     = entry["slots"]
			_pact_slot_level    = entry["level"]
			_pact_slots_current = _pact_slots_max
		return

	if combined == 0:
		setup(CasterType.NONE, 1)
	else:
		setup(CasterType.FULL, clampi(combined, 1, 20))

## Calcula el nivel combinado de lanzador para la tabla de multiclase D&D 2024.
static func _combined_caster_level(class_id: String, class_lv: int, mc_class_id: String, mc_lv: int) -> int:
	return _caster_contribution(class_id, class_lv) + _caster_contribution(mc_class_id, mc_lv)

static func _caster_contribution(class_id: String, class_lv: int) -> int:
	match class_id:
		"bardo", "clerigo", "druida", "hechicero", "mago":
			return class_lv           # lanzador completo: cuenta entero
		"paladin", "explorador":
			return ceili(class_lv / 2.0)  # medio lanzador: cuenta la mitad
		"brujo":
			return 0  # Magia de Pacto — no entra en la tabla combinada
		_:
			return 0  # no lanzador

func _rebuild() -> void:
	match _caster_type:
		CasterType.NONE:
			_max = [0,0,0,0,0,0,0,0,0]
		CasterType.FULL:
			var row: Array = FULL_CASTER[_class_level - 1]
			_max = []
			for v in row: _max.append(v)
		CasterType.HALF:
			var row: Array = HALF_CASTER[_class_level - 1]
			_max = [0,0,0,0,0,0,0,0,0]
			for i in row.size(): _max[i] = row[i]
		CasterType.PACT:
			_max = [0,0,0,0,0,0,0,0,0]
			var entry: Dictionary = PACT_MAGIC[_class_level - 1]
			_pact_slots_max     = entry["slots"]
			_pact_slot_level    = entry["level"]
			_pact_slots_current = _pact_slots_max
	_current = _max.duplicate()

# ============================================================
# API PÚBLICA — SLOTS ESTÁNDAR
# ============================================================

## Devuelve cuántos slots del nivel indicado (1-9) quedan disponibles.
func available(slot_level: int) -> int:
	if slot_level < 1 or slot_level > 9:
		return 0
	return _current[slot_level - 1]

func max_slots(slot_level: int) -> int:
	if slot_level < 1 or slot_level > 9:
		return 0
	return _max[slot_level - 1]

## Intenta gastar un slot del nivel indicado (o superior si no hay).
## Devuelve el nivel del slot gastado, o 0 si no hay disponible.
func spend(spell_level: int) -> int:
	for lvl in range(spell_level, 10):
		if _current[lvl - 1] > 0:
			_current[lvl - 1] -= 1
			return lvl
	return 0

## Comprueba si hay algún slot disponible para lanzar un conjuro de ese nivel.
func can_cast(spell_level: int) -> bool:
	if spell_level == 0:
		return true  # trucos no gastan slots
	for lvl in range(spell_level, 10):
		if _current[lvl - 1] > 0:
			return true
	return false

## Restaura todos los slots (descanso largo).
func restore_all() -> void:
	_current = _max.duplicate()
	_pact_slots_current = _pact_slots_max

## Restaura slots de Magia de Pacto (descanso corto para Brujo).
func restore_pact_slots() -> void:
	_pact_slots_current = _pact_slots_max

# ============================================================
# CONSULTAS DE RESUMEN
# ============================================================

func get_slot_summary() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for i in 9:
		if _max[i] > 0:
			result.append({"level": i + 1, "current": _current[i], "max": _max[i]})
	return result

func has_any_slots() -> bool:
	for v in _current:
		if v > 0: return true
	return false

func get_caster_type() -> CasterType:
	return _caster_type

# ============================================================
# HELPERS ESTÁTICOS
# ============================================================

## Devuelve el tipo de lanzador para un ID de clase dado.
static func caster_type_for_class(class_id: String) -> CasterType:
	match class_id.to_lower():
		"bardo", "hechicero", "mago", "clerigo", "druida":
			return CasterType.FULL
		"paladin", "explorador":
			return CasterType.HALF
		"brujo":
			return CasterType.PACT
		_:
			return CasterType.NONE
