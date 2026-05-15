## character_creation_scene_ui.gd
## Orquesta el flujo de creación del personaje personalizado.
## Pasos: Nombre → Raza → Clase → Trasfondo → Stats → Retrato → Confirmar

extends Control

# ============================================================
# PASOS
# ============================================================
enum Step { NAME, RACE, CLASS, BACKGROUND, STATS, PORTRAIT, CONFIRM }

var _step: Step = Step.NAME
var _config: CustomCharacterConfig = CustomCharacterConfig.new()

# Catálogos cargados desde res://
var _races: Array[RaceData] = []
var _classes: Array[ClassDefinition] = []
var _backgrounds: Array[BackgroundData] = []

# ============================================================
# NODOS
# ============================================================
@onready var step_label: Label           = $StepLabel
@onready var content_area: Control       = $ContentArea
@onready var next_btn: Button            = $NavBar/NextButton
@onready var back_btn: Button            = $NavBar/BackButton

# ============================================================
# LIFECYCLE
# ============================================================

func _ready() -> void:
	_load_catalogs()
	next_btn.pressed.connect(_on_next)
	back_btn.pressed.connect(_on_back)
	_show_step(_step)

func _load_catalogs() -> void:
	var race_paths := [
		"res://data/races/humano.tres",   "res://data/races/elfo.tres",
		"res://data/races/enano.tres",    "res://data/races/semielfo.tres",
		"res://data/races/semiorco.tres", "res://data/races/tiefling.tres",
		"res://data/races/mediano.tres",  "res://data/races/draconido.tres",
		"res://data/races/gnomo.tres",
	]
	for path in race_paths:
		if ResourceLoader.exists(path):
			_races.append(load(path) as RaceData)

	# Cargar todos los trasfondos disponibles
	var bg_ids := ["acolito","animador","artesano","campesino","charlatan","comerciante",
		"criminal","ermitano","erudito","escriba","forastero","guardia","guia",
		"marinero","noble","sabio","soldado","vagabundo"]
	for bg_id in bg_ids:
		var path := "res://data/backgrounds/%s.tres" % bg_id
		if ResourceLoader.exists(path):
			_backgrounds.append(load(path) as BackgroundData)

# ============================================================
# NAVEGACIÓN
# ============================================================

func _show_step(step: Step) -> void:
	for child in content_area.get_children():
		child.queue_free()

	back_btn.visible = step != Step.NAME
	next_btn.text    = "Confirmar" if step == Step.CONFIRM else "Siguiente →"

	match step:
		Step.NAME:       _build_name_step()
		Step.RACE:       _build_selection_step("Elige tu raza", _races, "race")
		Step.CLASS:      _build_selection_step("Elige tu clase", _classes, "chosen_class")
		Step.BACKGROUND: _build_selection_step("Elige tu trasfondo", _backgrounds, "background")
		Step.STATS:      _build_stats_step()
		Step.PORTRAIT:   _build_portrait_step()
		Step.CONFIRM:    _build_confirm_step()

	step_label.text = _step_name(step)

func _on_next() -> void:
	if not _validate_current_step():
		return
	if _step == Step.CONFIRM:
		_finish_creation()
		return
	_step = Step.values()[_step + 1]
	_show_step(_step)

func _on_back() -> void:
	if _step == Step.NAME:
		return
	_step = Step.values()[_step - 1]
	_show_step(_step)

# ============================================================
# PASOS INDIVIDUALES
# ============================================================

func _build_name_step() -> void:
	var vbox := VBoxContainer.new()
	content_area.add_child(vbox)

	var lbl := Label.new()
	lbl.text = "¿Cómo se llama tu personaje?"
	vbox.add_child(lbl)

	var input := LineEdit.new()
	input.placeholder_text = "Nombre..."
	input.text = _config.character_name
	input.custom_minimum_size = Vector2(400, 48)
	input.text_changed.connect(func(t): _config.character_name = t)
	vbox.add_child(input)

func _build_selection_step(title: String, items: Array, config_field: String) -> void:
	var vbox := VBoxContainer.new()
	content_area.add_child(vbox)

	var lbl := Label.new()
	lbl.text = title
	vbox.add_child(lbl)

	var grid := HFlowContainer.new()
	vbox.add_child(grid)

	for item in items:
		var btn := _build_option_card(item, config_field)
		grid.add_child(btn)

func _build_option_card(item: Resource, config_field: String) -> Button:
	var btn := Button.new()
	btn.custom_minimum_size = Vector2(160, 80)
	btn.text = item.get("display_name", "???")

	var current = _config.get(config_field)
	if current == item:
		btn.modulate = Color(1.0, 0.85, 0.2, 1.0)  # dorado = seleccionado

	btn.pressed.connect(func():
		_config.set(config_field, item)
		_show_step(_step)  # refrescar para actualizar selección visual
	)
	return btn

