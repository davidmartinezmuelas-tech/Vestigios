## spell_data.gd
## Extiende AbilityData para que CombatResolver funcione automáticamente.
## Añade las propiedades exclusivas de los conjuros D&D 2024:
## nivel, escuela, componentes, concentración, área de efecto, escalado.

class_name SpellData
extends AbilityData

enum School {
	ABJURACION, ADIVINACION, CONJURACION,
	ENCANTAMIENTO, EVOCACION, ILUSION,
	NECROMANCIA, TRANSMUTACION,
}

enum CastingTime {
	ACCION,           # acción normal
	ACCION_ADICIONAL, # acción de bonus
	REACCION,         # reacción (tiene trigger)
	MINUTO_1,
	MINUTO_10,
	HORA_1,
}

enum AreaShape { NONE, ESFERA, CONO, CUBO, CILINDRO, LINEA, EMANACION }

# ============================================================
# PROPIEDADES EXCLUSIVAS DE CONJUROS
# (Los campos de combate — daño, salvación, tirada — vienen de AbilityData)
# ============================================================

## 0 = truco (uso ilimitado), 1-9 = nivel
@export_range(0, 9) var spell_level: int = 1
@export var school: School = School.EVOCACION

## Componentes: "v" (verbal), "s" (somático), "m" (material)
@export var components: Array[String] = ["v", "s"]
@export var material_component: String = ""
@export var material_consumed: bool = false
@export var is_ritual: bool = false

@export var casting_time_type: CastingTime = CastingTime.ACCION
## Descripción del trigger si es Reacción (ej: "cuando eres atacado")
@export var reaction_trigger: String = ""

## Alcance en pies (alternativo a range_tiles de AbilityData)
@export var range_ft: int = 30

## Área de efecto
@export var area_shape: AreaShape = AreaShape.NONE
@export var area_size_ft: int = 0

@export var duration: String = "Instantáneo"
@export var requires_concentration: bool = false

## Dados extra de daño/curación por nivel de espacio por encima del base
@export var upcast_dice_per_slot: int = 0

## Escalado de trucos por nivel del personaje: {nivel: dados_extra}
## Ejemplo: {5: 1, 11: 2, 17: 3} significa +1d a nivel 5, +2d a nivel 11...
@export var damage_scale_at_levels: Dictionary = {}

# ============================================================
# HELPERS
# ============================================================

func is_cantrip() -> bool:
	return spell_level == 0

func is_bonus_action() -> bool:
	return casting_time_type == CastingTime.ACCION_ADICIONAL

func is_reaction() -> bool:
	return casting_time_type == CastingTime.REACCION

func has_area() -> bool:
	return area_shape != AreaShape.NONE and area_size_ft > 0

## Dados de daño reales según nivel del lanzador (para trucos).
## D&D 2024: escalan a nivel 5, 11 y 17 del personaje.
func effective_damage_dice(character_level: int) -> int:
	if not is_cantrip():
		return damage_dice_count
	# Leer escalado personalizado o usar la regla estándar 5/11/17
	var scale := damage_scale_at_levels if not damage_scale_at_levels.is_empty() else {5:1, 11:2, 17:3}
	var bonus := 0
	for threshold in scale:
		if character_level >= int(threshold):
			bonus = scale[threshold]
	return damage_dice_count + bonus

## Dados de daño reales al lanzar con un espacio de nivel superior.
func effective_upcast_dice(slot_level: int) -> int:
	if is_cantrip() or upcast_dice_per_slot == 0:
		return damage_dice_count
	return damage_dice_count + maxi(0, slot_level - spell_level) * upcast_dice_per_slot

func description_short() -> String:
	var parts: Array[String] = []
	var school_names := ["Abjuración","Adivinación","Conjuración","Encantamiento","Evocación","Ilusión","Nigromancia","Transmutación"]
	if is_cantrip():
		parts.append("Truco de %s" % school_names[school])
	else:
		parts.append("%s de nivel %d" % [school_names[school], spell_level])
	if requires_concentration:
		parts.append("C")
	return " · ".join(parts)
