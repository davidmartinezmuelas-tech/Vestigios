## loot_entry.gd
## Una entrada en una tabla de loot: un objeto con su probabilidad de caída.

class_name LootEntry
extends Resource

## ID del objeto — se busca primero en ItemDatabase, luego en MagicItemDatabase
@export var item_id: String = ""
## Probabilidad de caída (0.0 = nunca, 1.0 = siempre)
@export_range(0.0, 1.0) var drop_chance: float = 1.0
## Si true: cae siempre independientemente de drop_chance
@export var guaranteed: bool = false
