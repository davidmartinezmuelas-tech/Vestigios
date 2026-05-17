## constants.gd
## Todas las constantes numéricas del juego. Nunca hardcodear valores fuera de aquí.

class_name Constants
extends Node

# ============================================================
# PARTIDO
# ============================================================
## Personajes que pueden ir en una misión (por defecto)
const MAX_PARTY_SIZE: int = 4
## Máximo para misiones especiales de 5
const MAX_PARTY_SIZE_LARGE: int = 5
const MIN_PARTY_SIZE: int = 1
## Todos los personajes del juego (5 fijos + 1 custom)
const MAX_ROSTER_SIZE: int = 6

# ============================================================
# COMBATE — DADOS Y TIRADAS
# ============================================================
## El crítico solo ocurre con 20 natural en el d20
const CRIT_ROLL: int = 20
## La pifia solo ocurre con 1 natural en el d20
const FUMBLE_ROLL: int = 1

# ============================================================
# COMBATE — ESTRÉS
# ============================================================
## Estrés generado por punto de daño recibido
const STRESS_PER_DAMAGE: float = 0.10
## Estrés al ver morir a un aliado
const STRESS_ON_ALLY_DEATH: int = 20
## Umbral de Aflicción
const AFFLICTION_THRESHOLD: int = 100
## Umbral de Virtud (llegada inesperada)
const VIRTUE_THRESHOLD: int = 100

# ============================================================
# PERSONAJES
# ============================================================
## Bonificador de competencia por rango de nivel (índice 0 = niveles 1-4, etc.)
const PROFICIENCY_BY_TIER: Array[int] = [2, 3, 4, 5, 6]

## Array estándar de puntuaciones para creación de personaje
const STANDARD_ARRAY: Array[int] = [15, 14, 13, 12, 10, 8]

# ============================================================
# HABILIDADES — Mapa habilidad → característica
# ============================================================
const SKILL_ABILITY_MAP: Dictionary = {
	"atletismo":      "str",
	"acrobacias":     "dex",
	"sigilo":         "dex",
	"juego_de_manos": "dex",
	"arcanos":        "int",
	"historia":       "int",
	"investigacion":  "int",
	"naturaleza":     "int",
	"religion":       "int",
	"medicina":       "wis",
	"perspicacia":    "wis",
	"percepcion":     "wis",
	"supervivencia":  "wis",
	"trato_animales": "wis",
	"engano":         "cha",
	"actuacion":      "cha",
	"intimidacion":   "cha",
	"persuasion":     "cha",
}

# ============================================================
# ECONOMÍA
# ============================================================
const STARTING_GOLD: int = 500
const MAX_INVENTORY_SLOTS: int = 12

# ============================================================
# EQUIPAMIENTO
# ============================================================
## Máximo de objetos sintonizados por personaje (D&D 2024)
const MAX_ATTUNED_ITEMS: int = 3
## Máximo de objetos en el inventario personal de un personaje
const MAX_PERSONAL_INVENTORY: int = 20
## Coste en Acciones de pasar un objeto a un compañero en combate
const ITEM_PASS_ACTION_COST: int = 1

# ============================================================
# GUARDADO
# ============================================================
const SAVE_SLOTS: int = 3
const SAVE_FILE_PATH: String = "user://save_slot_{slot}.json"

# ============================================================
# UI
# ============================================================
const DAMAGE_LABEL_DURATION: float = 1.5
const BARK_DURATION_DEFAULT: float = 3.0
