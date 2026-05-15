## bastion_player.gd
## El personaje del jugador en el Bastión. Click en el suelo → se mueve hasta ahí.
## No usa el CombatGrid — movimiento libre con Tween.

class_name BastionPlayer
extends CharacterBody2D

# ============================================================
# SEÑALES
# ============================================================
signal arrived_at_destination

# ============================================================
# CONSTANTES
# ============================================================
const MOVE_SPEED: float = 180.0

# ============================================================
# NODOS
# ============================================================
@onready var sprite: Sprite2D       = $Sprite2D
@onready var anim: AnimationPlayer  = $AnimationPlayer

# ============================================================
# ESTADO
# ============================================================
var _target: Vector2 = Vector2.ZERO
var _moving: bool    = false
var _tween: Tween    = null

# ============================================================
# LIFECYCLE
# ============================================================

func _ready() -> void:
	add_to_group("player")
	_target = global_position

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if _is_floor_click(event.global_position):
			move_to(get_global_mouse_position())

# ============================================================
# MOVIMIENTO
# ============================================================

func move_to(world_pos: Vector2) -> void:
	_target = world_pos
	_moving = true

	if _tween:
		_tween.kill()

	var distance := global_position.distance_to(world_pos)
	var duration := distance / MOVE_SPEED

	_update_facing(world_pos)

	_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	_tween.tween_property(self, "global_position", world_pos, duration)
	_tween.tween_callback(_on_arrived)

func stop() -> void:
	if _tween:
		_tween.kill()
	_moving = false

func is_moving() -> bool:
	return _moving

# ============================================================
# INTERNO
# ============================================================

func _update_facing(target_pos: Vector2) -> void:
	if sprite == null:
		return
	sprite.flip_h = target_pos.x < global_position.x

func _is_floor_click(screen_pos: Vector2) -> bool:
	# En el Bastión cualquier click en el viewport que no sea en un objeto
	# de la UI se considera un click al suelo. Las InteractableObjects
	# consumen el input antes de que llegue aquí si están en rango.
	return true

func _on_arrived() -> void:
	_moving = false
	arrived_at_destination.emit()
