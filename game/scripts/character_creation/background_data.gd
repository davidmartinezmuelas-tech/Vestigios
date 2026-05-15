## background_data.gd
## Define un trasfondo de personaje con competencias y rasgo.

class_name BackgroundData
extends Resource

@export var background_id: String = ""
@export var display_name: String = ""
@export_multiline var description: String = ""

## Las dos competencias de habilidad que otorga
@export var skill_proficiencies: Array[String] = []

## Competencias de herramientas o idiomas (descripción libre por ahora)
@export var tool_proficiencies: Array[String] = []
@export var languages: Array[String] = []

## Oro de inicio
@export var starting_gold: int = 10

## Rasgo del trasfondo (descripción narrativa)
@export var feature_name: String = ""
@export_multiline var feature_description: String = ""

## D&D 2024: bonos de característica del origen (+2 a una O +1 a dos de las listadas)
## Clave: "str"/"dex"/"con"/"int"/"wis"/"cha" | Valor: máximo bono disponible
@export var ability_score_options: Dictionary = {}  # ej: {"str":2, "dex":1, "con":1}

## D&D 2024: dote de origen que otorga este trasfondo
@export var origin_feat_id: String = ""
