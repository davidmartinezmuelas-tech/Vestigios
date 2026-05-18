## taberna_setup.gd
## Script @tool que configura la escena de la taberna:
## - NavigationRegion2D con el polígono del suelo interior
## - Personaje protagonista placeholder
## - PartyMovementController
@tool
extends Node2D

const TILE_W := 256
const TILE_H := 128

func _ready() -> void:
	if not Engine.is_editor_hint():
		return
	# Volver a ejecutar si faltan nodos del setup
	var needs_setup := get_node_or_null("NavigationRegion2D") == null \
		or get_node_or_null("ClickMarker") == null \
		or get_node_or_null("Protagonista") == null
	if needs_setup:
		_setup_scene()

func iso_pos(mx: int, my: int) -> Vector2:
	return Vector2((mx - my) * TILE_W / 2.0, (mx + my) * TILE_H / 2.0)

func _setup_scene() -> void:
	if get_node_or_null("NavigationRegion2D") == null:
		_add_navigation()
	if get_node_or_null("@NavigationObstacle2D@0") == null \
			and get_children().filter(func(n): return n is NavigationObstacle2D).is_empty():
		_add_obstacles()
	if get_node_or_null("Protagonista") == null:
		_add_character()
	if get_node_or_null("ClickMarker") == null:
		_add_click_marker()
	if get_node_or_null("PartyMovementController") == null:
		_add_movement_controller()

func _add_obstacles() -> void:
	## Añade NavigationObstacle2D en las posiciones de objetos interiores
	## para que el pathfinding los evite (barriles, mesas, bancos).
	## Posiciones extraídas del TMX (capas walls + objects, interior 1-8).
	var object_positions: Array[Vector2i] = [
		Vector2i(1,2), Vector2i(1,3), Vector2i(1,4),
		Vector2i(2,1), Vector2i(2,5),
		Vector2i(3,3), Vector2i(3,7),
		Vector2i(4,1), Vector2i(4,5),
		Vector2i(5,3), Vector2i(5,7),
		Vector2i(6,1), Vector2i(6,5),
	]

	for map_pos in object_positions:
		var obstacle := NavigationObstacle2D.new()
		obstacle.radius = 80.0
		obstacle.avoidance_enabled = true
		var screen_pos := iso_pos(map_pos.x, map_pos.y)
		obstacle.position = screen_pos + Vector2(0, 64)
		# Añadir al árbol antes de asignar owner
		add_child(obstacle)
		obstacle.owner = get_tree().edited_scene_root

func _tile_diamond_hole(mx: int, my: int, margin: int = 15) -> PackedVector2Array:
	## Diamante del tile (mx,my) en sentido antihorario (hueco para NavigationPolygon).
	## El límite exterior es horario → huecos deben ser antihorarios.
	## En coordenadas de pantalla (Y hacia abajo):
	##   Top → Left → Bottom → Right = antihorario
	var cx: float = (mx - my) * 128.0
	var cy: float = (mx + my) * 64.0 + 64.0
	return PackedVector2Array([
		Vector2(cx,                cy - 64 + margin),  # Arriba
		Vector2(cx - 128 + margin, cy + margin),       # Izquierda
		Vector2(cx,                cy + 64 - margin),  # Abajo
		Vector2(cx + 128 - margin, cy + margin),       # Derecha
	])

func _add_navigation() -> void:
	var nav := NavigationRegion2D.new()
	nav.name = "NavigationRegion2D"

	var poly := NavigationPolygon.new()

	# ── Límite exterior: horario en coords de pantalla ────────────
	var outer := PackedVector2Array([
		iso_pos(1, 1) + Vector2(0,   64),   # NW
		iso_pos(8, 1) + Vector2(64,  32),   # NE
		iso_pos(8, 8) + Vector2(0,   64),   # SE
		iso_pos(1, 8) + Vector2(-64, 32),   # SW
	])
	poly.add_outline(outer)

	# ── Huecos de objetos: antihorario (opuesto al exterior) ──────
	var blocked: Array[Vector2i] = [
		Vector2i(1,2), Vector2i(1,3), Vector2i(1,4),
		Vector2i(2,1), Vector2i(2,5),
		Vector2i(3,3), Vector2i(3,7),
		Vector2i(4,1), Vector2i(4,5),
		Vector2i(5,3), Vector2i(5,7),
		Vector2i(6,1), Vector2i(6,5),
	]
	for p in blocked:
		poly.add_outline(_tile_diamond_hole(p.x, p.y))

	# ── Generar polígonos (síncrono, deprecated pero funcional) ───
	poly.make_polygons_from_outlines()
	nav.navigation_polygon = poly

	add_child(nav)
	nav.owner = get_tree().edited_scene_root

func _add_character() -> void:
	var char_node := Node2D.new()
	char_node.name = "Protagonista"
	char_node.position = iso_pos(4, 4) + Vector2(0, 64)

	# Añadir al árbol PRIMERO para poder asignar owner a los hijos
	add_child(char_node)
	char_node.owner = get_tree().edited_scene_root

	# Sprite placeholder con el personaje de Kenney
	var sprite := Sprite2D.new()
	sprite.name = "Sprite"
	sprite.texture = load("res://assets/tilesets/kenney_dungeon/Characters/Male/Male_0_Idle0.png")
	sprite.offset = Vector2(0, -192)
	char_node.add_child(sprite)
	sprite.owner = get_tree().edited_scene_root

	# NavigationAgent2D para el pathfinding
	var agent := NavigationAgent2D.new()
	agent.name = "NavigationAgent2D"
	agent.path_desired_distance = 12.0
	agent.target_desired_distance = 12.0
	char_node.add_child(agent)
	agent.owner = get_tree().edited_scene_root

func _add_click_marker() -> void:
	var marker := Node2D.new()
	marker.name = "ClickMarker"
	marker.set_script(load("res://scripts/world/mission_01/click_marker.gd"))
	marker.z_index = 1000
	add_child(marker)
	marker.owner = get_tree().edited_scene_root

func _add_movement_controller() -> void:
	var controller := Node.new()
	controller.name = "PartyMovementController"
	controller.set_script(
		load("res://scripts/world/party_movement_controller.gd")
	)
	add_child(controller)
	controller.owner = get_tree().edited_scene_root
