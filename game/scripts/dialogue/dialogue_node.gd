## dialogue_node.gd
## Un paso en el árbol de diálogo: quién habla, qué dice y qué opciones hay.

class_name DialogueNode
extends Resource

## ID único de este nodo dentro del diálogo
@export var node_id: String = ""

## ID del personaje que habla. "npc" para el NPC principal, o character_id de un héroe.
@export var speaker_id: String = "npc"

## Emoción del hablante: "neutral", "happy", "angry", "scared", "focused"
@export var emotion: String = "neutral"

## Texto del diálogo
@export_multiline var text: String = ""

## Opciones que aparecen al terminar este texto.
## Si está vacío y auto_next tiene valor, avanza automáticamente.
@export var choices: Array[DialogueChoice] = []

## Si no hay choices, ir a este nodo automáticamente al pulsar continuar
@export var auto_next: String = ""

## Si true, este nodo cierra el diálogo al terminar
@export var ends_dialogue: bool = false

## Bark del narrador opcional que aparece en la exploración al terminar este nodo
@export var narrator_bark: String = ""
