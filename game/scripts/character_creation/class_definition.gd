## class_definition.gd
## Define una clase jugable: dado de golpe, competencias y habilidades iniciales.
## Distinto de CharacterData — este es el "molde" de la clase, no el personaje.

class_name ClassDefinition
extends Resource

@export var class_id: String = ""
@export var display_name: String = ""
@export_multiline var description: String = ""

## Dado de golpe (6, 8, 10 o 12)
@export var hit_dice_sides: int = 8

## Tiradas de salvación con competencia
@export var saving_throw_proficiencies: Array[String] = []

## Habilidades disponibles para elegir al crear el personaje
@export var available_skill_proficiencies: Array[String] = []
## Cuántas habilidades puede elegir el jugador
@export var skill_choices: int = 2

## Armaduras y armas con competencia (descripción)
@export var armor_proficiencies: Array[String] = []
@export var weapon_proficiencies: Array[String] = []

## CA inicial sin armadura (solo para clases sin armadura como Monje)
## 0 = usa la armadura equipada normalmente
@export var unarmored_ac_formula: String = ""

## Características principales (para sugerir prioridad al asignar puntuaciones)
@export var primary_abilities: Array[String] = []

## Oro de inicio (dado × 10 en D&D; guardamos el dado aquí)
@export var starting_gold_dice: String = "5d4"

## Requisitos mínimos de característica para hacer MULTICLASE en esta clase.
## Clave: "str"/"dex"/"int"/"wis"/"cha"  |  Valor: puntuación mínima requerida
## El personaje debe cumplir los requisitos de AMBAS clases para poder multiclasear.
@export var multiclass_min_requirements: Dictionary = {}

## Devuelve si un CharacterData cumple los requisitos de multiclase en esta clase.
func can_multiclass_into(data: CharacterData) -> bool:
	for ability in multiclass_min_requirements:
		var required: int = multiclass_min_requirements[ability]
		var score: int = (data.get(ability) if data.get(ability) != null else 10)
		if score < required:
			return false
	return true

## Texto legible de los requisitos de multiclase.
func multiclass_requirements_text() -> String:
	if multiclass_min_requirements.is_empty():
		return "Sin requisitos"
	var parts: Array[String] = []
	for ability in multiclass_min_requirements:
		parts.append("%s %d" % [ability.to_upper(), multiclass_min_requirements[ability]])
	return " y ".join(parts)

## Tabla de requisitos mínimos D&D 2024 por class_id.
static func get_multiclass_requirements(class_id: String) -> Dictionary:
	match class_id:
		"barbaro":    return {"str": 13}
		"bardo":      return {"cha": 13}
		"brujo":      return {"cha": 13}
		"clerigo":    return {"wis": 13}
		"druida":     return {"wis": 13}
		"explorador": return {"dex": 13}
		"guerrero":   return {"str": 13}  # STR o DES ≥13, simplificamos a STR
		"hechicero":  return {"cha": 13}
		"mago":       return {"int": 13}
		"monje":      return {"dex": 13, "wis": 13}
		"paladin":    return {"str": 13, "cha": 13}
		"picaro":     return {"dex": 13}
	return {}
