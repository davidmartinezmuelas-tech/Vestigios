## effect_data.gd
## Resource que define un efecto temporal (DOT, buff, debuff, stun...).
## Crear un .tres por efecto en data/effects/

class_name EffectData
extends Resource

enum EffectType {
	BLEED,        # Daño por turno
	POISON,       # Daño por turno (ignora resistencia)
	STUN,         # Pierde el turno
	BURN,         # Daño por turno + penalización accuracy
	MARKED,       # Los ataques contra el objetivo tienen +crit
	PROTECTED,    # Reducción de daño
	STRENGTHENED, # Bonus de daño
	WEAKENED,     # Penalización de daño
	BLIND,        # Penalización fuerte de accuracy
	ROOTED,       # No puede cambiar de posición
	STRESS_HEAL,  # Reduce estrés por turno
}

# ============================================================
# IDENTIDAD
# ============================================================
@export var effect_id: String = ""
@export var display_name: String = ""
@export var effect_type: EffectType = EffectType.BLEED

# ============================================================
# PARÁMETROS
# ============================================================
@export_group("Parámetros")
@export var duration_rounds: int = 3
## Probabilidad de que se aplique (0.0–1.0)
@export_range(0.0, 1.0) var application_chance: float = 1.0
## Valor del efecto (daño por turno, bonus de stat, etc.)
@export var value: int = 0
@export var value_float: float = 0.0

# ============================================================
# STAT MODIFICADO (para buffs/debuffs)
# ============================================================
@export_group("Modificador de stat")
## Nombre del stat a modificar: "accuracy", "dodge", "speed", etc.
@export var stat_to_modify: String = ""
@export var stat_modifier_value: Variant = 0

# ============================================================
# ARTE
# ============================================================
@export_group("Arte")
@export var icon: Texture2D
