## camino_principal.gd
## El camino principal al fuerte — sin exploración libre.
## Dos encuentros con soldados de Kethara: tiradas de habilidad o combate.
##
## FLUJO:
##   ENCOUNTER_1 → diálogo con tiradas → éxito (paso libre) o fallo (combate)
##   ENCOUNTER_2 → idem, CDs más altas (soldados alertados)
##   ARRIVE      → llegan al fuerte al anochecer

extends Node2D

# ============================================================
# NODOS
# ============================================================
@onready var combat_manager: CombatManager = $CombatManager
@onready var combat_ui: CanvasLayer        = $CombatUI
@onready var bg_rect: ColorRect            = $Background
@onready var road_label: Label             = $RoadLabel
@onready var condition_bar: HBoxContainer  = $ConditionBar

# ============================================================
# ESTADO
# ============================================================
enum State { ENCOUNTER_1, COMBAT_1, ENCOUNTER_2, COMBAT_2, ARRIVE, DONE }
var _state: State = State.ENCOUNTER_1
var _heroes: Array[BaseCharacter] = []
var _party_data_map: Dictionary = {}

const ENCOUNTER_ENEMY_COUNTS := {State.COMBAT_1: 3, State.COMBAT_2: 4}

# ============================================================
# LIFECYCLE
# ============================================================

func _ready() -> void:
	_load_character_data()
	combat_manager.combat_ended.connect(_on_combat_ended)
	if combat_ui.has_method("setup"):
		combat_ui.setup(combat_manager)
	combat_ui.visible = false
	_enter_state(State.ENCOUNTER_1)

func _load_character_data() -> void:
	var paths := {
		"naeren":   "res://data/characters/heroes/naeren.tres",
		"lyth":     "res://data/characters/heroes/lyth.tres",
		"johannes": "res://data/characters/heroes/johannes.tres",
		"vael":     "res://data/characters/heroes/vael.tres",
		"bicho":    "res://data/characters/heroes/bicho.tres",
		"mia":      "res://data/characters/npcs/mia.tres",
	}
	for id in WorldState.get_active_party():
		if paths.has(id):
			_party_data_map[id] = load(paths[id])

# ============================================================
# MÁQUINA DE ESTADOS
# ============================================================

func _enter_state(new_state: State) -> void:
	_state = new_state
	match _state:
		State.ENCOUNTER_1: _state_encounter("res://data/dialogues/camino_encuentro_1.tres", "soldado_taberna")
		State.COMBAT_1:    _state_combat(3, "soldado_taberna")
		State.ENCOUNTER_2: _state_encounter("res://data/dialogues/camino_encuentro_2.tres", "guardia_fuerte")
		State.COMBAT_2:    _state_combat(4, "guardia_fuerte")
		State.ARRIVE:      _state_arrive()
		State.DONE:        _state_done()

# ── ENCUENTROS (diálogo con elecciones) ──────────────────────

func _state_encounter(dialogue_path: String, npc_id: String) -> void:
	combat_ui.visible = false

	var enemy_data: CharacterData = load("res://data/characters/enemies/%s.tres" % npc_id)
	var dialogue_data: DialogueData = load(dialogue_path)
	if dialogue_data == null:
		_advance_after_encounter()
		return

	var party: Array[CharacterData] = []
	for id in WorldState.get_active_party():
		var d: CharacterData = _party_data_map.get(id)
		if d:
			party.append(d)

	DialogueManager.open_dialogue(dialogue_data, party)
	DialogueManager.dialogue_closed.connect(_on_encounter_dialogue_closed, CONNECT_ONE_SHOT)

	var scene := preload("res://scenes/ui/dialogue/dialogue_scene.tscn").instantiate()
	add_child(scene)
	if scene.has_method("setup"):
		scene.setup(party, enemy_data)

