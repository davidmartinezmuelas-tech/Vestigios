## taberna_karreth.gd
## Orquesta la escena de la taberna del Ciervo Muerto en Karreth.
##
## FLUJO DE ESTADOS:
##   INTRO          → llegada + encuentro con Johannes y Mía
##   PRE_COMBAT     → tabernero nervioso revela la emboscada
##   COMBAT         → combate con 2 soldados sin armadura
##   POST_COMBAT    → ¿quedan enemigos vivos? → ofrece interrogatorio
##   INTERROGATION  → diálogo de interrogatorio (opcional)
##   PARTY_DECISION → selección de party (Johannes + Mía se unen, max 4 van al fuerte)
##   CART           → elección de camino (bosque o camino principal)
##   DONE           → transición según el flag de ruta elegida

extends Node2D

# ============================================================
# CONSTANTES
# ============================================================
const ENEMY_SPAWN_POSITIONS: Array[Vector2] = [
	Vector2(900, 480),
	Vector2(980, 500),
]
const HERO_SPAWN_POSITIONS: Array[Vector2] = [
	Vector2(300, 500),
	Vector2(380, 480),
	Vector2(340, 540),
	Vector2(420, 510),
]

# ============================================================
# NODOS
# ============================================================
@onready var combat_manager: CombatManager = $CombatManager
@onready var combat_ui: CanvasLayer        = $CombatUI
@onready var exploration_root: Node2D      = $ExplorationRoot
@onready var characters_layer: Node2D      = $ExplorationRoot/Characters

# ============================================================
# ESTADO
# ============================================================
enum State {
	INTRO, PRE_COMBAT, COMBAT,
	POST_COMBAT, INTERROGATION,
	PARTY_DECISION, CART, DONE
}
var _state: State = State.INTRO
var _enemies_alive: Array[BaseCharacter] = []
var _heroes: Array[BaseCharacter] = []
var _party_data_map: Dictionary = {}

var _johannes_data: CharacterData
var _mia_data: CharacterData
var _soldado_data: CharacterData

# ============================================================
# LIFECYCLE
# ============================================================

func _ready() -> void:
	_load_character_data()
	combat_manager.combat_ended.connect(_on_combat_ended)
	if combat_ui.has_method("setup"):
		combat_ui.setup(combat_manager)
	_enter_state(State.INTRO)

func _load_character_data() -> void:
	var paths := {
		"naeren":   "res://data/characters/heroes/naeren.tres",
		"lyth":     "res://data/characters/heroes/lyth.tres",
		"johannes": "res://data/characters/heroes/johannes.tres",
		"vael":     "res://data/characters/heroes/vael.tres",
		"bicho":    "res://data/characters/heroes/bicho.tres",
	}
	for id in WorldState.get_roster():
		if paths.has(id):
			_party_data_map[id] = load(paths[id])

	_johannes_data = load("res://data/characters/heroes/johannes.tres")
	_mia_data       = load("res://data/characters/npcs/mia.tres")
	_soldado_data   = load("res://data/characters/enemies/soldado_taberna.tres")

# ============================================================
# MÁQUINA DE ESTADOS
# ============================================================

func _enter_state(new_state: State) -> void:
	_state = new_state
	match _state:
		State.INTRO:          _state_intro()
		State.PRE_COMBAT:     _state_pre_combat()
		State.COMBAT:         _state_combat()
		State.POST_COMBAT:    _state_post_combat()
		State.INTERROGATION:  _state_interrogation()
		State.PARTY_DECISION: _state_party_decision()
		State.CART:           _state_cart()
		State.DONE:           _state_done()

# ── INTRO ─────────────────────────────────────────────────────

func _state_intro() -> void:
	_show_exploration(true)
	_spawn_exploration_characters()
	_open_dialogue(
		"res://data/dialogues/encuentro_taberna.tres",
		_johannes_data,
		_on_intro_closed
	)

func _on_intro_closed(_id: String) -> void:
	_enter_state(State.PRE_COMBAT)

# ── PRE_COMBAT ────────────────────────────────────────────────

func _state_pre_combat() -> void:
	_open_dialogue(
		"res://data/dialogues/tabernero_antes_combate.tres",
		_mia_data,  # placeholder — en producción sería CharacterData del tabernero
		_on_pre_combat_closed
	)

