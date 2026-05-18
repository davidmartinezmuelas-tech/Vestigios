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
	# Solo ejecutar si no hay hijos ya configurados
	if get_node_or_null("NavigationRegion2D") == null:
		_setup_scene()

func iso_pos(mx: int, my: int) -> Vector2:
	return Vector2((mx - my) * TILE_W / 2.0, (mx + my) * TILE_H / 2.0)

func _setup_scene() -> void:
	_add_navigation()
	_add_character()
	_add_movement_controller()

func _add_navigation() -> void:
	var nav := NavigationRegion2D.new()
	nav.name = "NavigationRegion2D"

	var poly := NavigationPolygon.new()

	# Polígono del suelo interior (tiles 1,1 a 8,8 para dejar margen de paredes)
	# + apertura en la pared derecha (filas 4-5 del TMX)
	var outline := PackedVector2Array()
	# Esquinas del interior en orden: arriba → derecha → abajo → izquierda
	outline.append(iso_pos(1, 1) + Vector2(0, 64))   # arriba
	outline.append(iso_pos(8, 1) + Vector2(64, 32))  # derecha-arriba
	outline.append(iso_pos(8, 8) + Vector2(0, 64))   # abajo
	outline.append(iso_pos(1, 8) + Vector2(-64, 32)) # izquierda

	poly.add_outline(outline)
	poly.make_polygons_from_outlines()
	nav.navigation_polygon = poly

	add_child(nav)
	nav.owner = get_tree().edited_scene_root

func _add_character() -> void:
	var char_node := Node2D.new()
	char_node.name = "Protagonista"

	# Sprite placeholder con el personaje de Kenney
	var sprite := Sprite2D.new()
	sprite.name = "Sprite"
	sprite.texture = load("res://assets/tilesets/kenney_dungeon/Characters/Male/Male_0_Idle0.png")
	sprite.offset = Vector2(0, -192)  # Mismo offset que los tiles
	sprite.z_index = 100  # Por encima de todo
	char_node.add_child(sprite)
	sprite.owner = get_tree().edited_scene_root

	# NavigationAgent2D para el pathfinding
	var agent := NavigationAgent2D.new()
	agent.name = "NavigationAgent2D"
	agent.path_desired_distance = 12.0
	agent.target_desired_distance = 12.0
	char_node.add_child(agent)
	agent.owner = get_tree().edited_scene_root

	# Posición inicial: centro de la taberna
	char_node.position = iso_pos(4, 4) + Vector2(0, 64)

	add_child(char_node)
	char_node.owner = get_tree().edited_scene_root

func _add_movement_controller() -> void:
	var controller := Node.new()
	controller.name = "PartyMovementController"
	controller.set_script(
		load("res://scripts/world/party_movement_controller.gd")
	)
	add_child(controller)
	controller.owner = get_tree().edited_scene_root
