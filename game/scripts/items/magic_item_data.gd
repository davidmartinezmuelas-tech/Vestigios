## magic_item_data.gd
## Objeto mágico con sus propiedades y requisitos de sintonía.

class_name MagicItemData
extends ItemData

enum Attunement {
	NONE,        # no requiere sintonía
	ANY,         # cualquier personaje
	SPELLCASTER, # lanzador de conjuros
	SPECIFIC,    # clase/raza específica (ver attunement_note)
}

@export var rarity: ItemData.Rarity = ItemData.Rarity.COMUN
@export var attunement: Attunement = Attunement.NONE
@export var attunement_note: String = ""  # ej: "paladín", "druida o clérigo"

## Efecto mecánico resumido (para mostrar en tooltips)
@export_multiline var effect: String = ""

## Si da bonus a ataque/CA: +1, +2, +3
@export_range(-1, 4) var enhancement_bonus: int = 0

## Si concede conjuros, sus IDs
@export var granted_spell_ids: Array[String] = []
## Cargas máximas (0 = no tiene)
@export var max_charges: int = 0
## Cargas recuperadas al amanecer
@export var charges_per_dawn: String = ""  # "1d6+1", "all", etc.

## Si requiere que se porte/lleve para funcionar
@export var requires_wearing: bool = true
