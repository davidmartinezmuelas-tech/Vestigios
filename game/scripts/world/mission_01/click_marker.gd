## click_marker.gd
## Muestra un círculo punteado que se desvanece en el punto de click.
## Instanciar como hijo de la escena de exploración.

extends Node2D

const FADE_TIME := 0.5
const RADIUS := 24.0
const COLOR := Color(1.0, 1.0, 1.0, 0.85)

var _timer := 0.0
var _active := false

func _ready() -> void:
	EventBus.move_to_requested.connect(_on_move_requested)

func _on_move_requested(_char_id: String, world_pos: Vector2) -> void:
	global_position = world_pos
	_timer = FADE_TIME
	_active = true
	queue_redraw()

func _process(delta: float) -> void:
	if not _active:
		return
	_timer -= delta
	if _timer <= 0.0:
		_active = false
		queue_redraw()
		return
	queue_redraw()

func _draw() -> void:
	if not _active:
		return
	var alpha := clampf(_timer / FADE_TIME, 0.0, 1.0)
	var col := Color(COLOR.r, COLOR.g, COLOR.b, alpha * COLOR.a)
	# Círculo exterior punteado (8 segmentos)
	var segments := 12
	for i in segments:
		var angle_a := (float(i) / segments) * TAU
		var angle_b := (float(i + 0.5) / segments) * TAU
		var pa := Vector2(cos(angle_a), sin(angle_a)) * RADIUS
		var pb := Vector2(cos(angle_b), sin(angle_b)) * RADIUS
		draw_line(pa, pb, col, 2.0)
	# Cruz central
	draw_line(Vector2(-8, 0), Vector2(8, 0), col, 1.5)
	draw_line(Vector2(0, -8), Vector2(0, 8), col, 1.5)
