## bosque_tutorial.gd
## El bosque oscuro entre Karreth y el fuerte.
##
## MECÁNICAS:
##   • Al entrar: desventaja en Supervivencia y Naturaleza (bosque no natural)
##   • Exploración libre: aparece "el narizón" (criatura curiosa del bosque)
##   • Si se sigue al narizón: lleva al claro del ogro
##   • Claro: combate opcional con el ogro o diálogo (CD muy alta)
##   • Salida: se elimina el debuff, se ve el fuerte cerca
##
## HAZAÑAS:
##   • "bosque_explorado" — al llegar a la salida
##   • "ogro_derrotado"   — si matan al ogro

extends Node2D

# ============================================================
# POSICIONES
# ============================================================
const PLAYER_START: Vector2       = Vector2(200, 540)
const NARIZÓN_SPAWN: Vector2      = Vector2(600, 400)
const NARIZÓN_DEST: Vector2       = Vector2(900, 300)   # hacia el claro
const CLARO_CENTER: Vector2       = Vector2(1100, 350)
const OGRO_POS: Vector2           = Vector2(1150, 360)
const SALIDA_POS: Vector2         = Vector2(1600, 500)

# ============================================================
# NODOS
# ============================================================
@onready var player_node: BastionPlayer    = $Player
@onready var combat_manager: CombatManager = $CombatManager
@onready var combat_ui: CanvasLayer        = $CombatUI
@onready var exploration_root: Node2D      = $ExplorationRoot
@onready var characters_layer: Node2D      = $Characters
@onready var condition_bar: HBoxContainer  = $ConditionBar
@onready var narizón_sprite: Node2D        = $ExplorationRoot/Narizón
@onready var salida_trigger: Area2D        = $ExplorationRoot/SalidaTrigger

# ============================================================
# ESTADO
# ============================================================
enum State { EXPLORE, NARIZÓN_SCENE, OGRO_DIALOGUE, OGRO_COMBAT, EXITING, DONE }
var _state: State = State.EXPLORE
var _narizón_followed: bool = false
var _ogro_alive: bool = true
var _heroes: Array[BaseCharacter] = []
var _party_data_map: Dictionary = {}
var _ogro_data: CharacterData

# ============================================================
# LIFECYCLE
# ============================================================

func _ready() -> void:
	_load_character_data()
	_apply_forest_condition()
	_show_condition_icons()
	_setup_narizón()
	_setup_salida()
	_setup_combat_signals()

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
	_ogro_data = load("res://data/characters/enemies/ogro_bosque.tres")

func _setup_combat_signals() -> void:
	combat_manager.combat_ended.connect(_on_combat_ended)
	if combat_ui.has_method("setup"):
		combat_ui.setup(combat_manager)

# ============================================================
# CONDICIÓN DE BOSQUE OSCURO
# ============================================================

func _apply_forest_condition() -> void:
	WorldState.add_party_condition(
		"bosque_oscuro",
		"disadvantage",
		["supervivencia", "naturaleza"],
		"Bosque oscuro"
	)

func _remove_forest_condition() -> void:
	WorldState.remove_party_condition("bosque_oscuro")

func _show_condition_icons() -> void:
	for child in condition_bar.get_children():
		child.queue_free()

	for cond in WorldState.get_active_conditions():
		var icon := PanelContainer.new()
		var lbl := Label.new()
		var skills: Array = cond.get("affects_skills", [])
		lbl.text = "⬇ %s\n%s" % [cond.get("label", ""), " / ".join(skills)]
		lbl.add_theme_font_size_override("font_size", 10)
		lbl.add_theme_color_override("font_color", Color(0.9, 0.5, 0.2))
		icon.add_child(lbl)
		condition_bar.add_child(icon)

# ============================================================
# EL NARIZÓN
# ============================================================

func _setup_narizón() -> void:
	if narizón_sprite == null:
		return
	narizón_sprite.position = NARIZÓN_SPAWN

	# Hacer clickable al narizón
	var btn := Button.new()
	btn.flat = true
	btn.custom_minimum_size = Vector2(40, 40)
	btn.position = Vector2(-20, -20)
	btn.pressed.connect(_on_narizón_clicked)
	btn.tooltip_text = "Una criatura pequeña os observa."
	narizón_sprite.add_child(btn)

	# Mover al narizón de forma autónoma (se pasea por el claro)
	_animate_narizón()

func _animate_narizón() -> void:
	if narizón_sprite == null:
		return
	var tween := create_tween().set_loops()
	tween.tween_property(narizón_sprite, "position",
		NARIZÓN_SPAWN + Vector2(60, -30), 3.0).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(narizón_sprite, "position",
		NARIZÓN_SPAWN, 3.0).set_ease(Tween.EASE_IN_OUT)

func _on_narizón_clicked() -> void:
	if _state != State.EXPLORE:
		return
	_state = State.NARIZÓN_SCENE
	_narizón_followed = true

	EventBus.narrator_bark.emit(
		"La criatura os mira y echa a correr entre los árboles. Como si quisiera que la siguierais.",
		4.0
	)
	# El narizón corre hacia el claro
	var tween := create_tween()
	tween.tween_property(narizón_sprite, "position", CLARO_CENTER, 2.0)
	tween.tween_callback(_on_llegada_al_claro)

func _on_llegada_al_claro() -> void:
	EventBus.narrator_bark.emit(
		"Un claro. En el centro, un árbol enorme cuyas raíces forman una cámara natural. Dentro brilla algo. Y frente a la entrada...",
		5.0
	)
	# Mostrar ogro
	var tween := create_tween()
	tween.tween_interval(2.0)
	tween.tween_callback(_enter_ogro_encounter)

