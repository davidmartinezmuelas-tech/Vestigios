## custom_character_config.gd
## Almacena todas las elecciones del jugador durante la creación de personaje.
## El CharacterBuilder lo convierte en un CharacterData completo.

class_name CustomCharacterConfig
extends Resource

# ============================================================
# IDENTIDAD
# ============================================================
@export var character_name: String = ""

# ============================================================
# ELECCIONES DE CREACIÓN
# ============================================================
@export var race: RaceData = null
@export var chosen_class: ClassDefinition = null
@export var background: BackgroundData = null

## Habilidades elegidas de la lista de la clase (debe tener chosen_class.skill_choices entradas)
@export var chosen_skill_proficiencies: Array[String] = []

## Puntuaciones de característica asignadas (array estándar: 15,14,13,12,10,8 repartido)
## Orden: [str, dex, con, int, wis, cha]
@export var ability_scores: Array[int] = [10, 10, 10, 10, 10, 10]

# ============================================================
# PERSONALIZACIÓN VISUAL
# ============================================================
@export var portrait_set: PortraitSet = null
@export var sprite_customization: SpriteCustomization = SpriteCustomization.new()