func _on_pre_combat_closed(_id: String) -> void:
	_enter_state(State.COMBAT)

# ── COMBAT ────────────────────────────────────────────────────

func _state_combat() -> void:
	_show_exploration(false)
	_setup_taberna_cover()
	_spawn_combat_characters()
	WorldState.enemy_knowledge.sight_enemy("soldado_taberna")

## Configura la cobertura de la taberna del Ciervo Muerto.
## Las mesas dan cobertura media, la barra da cobertura tres cuartos.
func _setup_taberna_cover() -> void:
	var grid := combat_manager.grid as CombatGrid
	if grid == null:
		return

	# Mesas de la taberna — cobertura media (+2 CA)
	# Posiciones aproximadas en el grid de 20×12 (escala 5ft/casilla)
	var mesa_cells: Array[Vector2i] = [
		Vector2i(3, 2), Vector2i(4, 2),  # mesa izquierda
		Vector2i(7, 2), Vector2i(8, 2),  # mesa centro
		Vector2i(11, 3), Vector2i(12, 3), # mesa derecha
	]
	for cell in mesa_cells:
		grid.set_cover(cell, CombatGrid.COVER_HALF, false)  # no solid — se puede saltar por encima

	# Barra del fondo — cobertura tres cuartos (+5 CA), sólida
	var barra_cells: Array[Vector2i] = [
		Vector2i(1, 6), Vector2i(2, 6), Vector2i(3, 6),
		Vector2i(4, 6), Vector2i(5, 6),
	]
	for cell in barra_cells:
		grid.set_cover(cell, CombatGrid.COVER_THREE_QUARTERS, true)

	# Trampa oculta — tablón suelto cerca de la salida (CD 14, 1d6 perforante)
	grid.set_trap(Vector2i(15, 8), 14, "1d6", "perforante")

	# Objetos del entorno interactuables
	grid.set_env_object(Vector2i(2, 8),
		"Barril de aceite",
		"Si se rompe, crea un charco inflamable 2×2 casillas.",
		"barrel_oil_explode")
	grid.set_env_object(Vector2i(9, 1),
		"Lámpara de aceite",
		"Si cae al suelo, prende fuego en su casilla (1d4 fuego/turno).",
		"lamp_fall_fire")

func _spawn_combat_characters() -> void:
	_heroes.clear()
	_enemies_alive.clear()

	var active := WorldState.get_active_party()
	for i in active.size():
		var data: CharacterData = _party_data_map.get(active[i])
		if data == null:
			continue
		LevelManager.sync_character_to_party_level(data)
		var hero := _spawn_character(data, HERO_SPAWN_POSITIONS[mini(i, HERO_SPAWN_POSITIONS.size() - 1)])
		_heroes.append(hero)

	for i in 2:
		var enemy := _spawn_character(_soldado_data, ENEMY_SPAWN_POSITIONS[i])
		_enemies_alive.append(enemy)

	combat_manager.start_combat(_heroes, _enemies_alive, false)
	if combat_ui.has_method("register_characters"):
		combat_ui.register_characters(_heroes, _enemies_alive)

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
	sprite.color = Color(0.3, 0.5, 0.9) if data.is_hero else Color(0.8, 0.2, 0.2)
	var lbl := Label.new()
	lbl.text = data.display_name.substr(0, 2)
	lbl.add_theme_font_size_override("font_size", 10)
	lbl.position = Vector2(2, 10)
	sprite.add_child(lbl)
	character.add_child(sprite)

	character.initialize(data)
	$Characters.add_child(character)
	return character

# ── POST_COMBAT ───────────────────────────────────────────────

func _on_combat_ended(victory: bool) -> void:
	if not victory:
		EventBus.narrator_bark.emit("La taberna ha sido vuestra tumba.", 4.0)
		return

	LevelManager.complete_hazana("taberna_superada")
	WorldState.set_flag("taberna_superada", true)

	var survivors := _enemies_alive.filter(
		func(e: BaseCharacter) -> bool: return e.stats.current_health > 0
	)
	_enter_state(State.POST_COMBAT if not survivors.is_empty() else State.PARTY_DECISION)