func _enter_ogro_encounter() -> void:
	_state = State.OGRO_DIALOGUE
	var ogro_npc_sprite := _create_placeholder_sprite(_ogro_data, OGRO_POS, Color(0.6, 0.4, 0.2))
	characters_layer.add_child(ogro_npc_sprite)
	_open_ogro_dialogue()

func _open_ogro_dialogue() -> void:
	var data: DialogueData = load("res://data/dialogues/ogro_encuentro.tres")
	if data == null:
		return

	var party: Array[CharacterData] = []
	for id in WorldState.get_active_party():
		var d: CharacterData = _party_data_map.get(id)
		if d:
			party.append(d)

	DialogueManager.open_dialogue(data, party)
	DialogueManager.dialogue_closed.connect(_on_ogro_dialogue_closed, CONNECT_ONE_SHOT)

	var scene := preload("res://scenes/ui/dialogue/dialogue_scene.tscn").instantiate()
	add_child(scene)
	if scene.has_method("setup"):
		scene.setup(party, _ogro_data)

func _on_ogro_dialogue_closed(_id: String) -> void:
	# Comprobar qué decidió el jugador según los flags
	if WorldState.has_flag("ogro_resultado_combate") or \
	   (not WorldState.has_flag("ogro_resultado_huida") and not WorldState.has_flag("ogro_resultado_trato")):
		# Si el nodo final fue "combate_ogro" → iniciar combate
		_start_ogro_combat()
	else:
		_on_ogro_encounter_resolved()

# ── Combate con el ogro ──────────────────────────────────────

func _start_ogro_combat() -> void:
	_state = State.OGRO_COMBAT
	_show_exploration(false)
	_heroes.clear()

	for id in WorldState.get_active_party():
		var data: CharacterData = _party_data_map.get(id)
		if data == null:
			continue
		LevelManager.sync_character_to_party_level(data)
		var hero := _spawn_character(data, Vector2(400 + _heroes.size() * 80, 500))
		_heroes.append(hero)

	var ogro := _spawn_character(_ogro_data, OGRO_POS)
	WorldState.enemy_knowledge.sight_enemy("ogro_bosque")

	combat_manager.start_combat(_heroes, [ogro], false)
	if combat_ui.has_method("register_characters"):
		combat_ui.register_characters(_heroes, [ogro])

func _on_combat_ended(victory: bool) -> void:
	_show_exploration(true)
	if victory:
		_ogro_alive = false
		LevelManager.award_combat_xp(_ogro_data.xp_reward)
		LevelManager.complete_hazana("ogro_derrotado")
		WorldState.set_flag("ogro_derrotado", true)
		EventBus.narrator_bark.emit("El ogro cae. El tesoro es vuestro.", 3.0)
	_on_ogro_encounter_resolved()

func _on_ogro_encounter_resolved() -> void:
	EventBus.narrator_bark.emit(
		"Seguís moviéndoos entre los árboles. El bosque empieza a aclararse.",
		3.0
	)
	var tween := create_tween()
	tween.tween_interval(3.0)
	tween.tween_callback(_enter_exit)

# ============================================================
# SALIDA DEL BOSQUE
# ============================================================

func _setup_salida() -> void:
	if salida_trigger:
		salida_trigger.body_entered.connect(_on_player_reaches_exit)

func _on_player_reaches_exit(body: Node2D) -> void:
	if body.is_in_group("player") and _state != State.EXITING:
		_enter_exit()

func _enter_exit() -> void:
	if _state == State.EXITING or _state == State.DONE:
		return
	_state = State.EXITING
	_remove_forest_condition()
	LevelManager.complete_hazana("bosque_explorado")
	WorldState.set_flag("bosque_explorado", true)

	EventBus.narrator_bark.emit(
		"Los árboles se separan. A menos de media legua, recortado contra el cielo gris, está el Fuerte de Piedra Gris.",
		5.0
	)
	var tween := create_tween()
	tween.tween_interval(4.0)
	tween.tween_callback(_go_to_fort)

func _go_to_fort() -> void:
	_state = State.DONE
	SaveManager.autosave()
	GameManager.go_to_scene("res://scenes/world/mission_01/fuerte_exterior.tscn")

# ============================================================
# UTILIDADES
# ============================================================

func _show_exploration(show: bool) -> void:
	exploration_root.visible = show
	combat_ui.visible = not show

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
	sprite.color = Color(0.3, 0.5, 0.9) if data.is_hero else Color(0.7, 0.35, 0.15)
	var lbl := Label.new()
	lbl.text = data.display_name.substr(0, 2)
	lbl.add_theme_font_size_override("font_size", 10)
	lbl.position = Vector2(2, 10)
	sprite.add_child(lbl)
	character.add_child(sprite)
	character.initialize(data)
	$Characters.add_child(character)
	return character

func _create_placeholder_sprite(data: CharacterData, pos: Vector2, color: Color) -> Node2D:
	var node := Node2D.new()
	node.position = pos
	var rect := ColorRect.new()
	rect.size = Vector2(40, 60)
	rect.position = Vector2(-20, -60)
	rect.color = color
	var lbl := Label.new()
	lbl.text = data.display_name.substr(0, 3)
	lbl.add_theme_font_size_override("font_size", 10)
	lbl.position = Vector2(-10, -30)
	node.add_child(rect)
	node.add_child(lbl)
	return node
