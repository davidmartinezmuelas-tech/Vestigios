## main_menu_ui.gd
## Menú principal: nueva partida, cargar, salir.
## Los 3 slots muestran nivel del partido y fecha del guardado.

extends Control

@onready var new_game_btn: Button  = $VBox/NewGameButton
@onready var slots_container: VBoxContainer = $VBox/SlotsContainer
@onready var quit_btn: Button      = $VBox/QuitButton
@onready var title_label: Label    = $Title

func _ready() -> void:
	title_label.text = "VESTIGIOS"
	new_game_btn.pressed.connect(_on_new_game)
	quit_btn.pressed.connect(_on_quit)
	_build_save_slots()

# ============================================================
# SLOTS DE GUARDADO
# ============================================================

func _build_save_slots() -> void:
	for child in slots_container.get_children():
		child.queue_free()

	for slot in range(1, Constants.SAVE_SLOTS + 1):
		var btn := _build_slot_button(slot)
		slots_container.add_child(btn)

func _build_slot_button(slot: int) -> Button:
	var btn := Button.new()
	btn.custom_minimum_size = Vector2(0, 60)

	if SaveManager.save_exists(slot):
		var meta := SaveManager.get_save_metadata(slot)
		var timestamp: int = meta.get("timestamp", 0)
		var date_str := Time.get_datetime_string_from_unix_time(timestamp).substr(0, 16)
		var level: int   = meta.get("party_level", 1)
		var party: Array = meta.get("active_party", [])
		btn.text = "SLOT %d — Nivel %d  |  %s\n%s" % [
			slot, level, date_str, ", ".join(party)
		]
		btn.pressed.connect(func(): _on_load_slot(slot))
	else:
		btn.text = "SLOT %d — Vacío" % slot
		btn.disabled = true

	return btn

# ============================================================
# ACCIONES
# ============================================================

func _on_new_game() -> void:
	# TODO: redirigir a protagonist_select cuando esté listo
	# Por ahora va directo a la taberna para probar el movimiento
	GameManager.go_to_scene("res://scenes/world/mission_01/taberna_karreth.tscn")

func _on_load_slot(slot: int) -> void:
	if SaveManager.load_save(slot):
		GameManager.go_to_scene("res://scenes/world/bastion_scene.tscn")

func _on_quit() -> void:
	get_tree().quit()
