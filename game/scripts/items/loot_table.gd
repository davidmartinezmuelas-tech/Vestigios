## loot_table.gd
## Define el loot que suelta una criatura al morir.
##
## REGLA DE DISEÑO:
##   Enemigos básicos → solo oro. El combate destruye su equipo.
##   Bosses           → pueden soltar armas, armaduras u objetos mágicos.

class_name LootTable
extends Resource

## Oro mínimo garantizado
@export var gold_min: int = 0
## Oro máximo (el valor real será RngManager entre min y max)
@export var gold_max: int = 0

## Items que pueden caer (solo para bosses — enemigos básicos dejan el array vacío)
@export var entries: Array[LootEntry] = []

## Genera el loot y lo añade a WorldState.
## Devuelve una descripción de lo obtenido para el narrador.
func generate() -> String:
	var parts: Array[String] = []

	# Oro
	if gold_max > 0:
		var gold := RngManager.randi_range(gold_min, gold_max)
		if gold > 0:
			WorldState.add_gold(gold)
			parts.append("%d PO" % gold)

	# Items
	for entry in entries:
		if entry.guaranteed or RngManager.roll() < entry.drop_chance:
			var item := _resolve_item(entry.item_id)
			if item != null:
				WorldState.add_item({
					"id": entry.item_id,
					"name": item.display_name,
					"desc": item.description.substr(0, 80),
				})
				parts.append(item.display_name)

	return ", ".join(parts) if not parts.is_empty() else ""

func _resolve_item(item_id: String) -> ItemData:
	var from_items := ItemDatabase.get_item(item_id)
	if from_items:
		return from_items
	var from_magic := MagicItemDatabase.get(item_id)
	return from_magic
