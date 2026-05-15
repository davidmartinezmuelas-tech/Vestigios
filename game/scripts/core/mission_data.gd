## mission_data.gd
## Define los parámetros de una misión: tamaño de party, recomendaciones, etc.

class_name MissionData
extends Resource

@export var mission_id: String = ""
@export var display_name: String = ""
@export_multiline var briefing: String = ""

## Cuántos personajes puede llevar el jugador (4 o 5)
@export_range(1, 5) var party_slots: int = 4

## Nivel recomendado para afrontar la misión
@export var recommended_level: int = 1

## Si true, ciertos personajes son obligatorios (ej: el tutorial obliga a Johannes)
@export var required_character_ids: Array[String] = []

## Escena del mapa de exploración para esta misión
@export var exploration_scene: String = ""

## Hazañas que se pueden completar en esta misión (para el LevelManager)
@export var available_hazanas: Array[String] = []
