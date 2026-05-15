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