func _state_post_combat() -> void:
	_show_exploration(true)
	EventBus.narrator_bark.emit("Un soldado sigue con vida. ¿Lo interrogáis?", 4.0)
	var timer := get_tree().create_timer(2.5)
	timer.timeout.connect(func(): _enter_state(State.INTERROGATION))

func _state_interrogation() -> void:
	_open_dialogue(
		"res://data/dialogues/interrogatorio_taberna.tres",
		_soldado_data,
		_on_interrogation_closed
	)

func _on_interrogation_closed(_id: String) -> void:
	_enter_state(State.PARTY_DECISION)

# ── PARTY DECISION ────────────────────────────────────────────
## Johannes y Mía se unen al roster. El jugador elige quién de los
## disponibles va al fuerte (4 slots). Los demás se quedan en el Bastión.

func _state_party_decision() -> void:
	# Añadir Johannes y Mía al roster si no estaban ya
	if not WorldState.is_in_roster("johannes"):
		WorldState.add_to_roster("johannes")
		_party_data_map["johannes"] = _johannes_data
		LevelManager.sync_character_to_party_level(_johannes_data)

	if not WorldState.is_in_roster("mia"):
		WorldState.add_to_roster("mia")
		_party_data_map["mia"] = _mia_data
		LevelManager.sync_character_to_party_level(_mia_data)

	# Mostrar bark narrativo antes de la selección
	EventBus.narrator_bark.emit(
		"Johannes y Mía se unen al grupo. El fuerte espera — ¿quién va?", 3.0
	)

	var mission: MissionData = load("res://data/missions/mision_01_fuerte_piedra_gris.tres")
	if mission == null:
		_enter_state(State.CART)
		return

	var selection := preload("res://scenes/ui/party_selection_scene.tscn").instantiate()
	selection.setup(mission, _party_data_map)
	selection.party_confirmed.connect(_on_party_selected)
	add_child(selection)

func _on_party_selected(_ids: Array[String]) -> void:
	_enter_state(State.CART)

# ── CART ──────────────────────────────────────────────────────

func _state_cart() -> void:
	_open_dialogue(
		"res://data/dialogues/eleccion_camino_tutorial.tres",
		load("res://data/characters/npcs/cochero_karreth.tres"),
		_on_cart_closed
	)

func _on_cart_closed(_id: String) -> void:
	_enter_state(State.DONE)

# ── DONE ──────────────────────────────────────────────────────

func _state_done() -> void:
	SaveManager.autosave()
	if WorldState.has_flag("ruta_elegida_tutorial_bosque"):
		GameManager.go_to_scene("res://scenes/world/mission_01/bosque_tutorial.tscn")
	else:
		GameManager.go_to_scene("res://scenes/world/mission_01/camino_principal.tscn")

# ============================================================
# UTILIDADES
# ============================================================

func _show_exploration(show: bool) -> void:
	exploration_root.visible = show
	combat_ui.visible = not show

func _spawn_exploration_characters() -> void:
	var j_sprite := ColorRect.new()
	j_sprite.color = Color(0.85, 0.55, 0.2)
	j_sprite.size = Vector2(28, 44)
	j_sprite.position = Vector2(700, 460)
	var j_lbl := Label.new()
	j_lbl.text = "Jo"
	j_lbl.add_theme_font_size_override("font_size", 10)
	j_sprite.add_child(j_lbl)
	characters_layer.add_child(j_sprite)

	var m_sprite := ColorRect.new()
	m_sprite.color = Color(0.5, 0.3, 0.7)
	m_sprite.size = Vector2(28, 44)
	m_sprite.position = Vector2(760, 480)
	var m_lbl := Label.new()
	m_lbl.text = "Mí"
	m_lbl.add_theme_font_size_override("font_size", 10)
	m_sprite.add_child(m_lbl)
	characters_layer.add_child(m_sprite)

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
	if not party.any(func(d: CharacterData) -> bool: return d.character_id == "johannes"):
		if _johannes_data:
			party.append(_johannes_data)

	DialogueManager.open_dialogue(data, party)
	DialogueManager.dialogue_closed.connect(callback, CONNECT_ONE_SHOT)

	var dialogue_scene := preload("res://scenes/ui/dialogue/dialogue_scene.tscn").instantiate()
	add_child(dialogue_scene)
	if dialogue_scene.has_method("setup"):
		dialogue_scene.setup(party, npc_data)
