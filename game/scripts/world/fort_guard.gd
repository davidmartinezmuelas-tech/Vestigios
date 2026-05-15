## fort_guard.gd
## Un guardia del fuerte. Patrulla una ruta simple y detecta al jugador.
## En estado de alarma: radio de detección mayor, siempre activos.

class_name FortGuard
extends CharacterBody2D

# ============================================================
# SEÑALES
# ============================================================
signal player_detected(guard: FortGuard)

# ============================================================
# EXPORTS
# ============================================================
@export var patrol_points: Array[Vector2] = []   # ruta de patrulla en world coords
@export var detection_radius_normal: float = 80.0
@export var detection_radius_alert: float  = 150.0
@export var patrol_speed: float = 60.0
@export var character_data: CharacterData

# ============================================================
# NODOS
# ============================================================
@onready var detection_area: Area2D      = $DetectionArea
@onready var detection_shape: CollisionShape2D = $DetectionArea/Shape
@onready var sprite: ColorRect           = $Sprite

# ============================================================
# ESTADO
# ============================================================
var _patrol_index: int = 0
var _is_alert: bool    = false
var _detected: bool    = false

# ============================================================
# LIFECYCLE
# ============================================================

func _ready() -> void:
	add_to_group("guards")
	detection_area.body_entered.connect(_on_body_entered)
	_update_detection_radius()

func _physics_process(delta: float) -> void:
	if _detected or patrol_points.is_empty():
		return
	_patrol(delta)

# ============================================================
# API PÚBLICA
# ============================================================

func set_alert(alert: bool) -> void:
	_is_alert = alert
	_update_detection_radius()
	if alert:
		sprite.color = Color(0.9, 0.3, 0.2)   # rojo en alerta
	else:
		sprite.color = Color(0.7, 0.2, 0.2)   # rojo normal

func mark_detected() -> void:
	_detected = true

# ============================================================
# PATRULLA
# ============================================================

func _patrol(delta: float) -> void:
	if patrol_points.is_empty():
		return
	var target := patrol_points[_patrol_index]
	var direction := (target - global_position).normalized()
	var distance := global_position.distance_to(target)

	if distance < 4.0:
		_patrol_index = (_patrol_index + 1) % patrol_points.size()
		return

	velocity = direction * patrol_speed
	move_and_slide()

	# Flip sprite según dirección
	if sprite and direction.x != 0:
		sprite.position.x = -14 if direction.x > 0 else 14

# ============================================================
# DETECCIÓN
# ============================================================

func _on_body_entered(body: Node2D) -> void:
	if _detected:
		return
	if body.is_in_group("player"):
		_detected = true
		player_detected.emit(self)

func _update_detection_radius() -> void:
	if detection_shape == null:
		return
	var shape := detection_shape.shape as CircleShape2D
	if shape:
		shape.radius = detection_radius_alert if _is_alert else detection_radius_normal
