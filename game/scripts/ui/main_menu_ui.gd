extends Control

func _ready() -> void:
	$VBox/NewGameButton.pressed.connect(_on_new_game)
	$VBox/QuitButton.pressed.connect(_on_quit)
	_build_slots()

func _build_slots() -> void:
	for child in $VBox/SlotsContainer.get_children():
		child.queue_free()
	for slot in range(1, Constants.SAVE_SLOTS + 1):
		var btn := Button.new()
		btn.custom_minimum_size = Vector2(0, 60)
		if SaveManager.save_exists(slot):
			var meta: Dictionary = SaveManager.get_save_metadata(slot)
			var lvl: int = meta.get("party_level", 1)
			btn.text = "Slot %d  Nivel %d" % [slot, lvl]
			btn.pressed.connect(func(): _on_load(slot))
		else:
			btn.text = "Slot %d  -  Vacio" % slot
			btn.disabled = true
		$VBox/SlotsContainer.add_child(btn)

func _on_new_game() -> void:
	GameManager.go_to_scene("res://scenes/ui/protagonist_select_scene.tscn")

func _on_load(slot: int) -> void:
	if SaveManager.load_save(slot):
		GameManager.go_to_scene("res://scenes/world/bastion_scene.tscn")

func _on_quit() -> void:
	get_tree().quit()
