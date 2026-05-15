## item_data.gd
## Clase base para todos los objetos del juego.

class_name ItemData
extends Resource

enum ItemType { WEAPON, ARMOR, SHIELD, CONSUMABLE, TOOL, AMMUNITION, MISC, MAGIC }
enum Rarity   { MUNDANO, COMUN, INFRECUENTE, RARO, MUY_RARO, LEGENDARIO }

@export var item_id:      String   = ""
@export var display_name: String   = ""
@export_multiline var description: String = ""
@export var item_type:    ItemType = ItemType.MISC
@export var rarity:       Rarity   = Rarity.MUNDANO
@export var weight_kg:    float    = 0.0
@export var price_gp:     float    = 0.0
@export var is_magical:   bool     = false
@export var icon:         Texture2D

func get_price_string() -> String:
	if price_gp >= 1.0:
		return "%.0f po" % price_gp
	var pp := price_gp * 10.0
	if pp >= 1.0:
		return "%.0f pp" % pp
	return "%.0f pc" % (price_gp * 100.0)
