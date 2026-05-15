## state_machine.gd
## StateMachine genérica. Añadir como nodo hijo y poblar con estados (State).

class_name StateMachine
extends Node

# ============================================================
# SEÑALES
# ============================================================
signal state_changed(old_state: State, new_state: State)

# ============================================================
# ESTADO
# ============================================================
var current_state: State = null
var previous_state: State = null
var _states: Dictionary = {}

# ============================================================
# LIFECYCLE
# ============================================================

func _ready() -> void:
	for child in get_children():
		if child is State:
			_states[child.name] = child
			child.state_machine = self

	if _states.size() > 0:
		_transition_to(_states.values()[0])

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)

# ============================================================
# API PÚBLICA
# ============================================================

func transition_to(state_name: String) -> void:
	if not _states.has(state_name):
		push_error("StateMachine: estado no encontrado: " + state_name)
		return
	_transition_to(_states[state_name])

func get_current_state_name() -> String:
	return current_state.name if current_state else ""

func is_in_state(state_name: String) -> bool:
	return current_state != null and current_state.name == state_name

# ============================================================
# INTERNO
# ============================================================

func _transition_to(new_state: State) -> void:
	if current_state == new_state:
		return
	if current_state:
		current_state.exit()
	previous_state = current_state
	current_state = new_state
	current_state.enter()
	state_changed.emit(previous_state, current_state)
