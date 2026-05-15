## race_data.gd
## Define una raza jugable con sus rasgos y opciones de personalización.

class_name RaceData
extends Resource

@export var race_id: String = ""
@export var display_name: String = ""
@export_multiline var description: String = ""

## Tamaño: "small" o "medium"
@export var size: String = "medium"

## Velocidad base en pies
@export var base_speed: int = 30

## Rasgos raciales
@export var traits: Array[RacialTrait] = []

## Sets de retratos disponibles para esta raza
@export var portrait_sets: Array[PortraitSet] = []

## Resumen de los bonos de característica (para mostrar en la UI de selección)
func get_ability_bonus_summary() -> String:
	var bonuses: Dictionary = {}
	for trait in traits:
		for ability in trait.ability_bonuses:
			bonuses[ability] = bonuses.get(ability, 0) + trait.ability_bonuses[ability]
	var parts: Array[String] = []
	for ability in bonuses:
		var val: int = bonuses[ability]
		parts.append("%s%d %s" % ["+" if val >= 0 else "", val, ability.to_upper()])
	return ", ".join(parts)

## Aplica todos los rasgos raciales a un CharacterData existente
func apply_to(character_data: CharacterData) -> void:
	for trait in traits:
		for ability in trait.ability_bonuses:
			var current: int = character_data.get(ability, 10)
			character_data.set(ability, current + trait.ability_bonuses[ability])
		character_data.speed_ft += trait.speed_bonus
		for skill in trait.skill_proficiencies:
			if skill not in character_data.skill_proficiencies:
				character_data.skill_proficiencies.append(skill)
