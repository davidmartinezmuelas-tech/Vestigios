## exploration_character.gd
## Componente de movimiento para personajes en escenas de exploración.
## Requiere un hijo NavigationAgent2D llamado "NavigationAgent2D".
##
## La escena de exploración instancia un nodo por personaje activo y
## llama a setup(character_id, is_protagonist) tras añadirlo al árbol.

class_name ExplorationCharacter
extends Node2D

const MOVE_SPEED: float = 180.0
const ARRIVAL_THRESHOLD: float = 12.0

@export var character_id: String = ""
@export var is_protagonist: bool = false

var _agent: NavigationAgent2D
var _moving: bool = false

## Emitida cuando el personaje alcanza su destino.
signal arrived(character_id: String)

func _ready() -> void:
	_agent = $NavigationAgent2D
	_agent.path_desired_distance = ARRIVAL_THRESHOLD
	_agent.target_desired_distance = ARRIVAL_THRESHOLD
	_agent.velocity_computed.connect(_on_velocity_computed)
	EventBus.move_to_requested.connect(_on_move_to_requested)

func _physics_process(_delta: float) -> void:
	if not _moving:
		return
	if _agent.is_navigation_finished():
		_moving = false
		arrived.emit(character_id)
		return
	var next := _agent.get_next_path_position()
	var velocity := (next - global_position).normalized() * MOVE_SPEED
	_agent.set_velocity(velocity)

func _on_velocity_computed(safe_velocity: Vector2) -> void:
	if _moving:
		global_position += safe_velocity * get_physics_process_delta_time()

## Mueve este personaje a una posición mundial.
func move_to(world_pos: Vector2) -> void:
	_agent.target_position = world_pos
	_moving = true

## Detiene el movimiento inmediatamente.
func stop() -> void:
	_moving = false

## Recibe órdenes de movimiento del EventBus.
func _on_move_to_requested(target_id: String, world_pos: Vector2) -> void:
	if target_id == character_id:
		move_to(world_pos)

## Inicializa el componente. Llamar desde la escena tras instanciar.
func setup(char_id: String, protagonist: bool) -> void:
	character_id = char_id
	is_protagonist = protagonist

# ============================================================
# SELECCIÓN EN SPLIT MODE
# ============================================================

## Radio en píxeles para detectar click sobre el personaje.
const CLICK_RADIUS: float = 24.0

func _unhandled_input(event: InputEvent) -> void:
	if not WorldState.party_split:
		return
	if is_protagonist:
		return  # el protagonista siempre está "seleccionado" como fallback
	if event is InputEventMouseButton \
			and event.pressed \
			and event.button_index == MOUSE_BUTTON_LEFT:
		var local := to_local(get_global_mouse_position())
		if local.length() <= CLICK_RADIUS:
			WorldState.select_explorer(character_id)
			get_viewport().set_input_as_handled()
