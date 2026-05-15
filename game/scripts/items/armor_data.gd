## armor_data.gd
## Datos de una armadura o escudo (D&D 2024).

class_name ArmorData
extends ItemData

enum ArmorCategory { LIGERA, MEDIA, PESADA, ESCUDO }

@export var armor_category:    ArmorCategory = ArmorCategory.LIGERA
## CA base. Para ligera: 11+DES. Media: valor+DES(max2). Pesada: valor fijo.
@export var base_ac:           int   = 11
## Máximo bonificador de DES que se aplica. -1 = sin límite (ligera).
@export var max_dex_bonus:     int   = -1
## FUE mínima requerida. 0 = sin requisito.
@export var requires_strength: int   = 0
## Si true, impone desventaja en Sigilo.
@export var stealth_disadvantage: bool = false

func calculate_ac(dexterity_modifier: int) -> int:
	match armor_category:
		ArmorCategory.LIGERA:
			return base_ac + dexterity_modifier
		ArmorCategory.MEDIA:
			return base_ac + mini(dexterity_modifier, max_dex_bonus if max_dex_bonus >= 0 else dexterity_modifier)
		ArmorCategory.PESADA:
			return base_ac
		ArmorCategory.ESCUDO:
			return 2  # el escudo añade +2, se suma al calcular CA total
	return base_ac
