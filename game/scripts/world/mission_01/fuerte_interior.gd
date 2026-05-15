## fuerte_interior.gd
## El pueblo pesquero dentro del fuerte — la exploración principal de la misión.
##
## LAYOUT:
##   Entrada (sur) → calles del pueblo → plaza central → puerto (norte)
##   Casa de rehenes: al oeste, cerca del almacén
##   Barco de Vorn:   en el muelle norte
##
## SISTEMA DE ALERTA:
##   Normal: 4 guardias patrullando, radio detección 80px
##   Alerta:  6 guardias, radio 150px, se mueven activamente
##
## OBJECTIVOS:
##   1. Liberar rehenes (casa oeste)
##   2. Derrotar al General Vorn (barco norte)
##   → Hazaña: "fuerte_conquistado"

extends Node2D

# ============================================================
# POSICIONES DEL MAPA
# ============================================================
const GUARD_PATROLS: Array[Array] = [
	[Vector2(400, 400), Vector2(600, 400)],   # guardia 1: calle sur
	[Vector2(700, 350), Vector2(700, 500)],   # guardia 2: plaza
	[Vector2(900, 400), Vector2(1100, 400)],  # guardia 3: calle norte
	[Vector2(1000, 300), Vector2(1000, 450)], # guardia 4: cerca del muelle
	[Vector2(500, 300), Vector2(800, 300)],   # guardia 5 (solo en alerta)
	[Vector2(1100, 250), Vector2(1300, 250)], # guardia 6 (solo en alerta)
]
const HOUSE_POS:     Vector2 = Vector2(320, 380)
const VORN_SHIP_POS: Vector2 = Vector2(1100, 200)
const PLAYER_START:  Vector2 = Vector2(400, 540)   # entrada sur

# ============================================================
# NODOS
# ============================================================
@onready var player_node: BastionPlayer    = $Player
@onready var combat_manager: CombatManager = $CombatManager
@onready var combat_ui: CanvasLayer        = $CombatUI
@onready var exploration_root: Node2D      = $ExplorationRoot
@onready var guards_layer: Node2D          = $ExplorationRoot/Guards
@onready var alert_label: Label            = $AlertLabel

# ============================================================
# ESTADO
# ============================================================
enum State { EXPLORE, GUARD_COMBAT, HOSTAGE, VORN_DIALOGUE, VORN_COMBAT, VICTORY }
var _state: State = State.EXPLORE
var _is_alert: bool = false
var _guards: Array[FortGuard] = []
var _heroes: Array[BaseCharacter] = []
var _party_data_map: Dictionary = {}
var _vorn_data: CharacterData
var _guard_data: CharacterData
var _active_guard_combat: FortGuard = null

# ============================================================
# LIFECYCLE
# ============================================================

func _ready() -> void:
	_load_character_data()
	_is_alert = WorldState.has_flag("fuerte_alarma")
	_spawn_guards()
	_setup_interactables()
	_setup_combat_signals()
	_update_alert_ui()
	player_node.global_position = PLAYER_START
	WorldState.remove_party_condition("exhausto_nado")  # limpiar si venían nadando

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
	_vorn_data  = load("res://data/characters/enemies/general_vorn.tres")
	_guard_data = load("res://data/characters/enemies/guardia_fuerte.tres")

func _setup_combat_signals() -> void:
	combat_manager.combat_ended.connect(_on_combat_ended)
	if combat_ui.has_method("setup"):
		combat_ui.setup(combat_manager)
	combat_ui.visible = false

# ============================================================
# GUARDIAS
# ============================================================

func _spawn_guards() -> void:
	var count := 6 if _is_alert else 4
	for i in count:
		if i >= GUARD_PATROLS.size():
			break
		var guard := _create_guard(GUARD_PATROLS[i])
		guards_layer.add_child(guard)
		_guards.append(guard)
		guard.set_alert(_is_alert)
		guard.player_detected.connect(_on_guard_detected_player)

func _create_guard(patrol: Array) -> FortGuard:
	var guard := FortGuard.new()
	guard.character_data = _guard_data
	guard.patrol_points  = patrol
	guard.global_position = patrol[0]

	# Sprite placeholder
	var sprite := ColorRect.new()
	sprite.name = "Sprite"
	sprite.size = Vector2(24, 40)
	sprite.position = Vector2(-14, -44) if false else Vector2(-12, -40)
	sprite.color = Color(0.7, 0.2, 0.2)
	guard.add_child(sprite)

	# Área de detección
	var area := Area2D.new()
	area.name = "DetectionArea"
	var shape_node := CollisionShape2D.new()
	shape_node.name = "Shape"
	var shape := CircleShape2D.new()
	shape.radius = guard.detection_radius_normal
	shape_node.shape = shape
	area.add_child(shape_node)
	guard.add_child(area)

	var col := CollisionShape2D.new()
	var capsule := CapsuleShape2D.new()
	capsule.radius = 12.0
	capsule.height = 36.0
	col.shape = capsule
	guard.add_child(col)

	return guard

