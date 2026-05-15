## racial_trait.gd
## Un rasgo racial concreto (Visión en la oscuridad, Resistencia enana, etc.)

class_name RacialTrait
extends Resource

@export var trait_id: String = ""
@export var display_name: String = ""
@export_multiline var description: String = ""

## Modificadores de característica que aplica este rasgo
## Clave: "str"/"dex"/"con"/"int"/"wis"/"cha"  |  Valor: int
@export var ability_bonuses: Dictionary = {}

## Competencias en habilidades que otorga (nombres en snake_case: "percepcion", "intimidacion")
@export var skill_proficiencies: Array[String] = []

## Resistencias a tipos de daño ("fire", "poison", etc.)
@export var damage_resistances: Array[String] = []

## Bonus a velocidad en pies (puede ser negativo, ej: enano -5)
@export var speed_bonus: int = 0

## Si true, este personaje tiene visión en la oscuridad
@export var has_darkvision: bool = false
@export var darkvision_range_ft: int = 60
