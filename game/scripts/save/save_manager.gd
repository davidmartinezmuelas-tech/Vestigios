## save_manager.gd
## Guarda y carga la partida en disco como JSON.
## Serializa WorldState (que ya incluye LevelManager y BastionManager).

extends Node

# ============================================================
# SEÑALES
# ============================================================
signal save_completed(slot: int)
signal load_completed(slot: int)
signal save_failed(slot: int, error: String)
signal load_failed(slot: int, error: String)

# ============================================================
# CONSTANTES
# ============================================================
const SAVE_DIR: String   = "user://saves/"
const SAVE_FILE: String  = "user://saves/slot_%d.json"
const BACKUP_FILE: String = "user://saves/slot_%d.backup.json"

# ============================================================
# API PÚBLICA
# ============================================================

func save(slot: int) -> bool:
	_ensure_save_dir()
	var path := SAVE_FILE % slot

	var data := WorldState.to_dict()
	data["save_version"] = 1
	data["timestamp"]    = Time.get_unix_time_from_system()
	data["play_time"]    = _get_play_time()

	# Hacer backup del save anterior antes de sobreescribir
	if FileAccess.file_exists(path):
		var backup_path := BACKUP_FILE % slot
		DirAccess.copy_absolute(path, backup_path)

	var json_str := JSON.stringify(data, "\t")
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		var err := "Error al abrir fichero: %d" % FileAccess.get_open_error()
		save_failed.emit(slot, err)
		push_error("SaveManager: " + err)
		return false

	file.store_string(json_str)
	file.close()

	EventBus.game_saved.emit(slot)
	save_completed.emit(slot)
	return true

func load_save(slot: int) -> bool:
	var path := SAVE_FILE % slot
	if not FileAccess.file_exists(path):
		load_failed.emit(slot, "Fichero no encontrado: " + path)
		return false

	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		var err := "Error al leer fichero: %d" % FileAccess.get_open_error()
		load_failed.emit(slot, err)
		push_error("SaveManager: " + err)
		return false

	var json_str := file.get_as_text()
	file.close()

	var json := JSON.new()
	var parse_result := json.parse(json_str)
	if parse_result != OK:
		var err := "JSON inválido en slot %d: línea %d" % [slot, json.get_error_line()]
		load_failed.emit(slot, err)
		push_error("SaveManager: " + err)
		return false

	var data: Dictionary = json.get_data()
	_apply_save_data(data)

	EventBus.game_loaded.emit(slot)
	load_completed.emit(slot)
	return true

func delete_save(slot: int) -> void:
	var path := SAVE_FILE % slot
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)

func save_exists(slot: int) -> bool:
	return FileAccess.file_exists(SAVE_FILE % slot)

func get_save_metadata(slot: int) -> Dictionary:
	if not save_exists(slot):
		return {}
	var file := FileAccess.open(SAVE_FILE % slot, FileAccess.READ)
	if file == null:
		return {}
	var json := JSON.new()
	if json.parse(file.get_as_text()) != OK:
		file.close()
		return {}
	file.close()
	var data: Dictionary = json.get_data()
	return {
		"slot":       slot,
		"timestamp":  data.get("timestamp", 0),
		"play_time":  data.get("play_time", 0),
		"party_level": data.get("level_manager", {}).get("party_level", 1),
		"active_party": data.get("active_party", []),
	}

# ============================================================
# GUARDADO AUTOMÁTICO
# ============================================================

## Slot 0 reservado para autosave. Llama esto en transiciones importantes.
func autosave() -> void:
	save(0)

# ============================================================
# INTERNO
# ============================================================

func _ensure_save_dir() -> void:
	if not DirAccess.dir_exists_absolute(SAVE_DIR.rstrip("/")):
		DirAccess.make_dir_recursive_absolute(SAVE_DIR.rstrip("/"))

func _apply_save_data(data: Dictionary) -> void:
	WorldState.from_dict(data)

var _session_start_time: float = 0.0

func _ready() -> void:
	_session_start_time = Time.get_unix_time_from_system()

func _get_play_time() -> float:
	return Time.get_unix_time_from_system() - _session_start_time
