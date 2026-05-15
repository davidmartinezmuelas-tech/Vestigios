## portrait_set.gd
## Un set de retratos pre-dibujados para el personaje personalizado.
## El jugador elige uno durante la creación. Tiene las 5 emociones.

class_name PortraitSet
extends Resource

@export var set_id: String = ""
## Nombre que ve el jugador en la galería de selección
@export var display_name: String = ""
## Raza a la que pertenece este set (para filtrar en la UI)
@export var race_id: String = ""

@export_group("Retratos")
@export var portrait_neutral: Texture2D
@export var portrait_happy: Texture2D
@export var portrait_angry: Texture2D
@export var portrait_scared: Texture2D
@export var portrait_focused: Texture2D

func get_portrait(emotion: String) -> Texture2D:
	match emotion:
		"happy":   return portrait_happy   if portrait_happy   else portrait_neutral
		"angry":   return portrait_angry   if portrait_angry   else portrait_neutral
		"scared":  return portrait_scared  if portrait_scared  else portrait_neutral
		"focused": return portrait_focused if portrait_focused else portrait_neutral
		_:         return portrait_neutral
