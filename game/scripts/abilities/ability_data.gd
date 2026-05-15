## ability_data.gd
## Resource que define una habilidad. Crear un .tres por habilidad en data/abilities/

class_name AbilityData
extends Resource

## Propiedad de maestría del arma que usa esta habilidad (D&D 2024).
## Solo se aplica si el atacante tiene has_weapon_mastery = true.
## Referenciar WeaponData.MasteryProperty directamente evita dependencia circular.
enum MasteryProperty {
	NONE,
	DEBILITAR,   ## objetivo: desventaja en su próxima tirada de ataque
	DERRIBAR,    ## objetivo: salvación CON o derribado
	EMPUJAR,     ## objetivo: empujado 3m en línea recta
	HENDER,      ## ataque gratis contra segunda criatura adyacente
	MELLAR,      ## ataque ligera como parte de la Acción (no Acción Adicional)
	MOLESTAR,    ## atacante: ventaja en próximo ataque contra el mismo objetivo
	RALENTIZAR,  ## objetivo: velocidad -3m (no acumula)
	ROZAR,       ## fallo: daño = mod característica del atacante
}

enum TargetType {
	SINGLE_ENEMY,
	ALL_ENEMIES,
	SINGLE_ALLY,
	ALL_ALLIES,
	SELF,
}

enum AbilityType {
	ATTACK,       # Requiere tirada de ataque vs AC
	SPELL_ATTACK, # Tirada de ataque de conjuro vs AC
	SAVING_THROW, # El objetivo hace tirada de salvación
	HEAL,         # Curación directa, sin tirada de ataque
	BUFF,         # Buff a aliado, sin tirada de ataque
	DEBUFF,       # Debuff a enemigo (puede requerir tirada de salvación)
}

# ============================================================
# IDENTIDAD
# ============================================================
@export var ability_id: String = ""
@export var display_name: String = ""
@export_multiline var description: String = ""

# ============================================================
# TIPO Y OBJETIVO
# ============================================================
@export_group("Tipo")
@export var ability_type: AbilityType = AbilityType.ATTACK
@export var target_type: TargetType = TargetType.SINGLE_ENEMY

# ============================================================
# RANGO
# ============================================================
@export_group("Rango")
## Rango en casillas (1 = cuerpo a cuerpo ~5ft, 4 = rango corto ~20ft, 8 = largo ~40ft)
@export var range_tiles: int = 1

## Propiedad de maestría que aplica esta habilidad al usarla con un arma.
@export var mastery_property: MasteryProperty = MasteryProperty.NONE

# ============================================================
# TIRADA DE ATAQUE
## Qué característica usa el atacante: "str", "dex", "int", "wis", "cha"
## Solo relevante para ATTACK y SPELL_ATTACK
# ============================================================
@export_group("Ataque")
@export var attack_ability: String = "str"
## Si es true, se añade el bonificador de competencia a la tirada de ataque
@export var uses_proficiency: bool = true

# ============================================================
# DAÑO
# ============================================================
@export_group("Daño")
@export var damage_dice_count: int = 1
@export var damage_dice_sides: int = 6
## Qué característica se añade al daño: "str", "dex", "int", "wis", "cha", "" (ninguna)
@export var damage_ability: String = "str"

# ============================================================
# TIRADA DE SALVACIÓN (para SAVING_THROW)
# ============================================================
@export_group("Tirada de Salvación")
## Característica que usan los objetivos para resistir: "str", "dex", etc.
@export var save_ability: String = "dex"
## CD de la tirada de salvación. Si es 0 se calcula: 8 + prof + mod_lanzador
@export var save_dc: int = 0
## Daño al pasar la tirada (porcentaje del daño total, 0.5 = la mitad)
@export var save_success_damage_multiplier: float = 0.5

# ============================================================
# EFECTOS
# ============================================================
@export_group("Efectos")
@export var effects: Array[EffectData] = []

# ============================================================
# ARTE
# ============================================================
@export_group("Arte")
@export var icon: Texture2D
