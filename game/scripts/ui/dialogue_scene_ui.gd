## dialogue_scene_ui.gd
## Controla la pantalla de diálogo: retratos, texto, opciones e interrupciones.
## Solo lee datos del DialogueManager — nunca modifica estado de juego directamente.

extends Control

# ============================================================
# NODOS
# ============================================================
@onready var party_panel: HBoxContainer    = $"../PartyPanel"
@onready var npc_portrait: TextureRect     = $"../NPCPanel/NPCPortrait"
@onready var speaker_name: Label           = $"../TextBox/VBox/SpeakerName"
@onready var dialogue_text: RichTextLabel  = $"../TextBox/VBox/DialogueText"
@onready var continue_hint: Label          = $"../TextBox/VBox/ContinueHint"
@onready var choices_panel: VBoxContainer  = $"../ChoicesPanel"
@onready var interrupt_panel: HBoxContainer = $"../InterruptPanel"

# ============================================================
# ESTADO
# ============================================================
var _npc_data: CharacterData = null
var _party_portraits: Array[Control] = []
var _pending_check: SkillCheckData = null

# ============================================================
# LIFECYCLE
# ============================================================

func _ready() -> void:
	DialogueManager.node_changed.connect(_on_node_changed)
	DialogueManager.interrupt_available.connect(_on_interrupt_available)
	DialogueManager.skill_check_resolved.connect(_on_skill_check_resolved)
	DialogueManager.dialogue_closed.connect(_on_dialogue_closed)

func setup(party_data: Array[CharacterData], npc_data: CharacterData) -> void:
	_npc_data = npc_data
	_build_party_portraits(party_data)

# ============================================================
# ACTUALIZACIÓN DE NODO
# ============================================================

func _on_node_changed(node: DialogueNode) -> void:
	_pending_check = null
	interrupt_panel.visible = false
	_update_portrait(node)
	_update_text(node)
	_update_choices(node)
	_highlight_speaker(node.speaker_id)

func _update_portrait(node: DialogueNode) -> void:
	var speaker_data := _get_character_data(node.speaker_id)
	if speaker_data == null:
		return

	if node.speaker_id == "npc":
		npc_portrait.texture = speaker_data.get_portrait(node.emotion)
	# Los retratos del partido se gestionan por highlight

func _update_text(node: DialogueNode) -> void:
	var speaker_data := _get_character_data(node.speaker_id)
	speaker_name.text = speaker_data.display_name if speaker_data else "???"
	dialogue_text.text = node.text
	continue_hint.visible = node.choices.is_empty() and not node.ends_dialogue

func _update_choices(node: DialogueNode) -> void:
	# Limpiar opciones anteriores
	for child in choices_panel.get_children():
		child.queue_free()

	if node.choices.is_empty():
		choices_panel.visible = false
		return

	choices_panel.visible = true

	for choice in node.choices:
		var btn := _build_choice_button(choice)
		choices_panel.add_child(btn)

func _build_choice_button(choice: DialogueChoice) -> Button:
	var btn := Button.new()
	var available := DialogueManager.is_choice_available(choice)

	if choice.skill_check != null:
		# Mostrar: [HABILIDAD CD X]  bonus del líder  % de éxito
		var check := choice.skill_check
		var leader := DialogueManager._party_data[0] if not DialogueManager._party_data.is_empty() else null
		var bonus_str := ""
		var pct_str := ""
		if leader:
			var bonus := DialogueManager._ability_bonus(leader, check.ability)
			var pct := clampi(int((float(20 - check.difficulty_class + bonus + 1) / 20.0) * 100), 5, 95)
			bonus_str = " [%s%d]" % ["+" if bonus >= 0 else "", bonus]
			pct_str = "  %d%%" % pct
		btn.text = "[%s CD %d]%s %s%s" % [check.skill_name.to_upper(), check.difficulty_class, bonus_str, choice.text, pct_str]
		_pending_check = check
	else:
		btn.text = choice.text

	if not available:
		btn.disabled = true
		btn.text += "  [BLOQUEADO]"
		btn.modulate = Color(0.5, 0.5, 0.5, 1.0)
	else:
		btn.pressed.connect(func(): DialogueManager.select_choice(choice))

	return btn

# ============================================================
# INTERRUPCIONES
# ============================================================

func _on_interrupt_available(character_data: CharacterData, bonus: int) -> void:
	interrupt_panel.visible = true
	var btn := Button.new()
	var sign_str := "+" if bonus >= 0 else ""
	btn.text = "%s [%s%d]" % [character_data.display_name, sign_str, bonus]
	btn.pressed.connect(func():
		DialogueManager.accept_interrupt(character_data)
		interrupt_panel.visible = false
		_refresh_choice_bonuses()
	)
	interrupt_panel.add_child(btn)

func _refresh_choice_bonuses() -> void:
	if DialogueManager.get_current_node() != null:
		_update_choices(DialogueManager.get_current_node())

# ============================================================
# RETRATOS DEL PARTIDO
# ============================================================

func _build_party_portraits(party_data: Array[CharacterData]) -> void:
	for child in party_panel.get_children():
		child.queue_free()
	_party_portraits.clear()

	for member in party_data:
		var container := _build_portrait_container(member)
		party_panel.add_child(container)
		_party_portraits.append(container)

func _build_portrait_container(member: CharacterData) -> Control:
	var container := VBoxContainer.new()
	container.custom_minimum_size = Vector2(80, 120)

	var portrait := TextureRect.new()
	portrait.texture = member.get_portrait("neutral")
	portrait.expand_mode = 3
	portrait.stretch_mode = 6
	portrait.custom_minimum_size = Vector2(80, 100)
	portrait.name = "Portrait_" + member.character_id
	container.add_child(portrait)

	var label := Label.new()
	label.text = member.display_name
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 10)
	container.add_child(label)

	return container

func _highlight_speaker(speaker_id: String) -> void:
	for container in _party_portraits:
		container.modulate = Color(0.4, 0.4, 0.4, 1.0)

	if speaker_id == "npc":
		npc_portrait.modulate = Color(1, 1, 1, 1)
		return

	npc_portrait.modulate = Color(0.4, 0.4, 0.4, 1.0)

	for container in _party_portraits:
		var portrait := container.get_node_or_null("Portrait_" + speaker_id)
		if portrait:
			container.modulate = Color(1, 1, 1, 1)
			break

# ============================================================
# INPUT
# ============================================================

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if DialogueManager.get_current_node() != null:
			var node := DialogueManager.get_current_node()
			if node.choices.is_empty():
				DialogueManager.advance()

# ============================================================
# CIERRE
# ============================================================

func _on_skill_check_resolved(passed: bool, roll: int, total: int, dc: int) -> void:
	var result := "¡Éxito! (%d)" % total if passed else "Fracaso (%d)" % total
	dialogue_text.text += "\n\n[i]%s[/i]" % result

func _on_dialogue_closed(_id: String) -> void:
	queue_free()

# ============================================================
# UTILIDADES
# ============================================================

func _get_character_data(speaker_id: String) -> CharacterData:
	if speaker_id == "npc":
		return _npc_data
	for member in DialogueManager._party_data:
		if member.character_id == speaker_id:
			return member
	return null
