## party_movement_controller.gd
## Gestiona el movimiento del grupo en escenas de exploracion.
## Extiende Node2D para poder usar get_global_mouse_position() correctamente
## con cualquier Camera2D y cualquier zoom — es el metodo mas fiable en Godot 4.

class_name PartyMovementController
extends Node

var _explorers: Dictionary = {}
var _leader_id: String = ""

# ── Inicializacion ────────────────────────────────────────────────────────────

func _ready() -> void:
	EventBus.party_split_changed.connect(_on_split_changed)

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

# ── Input ─────────────────────────────────────────────────────────────────────

func _unhandled_input(event: InputEvent) -> void:
	## Tab → alternar grupo / split
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_TAB:
			WorldState.toggle_party_split()
			get_viewport().set_input_as_handled()
			return

	## Click izquierdo → mover
	if event is InputEventMouseButton \
			and event.pressed \
			and event.button_index == MOUSE_BUTTON_LEFT:
		## Convertir posicion de pantalla a coordenadas de mundo.
		## canvas_transform.affine_inverse() * viewport_mouse_pos = world_pos.
		## Equivalente a get_global_mouse_position() pero funciona desde Node (no Node2D).
		var vp := get_viewport()
		var world_pos: Vector2 = vp.get_canvas_transform().affine_inverse() \
			* vp.get_mouse_position()
		_handle_terrain_click(world_pos)
		get_viewport().set_input_as_handled()

func _handle_terrain_click(world_pos: Vector2) -> void:
	var target_id: String = WorldState.get_selected_explorer()
	EventBus.move_to_requested.emit(target_id, world_pos)

# ── Formacion ─────────────────────────────────────────────────────────────────

func _on_leader_arrived(_character_id: String) -> void:
	if WorldState.party_split:
		return
	_update_follower_targets()

func _update_follower_targets() -> void:
	var leader := _get_leader_node()
	if leader == null:
		return
	var formation := FormationManager.get_formation()
	for i in formation.size():
		var char_id: String = formation[i]
		if char_id == _leader_id or not _explorers.has(char_id):
			continue
		var target := FormationManager.get_formation_target(i, leader.global_position)
		EventBus.move_to_requested.emit(char_id, target)

func _on_split_changed(is_split: bool) -> void:
	if not is_split:
		_update_follower_targets()
		EventBus.party_regrouped.emit()

func _get_leader_node() -> ExplorationCharacter:
	return _explorers.get(_leader_id)
