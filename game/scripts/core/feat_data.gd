## feat_data.gd
## Define una dote (D&D 2024). Las dotes son rasgos que se obtienen
## en ciertos niveles, al subir de nivel como mejora de característica,
## o como parte del trasfondo de origen.

class_name FeatData
extends Resource

enum FeatCategory {
	ORIGEN,        # se obtiene con el trasfondo (nivel 1)
	GENERAL,       # disponible al subir de nivel (requiere nivel 4+)
	ESTILO_COMBATE,# requiere el rasgo Estilo de Combate de clase
	DON_EPICO,     # nivel 19+
}

@export var feat_id: String = ""
@export var display_name: String = ""
@export_multiline var description: String = ""
@export var category: FeatCategory = FeatCategory.GENERAL

## Requisitos
@export var min_level: int = 0
@export var prerequisite_ability: String = ""   # "str", "dex"...
@export var prerequisite_value: int = 0
@export var prerequisite_note: String = ""       # descripción libre

## Bonos de característica que otorga (+1 a una de las listadas, o +2 a una)
@export var ability_score_bonuses: Dictionary = {}  # ability → amount

## Competencias otorgadas
@export var skill_proficiencies: Array[String] = []
@export var tool_proficiencies: Array[String] = []

## Efectos mecánicos (simplificados para implementación)
@export var grants_spell_id: String = ""  # conjuro gratuito
@export var bonus_ac: int = 0
@export var bonus_initiative: int = 0
@export var hp_per_level: int = 0
