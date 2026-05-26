## protagonista_movement.gd
## Mueve al protagonista con click-to-move y anima con 8 direcciones.
## Adjuntar al nodo "Protagonista" en taberna_karreth.tscn

extends Node2D

const MOVE_SPEED := 180.0

@export var character_id: String = "protagonista"
## assets_path se sobrescribe en _ready() segun el personaje elegido.
## Por defecto apunta a Johannes (unico con sprites completos por ahora).
@export var assets_path: String = "res://assets/characters/johannes"

## Mapa de character_id → carpeta de assets
const CHARACTER_ASSETS: Dictionary = {
	"johannes": "res://assets/characters/johannes",
	"naeren":   "res://assets/characters/johannes",  ## placeholder hasta tener sus sprites
	"lyth":     "res://assets/characters/johannes",
	"vael":     "res://assets/characters/johannes",
	"mia":      "res://assets/characters/johannes",
}

var _agent: NavigationAgent2D
var _animator: Node
var _moving := false
var _velocity: Vector2 = Vector2.ZERO
## True cuando el NavigationRegion2D ya esta registrado en el servidor
var _nav_ready := false

func _ready() -> void:
	## Si ya hay protagonista asignado (viene del menú), este nodo adopta ese ID.
	## Si no (testing directo de escena), se registra con su ID por defecto.
	if not WorldState.protagonist_id.is_empty():
		character_id = WorldState.protagonist_id
		if CHARACTER_ASSETS.has(character_id):
			assets_path = CHARACTER_ASSETS[character_id]
	else:
		WorldState.protagonist_id = character_id
	_ensure_navigation()
	_setup_agent()
	_setup_sprite()
	_setup_camera()
	_setup_animator()
	EventBus.move_to_requested.connect(_on_move_requested)

# ── Navegacion ────────────────────────────────────────────────────────────────

func _ensure_navigation() -> void:
	var parent: Node = get_parent()
	if parent == null:
		return

	## Construir el NavigationPolygon con los huecos correctos
	var poly := NavigationPolygon.new()

	## Limite exterior. Correccion -80 en Y para alinear con el suelo visual.
	var dy := -80
	poly.add_outline(PackedVector2Array([
		_nav_iso(1, 1) + Vector2(0,   64 + dy),
		_nav_iso(8, 1) + Vector2(64,  32 + dy),
		_nav_iso(8, 8) + Vector2(0,   64 + dy),
		_nav_iso(1, 8) + Vector2(-64, 32 + dy),
	]))

	## Huecos para cada objeto — Johannes no puede entrar en estas areas.
	## Mismas posiciones que _paint_objects() en taberna_painter.gd.
	var blocked: Array[Vector2i] = [
		Vector2i(2, 2),                                    ## chimenea
		Vector2i(6, 2), Vector2i(7, 2), Vector2i(8, 2),   ## barra
		Vector2i(2, 4), Vector2i(5, 4),                    ## mesas fila norte
		Vector2i(2, 6), Vector2i(5, 6),                    ## mesas fila sur
		Vector2i(7, 7), Vector2i(8, 7),                    ## barriles
	]
	for p: Vector2i in blocked:
		poly.add_outline(_nav_diamond_hole(p.x, p.y))

	poly.make_polygons_from_outlines()

	## Reusar la region existente si hay una, o crear una nueva
	var nav := parent.get_node_or_null("NavigationRegion2D") as NavigationRegion2D
	if nav == null:
		nav = NavigationRegion2D.new()
		nav.name = "NavigationRegion2D"
		parent.add_child.call_deferred(nav)
		## Esperar a que el nodo este en el arbol antes de asignar el polygon
		await get_tree().process_frame
	nav.navigation_polygon = poly
	await get_tree().process_frame
	_nav_ready = true

func _nav_iso(mx: int, my: int) -> Vector2:
	return Vector2((mx - my) * 128.0, (mx + my) * 64.0)

func _nav_diamond_hole(mx: int, my: int) -> PackedVector2Array:
	## Diamante CCW (antihorario) para hacer un hueco en el NavigationPolygon.
	## El limite exterior es CW, los huecos deben ser CCW.
	## Margen de 20px para que el path tenga espacio de paso alrededor del objeto.
	var m := 20
	var cx: float = (mx - my) * 128.0
	var cy: float = (mx + my) * 64.0 + (64.0 - 80.0)  ## correccion -80 igual que el limite
	return PackedVector2Array([
		Vector2(cx,           cy - 64 + m),  ## norte
		Vector2(cx - 128 + m, cy + m),       ## oeste
		Vector2(cx,           cy + 64 - m),  ## sur
		Vector2(cx + 128 - m, cy + m),       ## este
	])

# ── Setup de nodos ────────────────────────────────────────────────────────────