func _on_guard_detected_player(guard: FortGuard) -> void:
	if _state != State.EXPLORE:
		return
	_active_guard_combat = guard

	if not _is_alert:
		# Primera vez: dar oportunidad de esconderse
		_offer_hide_or_fight(guard)
	else:
		# En alerta: combate directo
		_start_guard_combat([guard])

func _offer_hide_or_fight(guard: FortGuard) -> void:
	# Tirada automática de Sigilo vs Percepción pasiva del guardia (10 + mod WIS)
	var best_stealth := _best_party_bonus("dex")
	var stealth_roll := RngManager.randi_range(1, 20) + best_stealth
	var passive_perception := 10 + CharacterData.ability_modifier(_guard_data.wisdom)

	if stealth_roll >= passive_perception:
		guard.mark_detected()
		EventBus.narrator_bark.emit(
			"El guardia os mira. No os ve. Os fundís con las sombras.",
			3.0
		)
	else:
		_trigger_alert_from_detection(guard)

func _trigger_alert_from_detection(guard: FortGuard) -> void:
	WorldState.set_flag("fuerte_alarma", true)
	_is_alert = true
	for g in _guards:
		g.set_alert(true)
	_spawn_alert_guards()
	_update_alert_ui()
	EventBus.narrator_bark.emit("¡Os han visto! El fuerte entra en alerta.", 4.0)
	_start_guard_combat([guard])

func _spawn_alert_guards() -> void:
	# Añadir guardias adicionales en alerta
	for i in range(4, GUARD_PATROLS.size()):
		if i >= _guards.size() + 4:
			var guard := _create_guard(GUARD_PATROLS[i])
			guards_layer.add_child(guard)
			_guards.append(guard)
			guard.set_alert(true)
			guard.player_detected.connect(_on_guard_detected_player)

func _start_guard_combat(hostile_guards: Array[FortGuard]) -> void:
	_state = State.GUARD_COMBAT
	_show_exploration(false)
	_heroes.clear()

	for id in WorldState.get_active_party():
		var data: CharacterData = _party_data_map.get(id)
		if data == null:
			continue
		LevelManager.sync_character_to_party_level(data)
		var hero := _spawn_combat_character(data, Vector2(300 + _heroes.size() * 80, 500))
		_heroes.append(hero)

	var enemies: Array[BaseCharacter] = []
	var count := mini(hostile_guards.size() + (1 if _is_alert else 0), 4)
	for i in count:
		var e := _spawn_combat_character(_guard_data, Vector2(900 + i * 90, 500))
		enemies.append(e)

	combat_manager.start_combat(_heroes, enemies, false)
	if combat_ui.has_method("register_characters"):
		combat_ui.register_characters(_heroes, enemies)

func _on_combat_ended(victory: bool) -> void:
	_show_exploration(true)
	if not victory:
		return

	LevelManager.award_combat_xp(_guard_data.xp_reward * _heroes.size())

	match _state:
		State.GUARD_COMBAT:
			_state = State.EXPLORE
			# Marcar guardia derrotado
			if _active_guard_combat:
				_active_guard_combat.queue_free()
				_guards.erase(_active_guard_combat)
				_active_guard_combat = null
		State.VORN_COMBAT:
			_victory()

# ============================================================
# INTERACTUABLES: CASA DE REHENES Y BARCO
# ============================================================

func _setup_interactables() -> void:
	# Casa de rehenes
	var house := _create_interactable(
		HOUSE_POS, "Casa de los rehenes", Color(0.6, 0.5, 0.3), _on_house_interacted
	)
	$ExplorationRoot/Interactables.add_child(house)

	# Barco de Vorn
	var ship := _create_interactable(
		VORN_SHIP_POS, "El barco de Vorn", Color(0.3, 0.4, 0.6), _on_ship_interacted
	)
	$ExplorationRoot/Interactables.add_child(ship)

	# Almacén norte (distracción) — solo si los rehenes lo mencionaron
	if WorldState.has_flag("rehenes_ofrecen_distraccion"):
		var warehouse := _create_interactable(
			Vector2(900, 320), "Almacén (aceite de pescado)", Color(0.8, 0.6, 0.2), _on_warehouse_interacted
		)
		$ExplorationRoot/Interactables.add_child(warehouse)

