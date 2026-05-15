## consumable_data.gd
## Objeto consumible: pociones, venenos, equipo de aventurero, munición.

class_name ConsumableData
extends ItemData

enum ConsumableType {
	POTION,       # poción (usar como acción adicional)
	POISON,       # veneno (aplicar a arma o ingerir)
	ADVENTURING,  # equipo de aventurero (antorcha, cuerda, raciones...)
	AMMUNITION,   # munición (flechas, virotes, proyectiles, balas)
	SCROLL,       # pergamino de conjuro
	TOOL_SUPPLY,  # suministros de artesano (consumibles al fabricar)
}

@export var consumable_type: ConsumableType = ConsumableType.ADVENTURING
## Cuántos usos tiene el objeto (raciones = 1 por unidad, antorcha = 1, etc.)
@export var uses:            int   = 1
## Si es poción: cuánto cura (dados)
@export var heal_dice_count: int   = 0
@export var heal_dice_sides: int   = 4
@export var heal_bonus:      int   = 0
## Si aplica una condición al usarlo
@export var applies_condition: String = ""
## Si es veneno: CD de la salvación
@export var poison_save_dc:  int   = 0
@export var poison_save_ability: String = "con"
## Si es pergamino: ID del conjuro que contiene
@export var scroll_spell_id: String = ""
@export var scroll_spell_level: int = 0
## Cantidad de unidades que se venden juntas (p.ej. flechas x20)
@export var bundle_size:     int   = 1

func use_description() -> String:
	match consumable_type:
		ConsumableType.POTION:
			if heal_dice_count > 0:
				return "Recuperas %dd%d+%d PG." % [heal_dice_count, heal_dice_sides, heal_bonus]
		ConsumableType.SCROLL:
			return "Lanzas %s (nivel %d)." % [scroll_spell_id, scroll_spell_level]
	return description
