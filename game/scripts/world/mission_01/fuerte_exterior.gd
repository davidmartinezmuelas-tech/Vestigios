## fuerte_exterior.gd
## Vista exterior del fuerte. El jugador elige cómo entrar.
##
## OPCIONES:
##   CARRO — diálogo con guardias de la puerta (engaño/persuasión)
##   MAR   — tiradas de Atletismo + Sigilo para nadar sin ser vistos
##
## RESULTADO:
##   Entrada limpia  → fuerte_interior sin alarma
##   Alarma activada → fuerte_interior con flag fuerte_alarma = true
##   Combate en puerta → mismo, pero con combate extra

extends Node2D

# ============================================================
# NODOS
# ============================================================
@onready var combat_manager: CombatManager = $CombatManager
@onready var combat_ui: CanvasLayer        = $CombatUI
@onready var entry_panel: Control          = $EntryPanel
@onready var carro_btn: Button             = $EntryPanel/CarroButton
@onready var mar_btn: Button               = $EntryPanel/MarButton

# ============================================================
# ESTADO
# ============================================================
enum State { CHOOSE, ENTRY_CARRO, COMBAT_DOOR, ENTRY_MAR, DONE }
var _state: State = State.CHOOSE
var _heroes: Array[BaseCharacter] = []
var _party_data_map: Dictionary = {}

# ============================================================
# LIFECYCLE
# ============================================================

func _ready() -> void:
	_load_character_data()
	carro_btn.pressed.connect(_on_carro_selected)
	mar_btn.pressed.connect(_on_mar_selected)
	combat_manager.combat_ended.connect(_on_combat_ended)
	if combat_ui.has_method("setup"):
		combat_ui.setup(combat_manager)
	combat_ui.visible = false

func _load_character_data() -> void:
	var paths := {
		"naeren": "res://data/characters/heroes/naeren.tres",
		"lyth":   "res://data/characters/heroes/lyth.tres",
		"johannes": "res://data/characters/heroes/johannes.tres",
		"vael":   "res://data/characters/heroes/vael.tres",
		"bicho":  "res://data/characters/heroes/bicho.tres",
		"mia":    "res://data/characters/npcs/mia.tres",
	}
	for id in WorldState.get_active_party():
		if paths.has(id):
			_party_data_map[id] = load(paths[id])

# ============================================================
# OPCIONES DE ENTRADA
# ============================================================

func _on_carro_selected() -> void:
	entry_panel.hide()
	_state = State.ENTRY_CARRO
	var guard_data: CharacterData = load("res://data/characters/enemies/guardia_fuerte.tres")
	_open_dialogue("res://data/dialogues/fuerte_entrada_carro.tres", guard_data, _on_carro_dialogue_closed)

func _on_carro_dialogue_closed(dialogue_id: String) -> void:
	if WorldState.has_flag("fuerte_alarma"):
		# Combate en la puerta con los 2 guardias
		_start_door_combat()
	else:
		_enter_fort()

func _start_door_combat() -> void:
	_state = State.COMBAT_DOOR
	combat_ui.visible = true
	_heroes.clear()

	var guard_data: CharacterData = load("res://data/characters/enemies/guardia_fuerte.tres")
	for id in WorldState.get_active_party():
		var data: CharacterData = _party_data_map.get(id)
		if data == null:
			continue
		LevelManager.sync_character_to_party_level(data)
		var hero := _spawn_character(data, Vector2(300 + _heroes.size() * 80, 500))
		_heroes.append(hero)

	var guards: Array[BaseCharacter] = []
	for i in 2:
		var g := _spawn_character(guard_data, Vector2(900 + i * 90, 500))
		guards.append(g)

	combat_manager.start_combat(_heroes, guards, false)
	if combat_ui.has_method("register_characters"):
		combat_ui.register_characters(_heroes, guards)

func _on_combat_ended(victory: bool) -> void:
	if victory:
		_enter_fort()

# ── Entrada por el mar ────────────────────────────────────────

func _on_mar_selected() -> void:
	entry_panel.hide()
	_state = State.ENTRY_MAR
	_resolve_sea_entry()

func _resolve_sea_entry() -> void:
	# Atletismo CD 10 para nadar (fácil)
	# Sigilo CD 14 para no ser visto desde las torretas
	var party := WorldState.get_active_party()
	var best_str := 8
	var best_dex := 8
	for id in party:
		var data: CharacterData = _party_data_map.get(id)
		if data == null:
			continue
		best_str = maxi(best_str, data.strength)
		best_dex = maxi(best_dex, data.dexterity)

	var swim_bonus  := CharacterData.ability_modifier(best_str) + 2  # proficiency
	var stealth_bonus := CharacterData.ability_modifier(best_dex) + 2

	var swim_roll    := RngManager.randi_range(1, 20) + swim_bonus
	var stealth_roll := RngManager.randi_range(1, 20) + stealth_bonus

	if swim_roll < 10:
		EventBus.narrator_bark.emit(
			"La corriente os trabaja. Alguien llega exhausto a la orilla. Desventaja en el primer combate.",
			4.0
		)
		WorldState.add_party_condition("exhausto_nado", "disadvantage", ["atletismo"], "Exhausto")

	if stealth_roll < 14:
		WorldState.set_flag("fuerte_alarma", true)
		EventBus.narrator_bark.emit(
			"Una linterna desde la torreta os barre. ¡Os han visto!",
			4.0
		)
	else:
		EventBus.narrator_bark.emit(
			"Llegáis a la orilla sin ser vistos. El fuerte duerme.",
			3.0
		)

	var tween := create_tween()
	tween.tween_interval(3.0)
	tween.tween_callback(_enter_fort)

# ============================================================
# TRANSICIÓN AL INTERIOR
# ============================================================

func _enter_fort() -> void:
	_state = State.DONE
	SaveManager.autosave()
	GameManager.go_to_scene("res://scenes/world/mission_01/fuerte_interior.tscn")

# ============================================================
# UTILIDADES
# ============================================================

func _open_dialogue(path: String, npc_data: CharacterData, callback: Callable) -> void:
	var data: DialogueData = load(path)
	if data == null:
		callback.call("")
		return
	var party: Array[CharacterData] = []
	for id in WorldState.get_active_party():
		var d: CharacterData = _party_data_map.get(id)
		if d:
			party.append(d)
	DialogueManager.open_dialogue(data, party)
	DialogueManager.dialogue_closed.connect(callback, CONNECT_ONE_SHOT)
	var scene := preload("res://scenes/ui/dialogue/dialogue_scene.tscn").instantiate()
	add_child(scene)
	if scene.has_method("setup"):
		scene.setup(party, npc_data)

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
	character.add_child(sprite)
	character.initialize(data)
	$Characters.add_child(character)
	return character
