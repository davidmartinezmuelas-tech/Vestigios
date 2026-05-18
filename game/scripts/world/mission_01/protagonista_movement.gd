## protagonista_movement.gd
## Mueve el protagonista placeholder de la taberna con click-to-move.
## Adjuntar al nodo "Protagonista" en taberna_karreth.tscn

extends Node2D

const MOVE_SPEED := 300.0

var _agent: NavigationAgent2D
var _moving := false

func _ready() -> void:
	# Crear NavigationAgent2D si no existe (por si no se guardó en el .tscn)
	if get_node_or_null("NavigationAgent2D") == null:
		_agent = NavigationAgent2D.new()
		_agent.name = "NavigationAgent2D"
		add_child(_agent)
	else:
		_agent = $NavigationAgent2D
	_agent.path_desired_distance = 12.0
	_agent.target_desired_distance = 12.0
	_agent.avoidance_enabled = true
	_agent.radius = 40.0

	# Crear sprite visible si no existe
	if get_node_or_null("Sprite") == null:
		var sprite := Sprite2D.new()
		sprite.name = "Sprite"
		sprite.texture = load("res://assets/tilesets/kenney_dungeon/Characters/Male/Male_0_Idle0.png")
		sprite.offset = Vector2(0, -192)
		# z_index heredado del nodo padre (calculado dinámicamente en _physics_process)
		add_child(sprite)

	# Cámara isométrica con suavizado
	if get_node_or_null("Camera2D") == null:
		var cam := Camera2D.new()
		cam.name = "Camera2D"
		cam.zoom = Vector2(0.6, 0.6)
		cam.position_smoothing_enabled = true
		cam.position_smoothing_speed = 5.0
		cam.offset = Vector2(0, -80)   # offset arriba para ver más del mapa
		add_child(cam)
		cam.make_current()

	EventBus.move_to_requested.connect(_on_move_requested)

func _physics_process(delta: float) -> void:
	# Z-index dinámico: el personaje se ordena con los sprites del mapa
	# floor=+0, walls=+1, CHARACTER=+1 (mismo que muros),
	# objects=+2 → objetos y muros del mismo nivel lo tapan
	z_index = int(position.y / 64.0) * 10 + 1

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
