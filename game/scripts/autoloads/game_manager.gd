## game_manager.gd
## Estado global del juego. Gestiona el flujo entre pantallas y fases.

extends Node

enum GameState {
	MAIN_MENU,
	LOADING,
	TOWN,
	EXPLORATION,
	COMBAT,
	DIALOGUE,
	CUTSCENE,
	PAUSED,
	GAME_OVER
}

var current_state: GameState = GameState.MAIN_MENU
var previous_state: GameState = GameState.MAIN_MENU

func _ready() -> void:
	EventBus.scene_transition_started.connect(_on_scene_transition_started)

# ============================================================
# API PÚBLICA
# ============================================================

func change_state(new_state: GameState) -> void:
	previous_state = current_state
	current_state = new_state

func go_to_scene(scene_path: String) -> void:
	EventBus.scene_transition_started.emit(scene_path)
	get_tree().change_scene_to_file(scene_path)

func go_to_combat(dungeon_id: String, room_data: Dictionary) -> void:
	WorldState.set_pending_combat(dungeon_id, room_data)
	change_state(GameState.COMBAT)
	go_to_scene("res://scenes/combat/combat_scene.tscn")

func go_to_town() -> void:
	change_state(GameState.TOWN)
	go_to_scene("res://scenes/world/town_scene.tscn")

func pause_game() -> void:
	get_tree().paused = true
	EventBus.game_paused.emit(true)

func resume_game() -> void:
	get_tree().paused = false
	EventBus.game_paused.emit(false)

func is_in_combat() -> bool:
	return current_state == GameState.COMBAT

# ============================================================
# SEÑALES INTERNAS
# ============================================================

func _on_scene_transition_started(scene_name: String) -> void:
	change_state(GameState.LOADING)