func _setup_agent() -> void:
	if get_node_or_null("NavigationAgent2D") == null:
		_agent = NavigationAgent2D.new()
		_agent.name = "NavigationAgent2D"
		add_child(_agent)
	else:
		_agent = $NavigationAgent2D
	_agent.path_desired_distance = 8.0   ## tolerancia para waypoints intermedios
	_agent.target_desired_distance = 4.0  ## tolerancia final: para a 4px del click
	_agent.avoidance_enabled = false

func _setup_sprite() -> void:
	# Eliminar sprite estático viejo si existe
	for name in ["Sprite", "DebugDot"]:
		var old := get_node_or_null(name)
		if old != null:
			old.queue_free()

	if get_node_or_null("AnimatedSprite2D") != null:
		return
	var spr := AnimatedSprite2D.new()
	spr.name = "AnimatedSprite2D"
	## offset Y = -(sprite_px * scale / 2) / scale = -sprite_px/2 = -34
	## Con scale=3: offset_world = -34*3 = -102 → pie del sprite en origen del nodo
	## Offset calibrado: pies visualmente en el suelo isometrico.
	## La superficie del diamante del tile esta ~80px encima del nodo (offset=-18×scale=4).
	## Para que los pies coincidan: offset = -(sprite_halfheight + floor_visual_offset/scale)
	## = -(34 + 80/3) ≈ -60. Valor aproximado que funciona bien visualmente.
	spr.offset = Vector2(0, -60)
	spr.scale = Vector2(3.0, 3.0)
	spr.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(spr)

func _setup_camera() -> void:
	if get_node_or_null("Camera2D") != null:
		return
	var cam := Camera2D.new()
	cam.name = "Camera2D"
	cam.zoom = Vector2(0.6, 0.6)
	cam.position_smoothing_enabled = true
	cam.position_smoothing_speed = 5.0
	cam.offset = Vector2(0, -80)
	add_child(cam)
	cam.make_current()

func _setup_animator() -> void:
	if get_node_or_null("CharacterAnimator") != null:
		_animator = $CharacterAnimator
		return
	var script: Script = load("res://scripts/world/character_animator.gd")
	if script == null:
		return
	_animator = Node.new()
	_animator.name = "CharacterAnimator"
	_animator.set_script(script)
	_animator.set("assets_base_path", assets_path)
	add_child(_animator)

# ── Movimiento ────────────────────────────────────────────────────────────────

func _physics_process(delta: float) -> void:
	## Precision 1px: misma escala que los objetos (1000 + y).
	## A igual Y que un objeto: objeto z = 1000+y+1, personaje z = 1000+y.
	## Personaje avanza 1px → z = 1000+(y+1) > objeto → aparece encima. Exacto.
	## Maximo: 1000+1024 = 2024 << limite Godot (4096). Sin errores CANVAS_ITEM_Z_MAX.
	z_index = 1000 + int(position.y)

	if not _moving:
		_velocity = Vector2.ZERO
		return

	## Esperar a que la navegacion este lista antes de consultar el path
	if not _nav_ready:
		return

	if _agent.is_navigation_finished():
		## Snap exacto al punto de destino para maxima precision
		global_position = _agent.target_position
		_stop()
		return

	var next: Vector2 = _agent.get_next_path_position()
	var dir: Vector2 = next - global_position
	var dist: float = dir.length()

	if dist < 1.0:
		## Ya estamos encima del waypoint, dejar al agente avanzar al siguiente
		return

	## Mover sin sobrepasar el waypoint: limitar el paso al minimo de velocidad y distancia
	var step: float = minf(MOVE_SPEED * delta, dist)
	_velocity = dir.normalized() * (step / delta)
	global_position += dir.normalized() * step

	if _animator != null and _animator.has_method("update_direction"):
		_animator.call("update_direction", _velocity)

func _stop() -> void:
	_moving = false
	_velocity = Vector2.ZERO
	if _animator != null and _animator.has_method("play_idle"):
		_animator.call("play_idle")

func _on_move_requested(target_id: String, world_pos: Vector2) -> void:
	## Acepta el comando si:
	##   - el ID coincide exactamente con este personaje
	##   - el ID esta vacio (modo test sin WorldState configurado)
	##   - el ID es el protagonista actual en WorldState
	var is_mine := target_id == character_id \
		or target_id.is_empty() \
		or target_id == WorldState.protagonist_id
	if not is_mine:
		return

	if not _nav_ready:
		push_warning("ProtagonistaMovement: nav no lista, ignora click")
		return

	## Obtener el punto navegable mas cercano al destino antes de asignarlo.
	## Si el click cae dentro de un obstaculo o fuera del nav polygon,
	## el personaje navegara suavemente al borde mas proximo en vez de teletransportarse.
	var nav_map: RID = get_world_2d().get_navigation_map()
	var valid_pos: Vector2 = NavigationServer2D.map_get_closest_point(nav_map, world_pos)
	_agent.target_position = valid_pos
	_moving = true