func _build_stats_step() -> void:
	var vbox := VBoxContainer.new()
	content_area.add_child(vbox)

	var lbl := Label.new()
	lbl.text = "Asigna el array estándar: 15, 14, 13, 12, 10, 8"
	vbox.add_child(lbl)

	var abilities := ["Fuerza", "Destreza", "Constitución", "Inteligencia", "Sabiduría", "Carisma"]
	var available := Constants.STANDARD_ARRAY.duplicate()
	available.sort()
	available.reverse()

	if _config.ability_scores.size() != 6:
		_config.ability_scores = [15, 14, 13, 12, 10, 8]

	for i in 6:
		var row := HBoxContainer.new()
		vbox.add_child(row)

		var ability_lbl := Label.new()
		ability_lbl.text = abilities[i]
		ability_lbl.custom_minimum_size = Vector2(120, 0)
		row.add_child(ability_lbl)

		var option_btn := OptionButton.new()
		for val in Constants.STANDARD_ARRAY:
			option_btn.add_item(str(val))
		# Seleccionar el valor actual
		var current_val := _config.ability_scores[i]
		for j in Constants.STANDARD_ARRAY.size():
			if Constants.STANDARD_ARRAY[j] == current_val:
				option_btn.select(j)
				break
		var captured_i := i
		option_btn.item_selected.connect(func(idx):
			_config.ability_scores[captured_i] = Constants.STANDARD_ARRAY[idx]
		)
		row.add_child(option_btn)

		var mod_lbl := Label.new()
		var mod := CharacterData.ability_modifier(_config.ability_scores[i])
		mod_lbl.text = "%s%d" % ["+" if mod >= 0 else "", mod]
		row.add_child(mod_lbl)

func _build_portrait_step() -> void:
	var vbox := VBoxContainer.new()
	content_area.add_child(vbox)

	var lbl := Label.new()
	lbl.text = "Elige tu retrato"
	vbox.add_child(lbl)

	var note := Label.new()
	note.text = "(Los retratos se añadirán cuando esté el arte. De momento usa el placeholder.)"
	note.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
	vbox.add_child(note)

func _build_confirm_step() -> void:
	var vbox := VBoxContainer.new()
	content_area.add_child(vbox)

	var lbl := Label.new()
	lbl.text = "Resumen del personaje"
	lbl.add_theme_font_size_override("font_size", 20)
	vbox.add_child(lbl)

	var info := RichTextLabel.new()
	info.bbcode_enabled = true
	info.fit_content = true
	var race_name   := _config.race.display_name   if _config.race   else "—"
	var class_name  := _config.chosen_class.display_name if _config.chosen_class else "—"
	var bg_name     := _config.background.display_name   if _config.background   else "—"
	var abilities   := ["FUE", "DES", "CON", "INT", "SAB", "CAR"]
	var stats_str   := ""
	for i in 6:
		var val := _config.ability_scores[i] if i < _config.ability_scores.size() else 10
		var mod := CharacterData.ability_modifier(val)
		stats_str += "[b]%s[/b] %d (%s%d)  " % [abilities[i], val, "+" if mod >= 0 else "", mod]
	info.text = "[b]Nombre:[/b] %s\n[b]Raza:[/b] %s\n[b]Clase:[/b] %s\n[b]Trasfondo:[/b] %s\n\n%s" % [
		_config.character_name, race_name, class_name, bg_name, stats_str
	]
	vbox.add_child(info)

# ============================================================
# VALIDACIÓN Y FINALIZACIÓN
# ============================================================

func _validate_current_step() -> bool:
	match _step:
		Step.NAME:
			return not _config.character_name.strip_edges().is_empty()
		Step.RACE:
			return _config.race != null
		Step.CLASS:
			return _config.chosen_class != null
		Step.BACKGROUND:
			return _config.background != null
		_:
			return true

func _finish_creation() -> void:
	var character_data := CharacterBuilder.build(_config)
	LevelManager.sync_character_to_party_level(character_data)

	# El personaje custom es el protagonista
	WorldState.set_protagonist("player_custom")

	SaveManager.autosave()
	GameManager.go_to_scene("res://scenes/world/bastion_scene.tscn")

func _step_name(step: Step) -> String:
	match step:
		Step.NAME:       return "1/7 — Nombre"
		Step.RACE:       return "2/7 — Raza"
		Step.CLASS:      return "3/7 — Clase"
		Step.BACKGROUND: return "4/7 — Trasfondo"
		Step.STATS:      return "5/7 — Características"
		Step.PORTRAIT:   return "6/7 — Aspecto"
		Step.CONFIRM:    return "7/7 — Confirmar"
	return ""