func _create_interactable(pos: Vector2, label: String, color: Color, callback: Callable) -> Node2D:
	var obj := InteractableObject.new()
	obj.display_name = label
	obj.position = pos

	var placeholder := ColorRect.new()
	placeholder.name = "Sprite"
	placeholder.color = color
	placeholder.size = Vector2(64, 48)
	placeholder.position = Vector2(-32, -48)
	obj.add_child(placeholder)

	var name_lbl := Label.new()
	name_lbl.text = label
	name_lbl.position = Vector2(-40, 4)
	name_lbl.add_theme_font_size_override("font_size", 9)
	obj.add_child(name_lbl)

	var indicator := Label.new()
	indicator.name = "Indicator"
	indicator.text = "!"
	indicator.position = Vector2(-5, -64)
	indicator.add_theme_font_size_override("font_size", 20)
	indicator.visible = false
	obj.add_child(indicator)

	var area := Area2D.new()
	area.name = "DetectionArea"
	var shape_node := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = 80.0
	shape_node.shape = shape
	area.add_child(shape_node)
	obj.add_child(area)

	obj.interacted.connect(func(_o): callback.call())
	return obj

func _on_house_interacted() -> void:
	if _state != State.EXPLORE:
		return
	if WorldState.has_flag("fuerte_rehenes_liberados"):
		EventBus.narrator_bark.emit("La casa está vacía. Los rehenes ya están a salvo.", 3.0)
		return
	_state = State.HOSTAGE
	var elder_data := load("res://data/characters/npcs/cochero_karreth.tres") as CharacterData
	_open_dialogue("res://data/dialogues/fuerte_rehenes.tres", elder_data, func(_id):
		_state = State.EXPLORE
	)

func _on_ship_interacted() -> void:
	if _state != State.EXPLORE:
		return
	if not WorldState.has_flag("fuerte_rehenes_liberados"):
		EventBus.narrator_bark.emit("Primero liberad a los rehenes.", 3.0)
		return
	_state = State.VORN_DIALOGUE
	_open_dialogue("res://data/dialogues/vorn_barco.tres", _vorn_data, _on_vorn_dialogue_closed)

func _on_vorn_dialogue_closed(_id: String) -> void:
	_state = State.VORN_COMBAT
	_show_exploration(false)
	_heroes.clear()

	for id in WorldState.get_active_party():
		var data: CharacterData = _party_data_map.get(id)
		if data == null:
			continue
		LevelManager.sync_character_to_party_level(data)
		var hero := _spawn_combat_character(data, Vector2(300 + _heroes.size() * 80, 500))
		_heroes.append(hero)

	var vorn := _spawn_combat_character(_vorn_data, Vector2(960, 480))
	WorldState.enemy_knowledge.sight_enemy("general_vorn")

	combat_manager.start_combat(_heroes, [vorn], false)
	if combat_ui.has_method("register_characters"):
		combat_ui.register_characters(_heroes, [vorn])

func _on_warehouse_interacted() -> void:
	if not WorldState.has_flag("rehenes_ofrecen_distraccion"):
		return
	WorldState.set_flag("fuerte_distraccion_usada", true)
	EventBus.narrator_bark.emit(
		"El aceite de pescado prende. Las llamas ascienden. En la plaza, voces. Los guardias corren al norte.",
		4.0
	)
	# Reducir guardias activos
	var to_remove := mini(2, _guards.size())
	for i in to_remove:
		if _guards.size() > 0:
			_guards[0].queue_free()
			_guards.remove_at(0)

# ============================================================
# VICTORIA
# ============================================================

func _victory() -> void:
	LevelManager.award_combat_xp(_vorn_data.xp_reward)
	WorldState.set_flag("fuerte_conquistado", true)
	WorldState.set_flag("fuerte_alarma", false)

	EventBus.narrator_bark.emit(
		"El General Vorn Ashkael ha caído. El Fuerte de Piedra Gris es libre.",
		5.0
	)
	var tween := create_tween()
	tween.tween_interval(3.5)
	tween.tween_callback(func():
		GameManager.go_to_scene("res://scenes/world/mission_01/fuerte_postmision.tscn")
	)

# ============================================================
# UTILIDADES
# ============================================================

func _show_exploration(show: bool) -> void:
	exploration_root.visible = show
	combat_ui.visible = not show

func _update_alert_ui() -> void:
	if alert_label == null:
		return
	if _is_alert:
		alert_label.text = "⚠ ALERTA — Los guardias os buscan"
		alert_label.modulate = Color(1, 0.3, 0.2)
		alert_label.visible = true
	else:
		alert_label.visible = false

func _best_party_bonus(ability: String) -> int:
	var best := -5
	for id in WorldState.get_active_party():
		var data: CharacterData = _party_data_map.get(id)
		if data:
			var val: int = data.get(ability, 10)
			var mod := CharacterData.ability_modifier(val) + data.proficiency_bonus
			best = maxi(best, mod)
	return best

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

func _spawn_combat_character(data: CharacterData, pos: Vector2) -> BaseCharacter:
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
