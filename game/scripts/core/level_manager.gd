## level_manager.gd
## Gestiona la experiencia y subida de nivel del partido.
##
## FILOSOFÍA:
##   Las hazañas (logros narrativos) dan el grueso del XP necesario para subir.
##   El combate da XP pero está LIMITADO al 30% del XP que falta para el nivel
##   siguiente por encuentro — matar enemigos en bucle nunca puede subir de nivel solo.
##
## HAZAÑAS del tutorial:
##   "taberna_superada"   → 150 XP  (sobrevivir el combate de la taberna)
##   "bosque_explorado"   → 100 XP  (llegar al final del área del bosque)
##   "fuerte_conquistado" → 650 XP  (derrotar al General Vorn)
##
## Threshold nivel 1→2: 300 XP   (hazañas taberna+bosque = 250, combate cubre el resto)
## Threshold nivel 2→3: 900 XP   (hazaña fuerte = 650, combate cubre el resto)

extends Node

# ============================================================
# SEÑALES
# ============================================================
signal xp_gained(amount: int, total: int)
signal hazana_completed(hazana_id: String, xp_gained: int)
signal level_up(new_level: int)

# ============================================================
# TABLA DE XP (D&D 5e 2014)
# ============================================================
const XP_THRESHOLDS: Array[int] = [
	0,       # nivel 1
	300,     # nivel 2
	900,     # nivel 3
	2700,    # nivel 4
	6500,    # nivel 5
	14000,   # nivel 6
	23000,   # nivel 7
	34000,   # nivel 8
	48000,   # nivel 9
	64000,   # nivel 10
	85000,   # nivel 11
	100000,  # nivel 12
	120000,  # nivel 13
	140000,  # nivel 14
	165000,  # nivel 15
	195000,  # nivel 16
	225000,  # nivel 17
	265000,  # nivel 18
	305000,  # nivel 19
	355000,  # nivel 20
]

## XP que otorga cada hazaña (por ID)
const HAZANA_XP: Dictionary = {
	# Tutorial — Misión 1: El Fuerte de Piedra Gris
	"taberna_superada":    150,
	"bosque_explorado":    100,
	"ogro_derrotado":       50,   # opcional — no es necesario para subir
	"fuerte_conquistado":  650,
	# Más hazañas se añadirán por misión
}

## Máximo porcentaje del XP faltante que puede dar UN encuentro de combate
const COMBAT_XP_CAP_RATIO: float = 0.30

# ============================================================
# ESTADO
# ============================================================
var current_xp: int = 0
var party_level: int = 1
var completed_hazanas: Array[String] = []

# ============================================================
# API PÚBLICA — XP Y HAZAÑAS
# ============================================================

## Llama esto al terminar un encuentro de combate con la suma de XP de los enemigos muertos.
func award_combat_xp(raw_xp: int) -> void:
	var xp_to_next := _xp_to_next_level()
	if xp_to_next <= 0:
		return
	var capped := mini(raw_xp, int(xp_to_next * COMBAT_XP_CAP_RATIO))
	capped = maxi(capped, 1) if raw_xp > 0 else 0
	_add_xp(capped)

## Llama esto al completar una hazaña narrativa.
## Ignora si ya se completó antes (no se puede repetir).
func complete_hazana(hazana_id: String) -> void:
	if hazana_id in completed_hazanas:
		return
	completed_hazanas.append(hazana_id)
	var xp: int = (HAZANA_XP.get(hazana_id) if HAZANA_XP.get(hazana_id) != null else 0)
	if xp > 0:
		_add_xp(xp)
		hazana_completed.emit(hazana_id, xp)
		EventBus.narrator_bark.emit("Hazaña completada: " + hazana_id, 3.0)

func has_completed_hazana(hazana_id: String) -> bool:
	return hazana_id in completed_hazanas

# ============================================================
# CONSULTAS
# ============================================================

func get_level() -> int:
	return party_level

## Calcula el bonificador de competencia para un nivel dado (fórmula D&D 5e 2014).
static func proficiency_for_level(level: int) -> int:
	return int((level - 1) / 4) + 2

## Sincroniza un CharacterData al nivel actual del grupo.
## Úsalo al recuperar un personaje del banco o al añadir uno nuevo.
func sync_character_to_party_level(data: CharacterData) -> void:
	if data == null:
		return
	data.level             = party_level
	data.proficiency_bonus = proficiency_for_level(party_level)
	# El HP se recalcula automáticamente en calculate_max_hp() cada vez que se inicializa.

func get_xp() -> int:
	return current_xp

func get_xp_for_level(level: int) -> int:
	if level < 1 or level >= XP_THRESHOLDS.size():
		return 0
	return XP_THRESHOLDS[level - 1]

func get_xp_for_next_level() -> int:
	if party_level >= XP_THRESHOLDS.size():
		return 0
	return XP_THRESHOLDS[party_level]

func xp_percentage() -> float:
	var current_threshold := get_xp_for_level(party_level)
	var next_threshold := get_xp_for_next_level()
	if next_threshold <= current_threshold:
		return 1.0
	return float(current_xp - current_threshold) / float(next_threshold - current_threshold)

# ============================================================
# SERIALIZACIÓN
# ============================================================

func to_dict() -> Dictionary:
	return {
		"current_xp": current_xp,
		"party_level": party_level,
		"completed_hazanas": completed_hazanas,
	}

func from_dict(data: Dictionary) -> void:
	current_xp    = data.get("current_xp", 0)
	party_level   = data.get("party_level", 1)
	completed_hazanas = data.get("completed_hazanas", [])

# ============================================================
# INTERNO
# ============================================================

func _add_xp(amount: int) -> void:
	current_xp += amount
	xp_gained.emit(amount, current_xp)
	_check_level_up()

func _xp_to_next_level() -> int:
	return maxi(0, get_xp_for_next_level() - current_xp)

func _check_level_up() -> void:
	if party_level >= 20:
		return
	while party_level < 20 and current_xp >= get_xp_for_next_level():
		party_level += 1
		level_up.emit(party_level)
		EventBus.narrator_bark.emit("¡El partido sube al nivel %d!" % party_level, 4.0)
