## party_selection_ui.gd
## Pantalla de selección de party al estilo DAI.
## Muestra cartas de todos los personajes disponibles en el roster.
## Click para añadir a la party (en orden = formación). Click de nuevo para quitar.

extends Control

# ============================================================
# SEÑALES
# ============================================================
signal party_confirmed(selected_ids: Array[String])

# ============================================================
# NODOS
# ============================================================
@onready var roster_grid: HFlowContainer  = $RosterGrid
@onready var slot_bar: HBoxContainer      = $SlotBar
@onready var confirm_btn: Button          = $ConfirmButton
@onready var mission_title: Label         = $MissionInfo/Title
@onready var mission_desc: Label          = $MissionInfo/Description
@onready var slots_needed_label: Label    = $SlotBar/SlotsLabel

# ============================================================
# ESTADO
# ============================================================
var _mission: MissionData = null
var _all_character_data: Dictionary = {}   # character_id → CharacterData
var _selected_ids: Array[String] = []      # en orden de formación
var _card_nodes: Dictionary = {}           # character_id → Control (la carta)

# ============================================================
# SETUP
# ============================================================

## Llama esto antes de añadir la escena al árbol.
## character_data_map: Dictionary { character_id: String → CharacterData }
func setup(mission: MissionData, character_data_map: Dictionary) -> void:
	_mission = mission
	_all_character_data = character_data_map
	_selected_ids.clear()

func _ready() -> void:
	confirm_btn.pressed.connect(_on_confirm_pressed)
	confirm_btn.disabled = true
	_build_ui()

# ============================================================
# CONSTRUCCIÓN DE UI
# ============================================================

func _build_ui() -> void:
	if _mission == null:
		return

	mission_title.text = _mission.display_name
	mission_desc.text  = _mission.briefing
	slots_needed_label.text = "Elige %d personajes" % _mission.party_slots

	# Crear slot indicators vacíos
	for i in _mission.party_slots:
		var slot := _build_empty_slot(i + 1)
		slot_bar.add_child(slot)

	# Crear una carta por personaje del roster
	var roster := WorldState.get_roster()
	for character_id in roster:
		var data: CharacterData = _all_character_data.get(character_id)
		if data == null:
			continue
		var card := _build_character_card(data)
		roster_grid.add_child(card)
		_card_nodes[character_id] = card

	# El protagonista siempre va — se pre-selecciona y no se puede quitar
	var protagonist := WorldState.protagonist_id
	if not protagonist.is_empty() and protagonist in WorldState.get_roster():
		_select_character(protagonist, true)

	# Marcar otros obligatorios de la misión
	for required_id in _mission.required_character_ids:
		if required_id != protagonist:
			_select_character(required_id, true)

func _build_character_card(data: CharacterData) -> Control:
	var card := PanelContainer.new()
	card.custom_minimum_size = Vector2(120, 200)
	card.name = "Card_" + data.character_id

	var vbox := VBoxContainer.new()
	card.add_child(vbox)

	# Retrato
	var portrait := TextureRect.new()
	portrait.name = "Portrait"
	portrait.texture = data.get_portrait("neutral")
	portrait.custom_minimum_size = Vector2(120, 150)
	portrait.expand_mode = 3
	portrait.stretch_mode = 6
	vbox.add_child(portrait)

	# Nombre
	var name_label := Label.new()
	name_label.text = data.display_name
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.add_theme_font_size_override("font_size", 11)
	vbox.add_child(name_label)

	# Nivel
	var level_label := Label.new()
	level_label.name = "LevelLabel"
	level_label.text = "Nv. %d" % data.level
	level_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	level_label.add_theme_font_size_override("font_size", 10)
	vbox.add_child(level_label)

	# Badge de slot (número de posición, oculto hasta ser seleccionado)
	var badge := Label.new()
	badge.name = "SlotBadge"
	badge.text = ""
	badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	badge.add_theme_font_size_override("font_size", 14)
	badge.visible = false
	vbox.add_child(badge)

	# Overlay de "no seleccionado" (semitransparente)
	var overlay := ColorRect.new()
	overlay.name = "Overlay"
	overlay.color = Color(0, 0, 0, 0.5)
	overlay.anchor_right = 1.0
	overlay.anchor_bottom = 1.0
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	portrait.add_child(overlay)

	# Hacer la carta clickable (el protagonista no se puede deseleccionar)
	var is_protagonist := data.character_id == WorldState.protagonist_id
	var btn := Button.new()
	btn.flat = true
	btn.anchor_right = 1.0
	btn.anchor_bottom = 1.0
	btn.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	if is_protagonist:
		btn.tooltip_text = "El protagonista siempre va a las misiones."
	else:
		btn.pressed.connect(func(): _on_card_clicked(data.character_id))
	card.add_child(btn)

	return card

