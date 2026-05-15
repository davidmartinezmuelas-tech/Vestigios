## weapon_data.gd
## Datos completos de un arma (D&D 2024).

class_name WeaponData
extends ItemData

enum WeaponCategory {
	SENCILLA_CUERPO,
	SENCILLA_DISTANCIA,
	MARCIAL_CUERPO,
	MARCIAL_DISTANCIA,
}

enum MasteryProperty {
	NONE,
	DEBILITAR,   # desventaja al siguiente ataque del objetivo
	DERRIBAR,    # salvación CON o derribado
	EMPUJAR,     # empuja 3m si Grande o menor
	HENDER,      # ataque gratis contra segunda criatura adyacente
	MELLAR,      # ataque extra como parte de la acción de atacar (arma ligera)
	MOLESTAR,    # ventaja en tu siguiente ataque contra ese objetivo
	RALENTIZAR,  # reduce velocidad 3m hasta inicio de tu siguiente turno
	ROZAR,       # si fallas, causa daño igual al mod de característica
}

# ============================================================
# CATEGORÍA Y DAÑO
# ============================================================
@export var category:     WeaponCategory = WeaponCategory.SENCILLA_CUERPO
@export var damage_dice_count: int  = 1
@export var damage_dice_sides: int  = 6
@export var damage_type:  String    = "contundente"  # contundente / perforante / cortante

# ============================================================
# PROPIEDADES (D&D 2024)
# ============================================================
@export_group("Propiedades")
@export var is_light:          bool  = false   # ligera: ataque extra con arma ligera AA
@export var is_finesse:        bool  = false   # sutil: usar FUE o DES a elección
@export var is_two_handed:     bool  = false   # a dos manos
@export var is_heavy:          bool  = false   # pesada: requiere FUE/DES 13 o desventaja
@export var is_reach:          bool  = false   # gran alcance: +1.5m de alcance
@export var is_versatile:      bool  = false   # versátil: 1 o 2 manos
@export var versatile_sides:   int   = 0       # dado si se usa a dos manos
@export var is_thrown:         bool  = false   # arrojadiza
@export var thrown_normal_ft:  int   = 0
@export var thrown_long_ft:    int   = 0
@export var is_ranged:         bool  = false   # arma a distancia
@export var range_normal_ft:   int   = 0
@export var range_long_ft:     int   = 0
@export var ammunition_type:   String = ""     # flecha / virote / proyectil / bala / dardo
@export var has_reload:        bool  = false   # recarga: 1 ataque por acción

# ============================================================
# MAESTRÍA (D&D 2024)
# ============================================================
@export_group("Maestría")
@export var mastery: MasteryProperty = MasteryProperty.NONE

# ============================================================
# HELPERS
# ============================================================

## Qué modificador de característica usa por defecto para atacar.
func default_attack_ability() -> String:
	if is_finesse:
		return "dex"  # el jugador elige, pero dex es el default
	if is_ranged or is_thrown:
		return "dex"
	return "str"

func damage_string() -> String:
	return "%dd%d %s" % [damage_dice_count, damage_dice_sides, damage_type]

func is_martial() -> bool:
	return category == WeaponCategory.MARCIAL_CUERPO or category == WeaponCategory.MARCIAL_DISTANCIA

func is_melee() -> bool:
	return category == WeaponCategory.SENCILLA_CUERPO or category == WeaponCategory.MARCIAL_CUERPO
