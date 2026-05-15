## sprite_customization.gd
## Personalización visual del sprite pixel art en el mapa.
## Los valores son índices a paletas de colores definidas en un shader.

class_name SpriteCustomization
extends Resource

## Tono de piel: 0-5 (muy claro → muy oscuro)
@export_range(0, 5) var skin_tone: int = 2

## Color de pelo: 0-7 (negro, marrón oscuro, marrón, rubio, pelirrojo, gris, blanco, inusual)
@export_range(0, 7) var hair_color: int = 0

## Estilo de pelo: 0-3 (corto, medio, largo, rapado)
@export_range(0, 3) var hair_style: int = 0

## Color de ojos: 0-5 (marrón, verde, azul, gris, ámbar, inusual)
@export_range(0, 5) var eye_color: int = 0
