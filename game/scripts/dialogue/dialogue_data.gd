## dialogue_data.gd
## Resource que contiene un diálogo completo: árbol de nodos.
## Crear un .tres por conversación en data/dialogues/

class_name DialogueData
extends Resource

@export var dialogue_id: String = ""
## character_id del NPC con quien se habla
@export var npc_character_id: String = ""
## ID del primer nodo
@export var start_node_id: String = "start"
## Todos los nodos del diálogo. Clave: node_id, Valor: DialogueNode
@export var nodes: Array[DialogueNode] = []

## Devuelve un nodo por su ID
func get_node(node_id: String) -> DialogueNode:
	for node in nodes:
		if node.node_id == node_id:
			return node
	return null
