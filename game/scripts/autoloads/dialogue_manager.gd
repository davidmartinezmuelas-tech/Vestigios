## dialogue_manager.gd
## Gestiona el flujo de diálogos: abre la pantalla, avanza nodos, resuelve tiradas.
##
## LÓGICA DE INTERRUPCIÓN:
##   Por defecto, las tiradas de habilidad las hace el líder de la party (índice 0 en
##   FormationManager). Si un compañero tiene un bonus ≥ INTERRUPT_THRESHOLD más alto
##   para esa habilidad, su retrato muestra una opción de interrupción.

extends Node

# ============================================================
# SEÑALES
# ============================================================
signal dialogue_opened(dialogue: DialogueData)
signal dialogue_closed(dialogue_id: String)
signal node_changed(node: DialogueNode)
signal choice_made(choice: DialogueChoice)
signal skill_check_resolved(passed: bool, roll: int, total: int, dc: int)
signal interrupt_available(character_data: CharacterData, bonus: int)

# ============================================================
# CONSTANTES
# ============================================================
## Diferencia mínima de bonus para que un compañero ofrezca interrumpir
const INTERRUPT_THRESHOLD: int = 3

# ============================================================
# ESTADO
# ============================================================
var _active_dialogue: DialogueData = null
var _current_node: DialogueNode = null
var _active_speaker: CharacterData = null  # quién hace la próxima tirada
var _party_data: Array[CharacterData] = []  # copia de los datos del partido

# ============================================================
# API PÚBLICA — ABRIR / CERRAR
# ============================================================

## Abre un diálogo. party_data = array de CharacterData del partido actual.
func open_dialogue(dialogue: DialogueData, party_data: Array[CharacterData]) -> void:
	if _active_dialogue != null:
		return
	_active_dialogue = dialogue
	_party_data = party_data
	_active_speaker = party_data[0] if not party_data.is_empty() else null

	EventBus.dialogue_started.emit(dialogue.dialogue_id)
	dialogue_opened.emit(dialogue)
	_go_to_node(dialogue.start_node_id)
	GameManager.change_state(GameManager.GameState.DIALOGUE)

func close_dialogue() -> void:
	if _active_dialogue == null:
		return
	var id := _active_dialogue.dialogue_id
	_active_dialogue = null
	_current_node = null
	_active_speaker = null

	EventBus.dialogue_ended.emit(id)
	dialogue_closed.emit(id)
	GameManager.change_state(GameManager.GameState.EXPLORATION)

# ============================================================
# API PÚBLICA — AVANZAR
# ============================================================

## El jugador pulsa "Continuar" en un nodo sin opciones.
func advance() -> void:
	if _current_node == null:
		return
	if not _current_node.choices.is_empty():
		return
	if _current_node.ends_dialogue:
		close_dialogue()
		return
	if not _current_node.auto_next.is_empty():
		_go_to_node(_current_node.auto_next)

## El jugador elige una opción.
func select_choice(choice: DialogueChoice) -> void:
	if _current_node == null:
		return
	if not _is_choice_available(choice):
		return

	if not choice.sets_flag.is_empty():
		WorldState.set_flag(choice.sets_flag)

	choice_made.emit(choice)
	EventBus.dialogue_choice_made.emit(_current_node.choices.find(choice))

	if choice.skill_check != null:
		_resolve_skill_check(choice.skill_check)
	elif not choice.next_node_id.is_empty():
		_go_to_node(choice.next_node_id)
	else:
		close_dialogue()

## El jugador acepta la interrupción de un compañero para una tirada.
func accept_interrupt(character_data: CharacterData) -> void:
	_active_speaker = character_data

# ============================================================
# CONSULTAS
# ============================================================

func get_current_node() -> DialogueNode:
	return _current_node

func get_active_dialogue() -> DialogueData:
	return _active_dialogue

func is_choice_available(choice: DialogueChoice) -> bool:
	return _is_choice_available(choice)

## Devuelve los compañeros que pueden interrumpir para la tirada dada.
func get_interrupters(check: SkillCheckData) -> Array[CharacterData]:
	if _active_speaker == null or _party_data.is_empty():
		return []

	var leader_bonus := _ability_bonus(_active_speaker, check.ability)
	var result: Array[CharacterData] = []

	for member in _party_data:
		if member == _active_speaker:
			continue
		var bonus := _ability_bonus(member, check.ability)
		if bonus >= leader_bonus + INTERRUPT_THRESHOLD:
			result.append(member)

	return result