func _on_encounter_dialogue_closed(dialogue_id: String) -> void:
	# Si el último nodo fue "combate_X" → luchar
	if dialogue_id == "camino_encuentro_1":
		if WorldState.has_flag("camino_combate_1"):
			_enter_state(State.COMBAT_1)
		else:
			_advance_after_encounter()
	elif dialogue_id == "camino_encuentro_2":
		if WorldState.has_flag("camino_combate_2"):
			_enter_state(State.COMBAT_2)
		else:
			_enter_state(State.ARRIVE)

func _advance_after_encounter() -> void:
	# Primer encuentro superado sin combate → segundo encuentro
	if _state == State.ENCOUNTER_1:
		var tween := create_tween()
		tween.tween_interval(1.5)
		tween.tween_callback(func(): _enter_state(State.ENCOUNTER_2))
	else:
		_enter_state(State.ARRIVE)

# ── COMBATE ──────────────────────────────────────────────────

func _state_combat(enemy_count: int, enemy_id: String) -> void:
	combat_ui.visible = true
	_heroes.clear()

	var enemy_data: CharacterData = load("res://data/characters/enemies/%s.tres" % enemy_id)
	WorldState.enemy_knowledge.sight_enemy(enemy_id)

	for id in WorldState.get_active_party():
		var data: CharacterData = _party_data_map.get(id)
		if data == null:
			continue
		LevelManager.sync_character_to_party_level(data)
		var hero := _spawn_character(data, Vector2(250 + _heroes.size() * 80, 500))
		_heroes.append(hero)

	var enemies: Array[BaseCharacter] = []
	for i in enemy_count:
		var enemy := _spawn_character(enemy_data, Vector2(900 + i * 80, 500))
		enemies.append(enemy)

	combat_manager.start_combat(_heroes, enemies, false)
	if combat_ui.has_method("register_characters"):
		combat_ui.register_characters(_heroes, enemies)

func _on_combat_ended(victory: bool) -> void:
	combat_ui.visible = false

	if not victory:
		EventBus.narrator_bark.emit("El camino se ha cobrado un precio demasiado alto.", 4.0)
		return

	LevelManager.award_combat_xp(
		(load("res://data/characters/enemies/soldado_taberna.tres") as CharacterData).xp_reward * 3
	)

	if _state == State.COMBAT_1:
		var tween := create_tween()
		tween.tween_interval(1.5)
		tween.tween_callback(func(): _enter_state(State.ENCOUNTER_2))
	else:
		_enter_state(State.ARRIVE)

# ── LLEGADA ──────────────────────────────────────────────────

func _state_arrive() -> void:
	LevelManager.complete_hazana("bosque_explorado")  # misma hazaña — llegaste al fuerte
	WorldState.set_flag("camino_llegada_fuerte", true)

	EventBus.narrator_bark.emit(
		"El camino termina en una explanada. Al fondo, las murallas del Fuerte de Piedra Gris. Lleváis el tiempo justo.",
		5.0
	)
	var tween := create_tween()
	tween.tween_interval(4.0)
	tween.tween_callback(func(): _enter_state(State.DONE))

func _state_done() -> void:
	SaveManager.autosave()
	GameManager.go_to_scene("res://scenes/world/mission_01/fuerte_exterior.tscn")

# ============================================================
# UTILIDADES
# ============================================================

func _spawn_character(data: CharacterData, pos: Vector2) -> BaseCharacter:
	var character := BaseCharacter.new()
	character.data = data
	character.position = pos

	var stats_node := CharacterStats.new()
	stats_node.name = "CharacterStats"
	character.add_child(stats_node)

	var effect_mgr := EffectManager.new()
	effect_mgr.name = "EffectManager"
	character.add_child(effect_mgr)

	var sprite := ColorRect.new()
	sprite.size = Vector2(28, 44)
	sprite.position = Vector2(-14, -44)
	sprite.color = Color(0.3, 0.5, 0.9) if data.is_hero else Color(0.7, 0.2, 0.2)
	var lbl := Label.new()
	lbl.text = data.display_name.substr(0, 2)
	lbl.add_theme_font_size_override("font_size", 10)
	lbl.position = Vector2(2, 10)
	sprite.add_child(lbl)
	character.add_child(sprite)
	character.initialize(data)
	$Characters.add_child(character)
	return character
