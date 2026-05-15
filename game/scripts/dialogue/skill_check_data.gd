## skill_check_data.gd
## Define una tirada de habilidad dentro de un diálogo.

class_name SkillCheckData
extends Resource

## Nombre visible de la habilidad ("Perspicacia", "Engaño", "Intimidación"...)
@export var skill_name: String = ""
## Característica asociada: "str", "dex", "con", "int", "wis", "cha"
@export var ability: String = "wis"
## Clase de dificultad
@export var difficulty_class: int = 12
## Nodo al que ir si tiene éxito
@export var success_node_id: String = ""
## Nodo al que ir si falla
@export var failure_node_id: String = ""

## Si true: tirar 2d20, quedarse con el mayor
@export var has_advantage: bool = false
## Si true: tirar 2d20, quedarse con el menor
## (las condiciones del mundo pueden forzarlo aunque aquí sea false)
@export var has_disadvantage: bool = false