func _build_empty_slot(index: int) -> Control:
	var slot := PanelContainer.new()
	slot.name = "Slot_%d" % index
	slot.custom_minimum_size = Vector2(80, 100)

	var label := Label.new()
	label.name = "SlotContent"
	label.text = str(index)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 24)
	label.modulate = Color(0.4, 0.4, 0.4, 1.0)
	slot.add_child(label)

	return slot

# ============================================================
# LÓGICA DE SELECCIÓN
# ============================================================

func _on_card_clicked(character_id: String) -> void:
	# El protagonista y los obligatorios de la misión no se pueden quitar
	if character_id == WorldState.protagonist_id:
		return
	if character_id in _mission.required_character_ids:
		return

	if character_id in _selected_ids:
		_deselect_character(character_id)
	elif _selected_ids.size() < _mission.party_slots:
		_select_character(character_id, false)

func _select_character(character_id: String, required: bool) -> void:
	if character_id in _selected_ids:
		return
	_selected_ids.append(character_id)
	var slot_index := _selected_ids.size()

	# Actualizar carta
	var card := _card_nodes.get(character_id)
	if card:
		card.get_node("VBoxContainer/Portrait/Overlay").color = Color(0, 0, 0, 0)
		var badge: Label = card.get_node("VBoxContainer/SlotBadge")
		badge.text = str(slot_index)
		badge.visible = true
		if required:
			badge.modulate = Color(1.0, 0.8, 0.2, 1.0)  # dorado para obligatorios

	# Actualizar slot bar
	_update_slot_bar()
	_update_confirm_button()

func _deselect_character(character_id: String) -> void:
	var idx := _selected_ids.find(character_id)
	if idx == -1:
		return
	_selected_ids.remove_at(idx)

	# Actualizar carta quitada
	var card := _card_nodes.get(character_id)
	if card:
		card.get_node("VBoxContainer/Portrait/Overlay").color = Color(0, 0, 0, 0.5)
		var badge: Label = card.get_node("VBoxContainer/SlotBadge")
		badge.text = ""
		badge.visible = false

	# Reasignar números a los que quedan
	for i in _selected_ids.size():
		var cid := _selected_ids[i]
		var c := _card_nodes.get(cid)
		if c:
			c.get_node("VBoxContainer/SlotBadge").text = str(i + 1)

	_update_slot_bar()
	_update_confirm_button()

func _update_slot_bar() -> void:
	var slots := slot_bar.get_children().filter(
		func(n: Node) -> bool: return n.name.begins_with("Slot_")
	)
	for i in slots.size():
		var slot: PanelContainer = slots[i]
		var label: Label = slot.get_node("SlotContent")
		if i < _selected_ids.size():
			var data: CharacterData = _all_character_data.get(_selected_ids[i])
			label.text = data.display_name.substr(0, 8) if data else "???"
			label.modulate = Color(1, 1, 1, 1)
		else:
			label.text = str(i + 1)
			label.modulate = Color(0.4, 0.4, 0.4, 1.0)

func _update_confirm_button() -> void:
	confirm_btn.disabled = _selected_ids.size() < _mission.party_slots

# ============================================================
# CONFIRMACIÓN
# ============================================================

func _on_confirm_pressed() -> void:
	WorldState.set_active_party(_selected_ids, _mission.party_slots)
	party_confirmed.emit(_selected_ids)
	queue_free()
