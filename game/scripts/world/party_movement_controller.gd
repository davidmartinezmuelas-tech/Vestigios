## party_movement_controller.gd
## Gestiona el movimiento del grupo en escenas de exploración.
## Instanciar como hijo de cada escena de exploración y llamar a setup().
##
## Modo GRUPO (party_split = false):
##   Click en terreno → líder navega; al llegar, seguidores van a sus offsets.
## Modo SPLIT (party_split = true):
##   Click en terreno → solo el personaje seleccionado navega.
##   Click sobre personaje → lo selecciona.
##   Tab → vuelve a modo grupo y todos reagrupan.

class_name PartyMovementController
extends Node

## Mapa character_id → ExplorationCharacter
var _explorers: Dictionary = {}
var _leader_id: String = ""

# ============================================================
# INICIALIZACIÓN
# ============================================================

## Llamar desde la escena tras instanciar todos los ExplorationCharacter.
func setup(explorer_nodes: Array) -> void:
	_explorers.clear()
	_leader_id = WorldState.protagonist_id

	for node in explorer_nodes:
		var explorer := node as ExplorationCharacter
		if explorer == null:
			continue
		_explorers[explorer.character_id] = explorer
		if explorer.character_id == _leader_id:
			explorer.arrived.connect(_on_leader_arrived)

# ============================================================
# INPUT
# ============================================================

func _unhandled_input(event: InputEvent) -> void:
	# Tab → alternar modo grupo / split
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_TAB:
			WorldState.toggle_party_split()
			get_viewport().set_input_as_handled()
			return

	# Click izquierdo → mover
	if event is InputEventMouseButton \
			and event.pressed \
			and event.button_index == MOUSE_BUTTON_LEFT:
		# Convertir posición de pantalla a coordenadas globales del mundo
		var world_pos: Vector2 = get_viewport().get_canvas_transform().affine_inverse() \
			* event.position
		if not _is_terrain_click(world_pos):
			return
		_handle_terrain_click(world_pos)
		get_viewport().set_input_as_handled()

func _handle_terrain_click(world_pos: Vector2) -> void:
	var target_id := WorldState.get_selected_explorer()
	EventBus.move_to_requested.emit(target_id, world_pos)

# ============================================================
# SEGUIMIENTO DE FORMACIÓN
# ============================================================

## Cuando el líder llega a su destino, los seguidores se mueven a sus posiciones.
func _on_leader_arrived(_character_id: String) -> void:
	if WorldState.party_split:
		return
	_update_follower_targets()

## Calcula y emite las órdenes de movimiento para cada seguidor.
func _update_follower_targets() -> void:
	var leader := _get_leader_node()
	if leader == null:
		return
	var formation := FormationManager.get_formation()
	for i in formation.size():
		var char_id: String = formation[i]
		if char_id == _leader_id:
			continue
		if not _explorers.has(char_id):
			continue
		var target := FormationManager.get_formation_target(i, leader.global_position)
		EventBus.move_to_requested.emit(char_id, target)

# ============================================================
# SPLIT PARTY — reacción al toggle
# ============================================================

func _ready() -> void:
	EventBus.party_split_changed.connect(_on_split_changed)

func _on_split_changed(is_split: bool) -> void:
	if not is_split:
		# Reagrupar: todos navegan a sus posiciones de formación
		_update_follower_targets()
		EventBus.party_regrouped.emit()

# ============================================================
# HELPERS
# ============================================================

func _get_leader_node() -> ExplorationCharacter:
	return _explorers.get(_leader_id)

## Devuelve true si el click fue sobre terreno navegable (no UI ni colisionable).
## Las escenas pueden conectar su propia lógica sobreescribiendo este método.
func _is_terrain_click(_world_pos: Vector2) -> bool:
	return true
