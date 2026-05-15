## dialogue_choice.gd
## Una opción dentro de un nodo de diálogo.

class_name DialogueChoice
extends Resource

## Texto que ve el jugador en el botón
@export_multiline var text: String = ""

## Nodo de destino si no hay tirada de habilidad
@export var next_node_id: String = ""

## Si tiene valor, solo aparece si este personaje está en el partido
@export var required_character_id: String = ""

## Si tiene valor, la opción requiere que este flag de lore esté activo
@export var required_flag: String = ""

## Si tiene valor, se activa este flag al elegir esta opción
@export var sets_flag: String = ""

## Si tiene valor, esta opción requiere una tirada de habilidad
@export var skill_check: SkillCheckData = null

## Si true, la opción aparece pero está bloqueada (visible, no seleccionable)
## Se activa automáticamente si required_character_id o required_flag no se cumplen
@export var show_when_blocked: bool = true
