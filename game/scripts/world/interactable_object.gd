## interactable_object.gd
## Base para cualquier objeto interactuable en el mundo (Bastión, exploración).
## Muestra un indicador (!) cuando el jugador está cerca y emite interacted al clickar.

class_name InteractableObject
extends Node2D

# ============================================================
# SEÑALES
# ============================================================
signal interacted(object: InteractableObject)

# ============================================================
# EXPORTS
# ============================================================
@export var display_name: String = "Objeto"
@export var interaction_radius: float = 80.0
## Si true, el jugador debe estar en rango para interactuar
@export var requires_proximity: bool = true

# ============================================================
# NODOS
# ============================================================
@onready var indicator: Label    = $Indicator
@onready var detection: Area2D   = $DetectionArea
@onready var sprite: Node2D      = $Sprite

# ============================================================
# ESTADO
# ============================================================
var _player_in_range: bool = false
var is_active: bool = true

# ============================================================
# LIFECYCLE
# ============================================================

func _ready() -> void:
	indicator.text = "!"
	indicator.visible = false

	if detection:
		detection.body_entered.connect(_on_body_entered)
		detection.body_exited.connect(_on_body_exited)

func _unhandled_input(event: InputEvent) -> void:
	if not is_active:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if _is_clicked(event.position):
			if not requires_proximity or _player_in_range:
				interacted.emit(self)
				get_viewport().set_input_as_handled()

# ============================================================
# API PÚBLICA
# ============================================================

func set_active(active: bool) -> void:
	is_active = active
	modulate = Color(1, 1, 1, 1) if active else Color(0.4, 0.4, 0.4, 1)

# ============================================================
# INTERNO
# ============================================================

func _is_clicked(screen_pos: Vector2) -> bool:
	var local_pos := to_local(get_canvas_transform().affine_inverse() * screen_pos)
	return sprite.get_rect().has_point(local_pos) if sprite.has_method("get_rect") else \
		   local_pos.length() < interaction_radius

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_in_range = true
		indicator.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_in_range = false
		indicator.visible = false
