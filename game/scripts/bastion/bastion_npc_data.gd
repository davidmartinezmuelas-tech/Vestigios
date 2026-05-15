## bastion_npc_data.gd
## Un NPC con nombre que puede mudarse al Bastión y mejorar una facilidad.
## Se crea un .tres por NPC recruitable en data/bastion/npcs/

class_name BastionNPCData
extends Resource

# ============================================================
# IDENTIDAD
# ============================================================
@export var npc_id: String = ""
@export var display_name: String = ""
@export_multiline var description: String = ""

# ============================================================
# FACILIDAD
## facility_id de la facilidad que mejora/gestiona (puede ser vacío si es solo ambiental)
# ============================================================
@export var facility_affinity: String = ""
@export_multiline var bonus_description: String = ""

## Si true, este NPC REEMPLAZA a los hirelings genéricos de la facilidad
## Si false, es un personaje extra que da un bonus adicional
@export var replaces_hirelings: bool = false

# ============================================================
# DIÁLOGO Y RETRATO
# ============================================================
## ID del DialogueData que se abre al hablar con él en el Bastión
@export var bastion_dialogue_id: String = ""
@export var portrait_neutral: Texture2D
@export var portrait_happy: Texture2D
@export var portrait_neutral_small: Texture2D  # para el sprite en la escena del bastión

# ============================================================
# CONDICIÓN DE RECLUTAMIENTO
## Flag de lore que debe estar activo para poder reclutar a este NPC
# ============================================================
@export var required_flag: String = ""

## Texto de la oferta de reclutamiento cuando el jugador interactúa con él en el mundo
@export_multiline var recruitment_pitch: String = ""