# ============================================================
# INTERNO — NAVEGACIÓN
# ============================================================

func _go_to_node(node_id: String) -> void:
	var node := _active_dialogue.get_node(node_id)
	if node == null:
		push_error("DialogueManager: nodo no encontrado: " + node_id)
		close_dialogue()
		return

	_current_node = node
	node_changed.emit(node)

	if not node.narrator_bark.is_empty():
		EventBus.narrator_bark.emit(node.narrator_bark, Constants.BARK_DURATION_DEFAULT)

	# Notificar interrupciones disponibles para los choices con tirada
	for choice in node.choices:
		if choice.skill_check != null:
			for interrupter in get_interrupters(choice.skill_check):
				var bonus := _ability_bonus(interrupter, choice.skill_check.ability)
				interrupt_available.emit(interrupter, bonus)

# ============================================================
# INTERNO — TIRADAS DE HABILIDAD
# ============================================================

func _resolve_skill_check(check: SkillCheckData) -> void:
	var speaker := _active_speaker
	if speaker == null and not _party_data.is_empty():
		speaker = _party_data[0]
	if speaker == null:
		_go_to_node(check.failure_node_id)
		return

	var bonus := _ability_bonus(speaker, check.ability)

	var skill_lower := check.skill_name.to_lower()

	# Desventaja: condición del check + condiciones del personaje + entorno
	var disadvantage := check.has_disadvantage \
		or WorldState.has_disadvantage_on_skill(skill_lower) \
		or _speaker_has_skill_disadvantage(speaker, skill_lower)

	# Ventaja: condición del check + entorno
	var advantage := check.has_advantage or WorldState.has_advantage_on_skill(skill_lower)

	var roll: int
	if disadvantage and not advantage:
		roll = mini(RngManager.randi_range(1, 20), RngManager.randi_range(1, 20))
	elif advantage and not disadvantage:
		roll = maxi(RngManager.randi_range(1, 20), RngManager.randi_range(1, 20))
	else:
		roll = RngManager.randi_range(1, 20)

	var total := roll + bonus
	var passed := total >= check.difficulty_class

	skill_check_resolved.emit(passed, roll, total, check.difficulty_class)
	EventBus.skill_check_resolved.emit(passed, roll, check.difficulty_class)

	# Resetear el speaker al líder para la siguiente tirada
	if not _party_data.is_empty():
		_active_speaker = _party_data[0]

	var next_id := check.success_node_id if passed else check.failure_node_id
	if next_id.is_empty():
		close_dialogue()
	else:
		_go_to_node(next_id)

# ============================================================
# INTERNO — UTILIDADES
# ============================================================

func _is_choice_available(choice: DialogueChoice) -> bool:
	if not choice.required_character_id.is_empty():
		var found := _party_data.any(
			func(d: CharacterData) -> bool: return d.character_id == choice.required_character_id
		)
		if not found:
			return false
	if not choice.required_flag.is_empty():
		if not WorldState.has_flag(choice.required_flag):
			return false
	return true

## Bonus de habilidad: mod de característica + bonificador de competencia.
func _ability_bonus(character: CharacterData, ability: String) -> int:
	var _ability_val = character.get(ability); if _ability_val == null: _ability_val = 10
	return CharacterData.ability_modifier(_ability_val) + character.proficiency_bonus

## Comprueba si el hablante tiene desventaja en una habilidad por sus condiciones persistentes.
func _speaker_has_skill_disadvantage(character: CharacterData, skill_name: String) -> bool:
	for cond_id in character.persistent_conditions:
		# Condiciones que dan desventaja en todos los checks
		if cond_id in ["resaca", "borracho", "envenenado", "exhausto_nado",
					   "cansancio_1", "cansancio_2", "cansancio_3", "cansancio_4", "cansancio_5"]:
			return true
		# Condiciones que dan desventaja en habilidades específicas
		var def := ConditionDefs.get_def(cond_id)
		var skills: Array = def.get("skill_disadvantage", [])
		if skill_name in skills:
			return true
	return false
