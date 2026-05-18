## protagonista_movement.gd
## Mueve el protagonista placeholder de la taberna con click-to-move.
## Adjuntar al nodo "Protagonista" en taberna_karreth.tscn

extends Node2D

const MOVE_SPEED := 300.0

var _agent: NavigationAgent2D
var _moving := false

func _ready() -> void:
	_agent = $NavigationAgent2D
	_agent.path_desired_distance = 12.0
	_agent.target_desired_distance = 12.0
	EventBus.move_to_requested.connect(_on_move_requested)
	# Añadir cámara que siga al protagonista
	var cam := Camera2D.new()
	cam.name = "Camera2D"
	cam.zoom = Vector2(0.5, 0.5)  # zoom out para ver la taberna
	add_child(cam)
	cam.make_current()

func _physics_process(delta: float) -> void:
	if not _moving:
		return
	if _agent.is_navigation_finished():
		_moving = false
		return
	var next := _agent.get_next_path_position()
	var direction := (next - global_position).normalized()
	global_position += direction * MOVE_SPEED * delta

func _on_move_requested(_character_id: String, world_pos: Vector2) -> void:
	_agent.target_position = world_pos
	_moving = true
