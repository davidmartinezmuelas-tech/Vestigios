## fuerte_postmision.gd
## Secuencia post-victoria del fuerte de Piedra Gris.
##
## FLUJO:
##   LOOT       → el jugador puede saquear el fuerte (cofre de Vorn, armería)
##   LYRIS      → llegada del ejército aliado, Lyris da info
##   FIESTA     → celebración en el puerto (bebida, compañía, interacciones)
##   MAÑANA     → briefing de Lyris → Arcanis
##   DONE       → vuelta al Bastión / preparar Arcanis

extends Node2D

# ============================================================
# NODOS
# ============================================================
@onready var loot_panel: Control         = $LootPanel
@onready var scene_label: Label          = $SceneLabel
@onready var interactables: Node2D       = $Interactables
@onready var characters_layer: Node2D    = $Characters

# ============================================================
# ESTADO
# ============================================================
enum State { LOOT, LYRIS_ARRIVAL, PARTY, MORNING, DONE }
var _state: State = State.LOOT
var _party_data_map: Dictionary = {}
var _lyris_data: CharacterData
var _loot_taken: bool = false

const ALL_SKILLS: Array = [
	"atletismo", "acrobacias", "sigilo", "juego_de_manos",
	"arcanos", "historia", "investigacion", "naturaleza", "religion",
	"medicina", "perspicacia", "percepcion", "supervivencia", "trato_animales",
	"engano", "actuacion", "intimidacion", "persuasion",
]

# ============================================================
# LIFECYCLE
# ============================================================

func _ready() -> void:
	_load_character_data()
	_enter_state(State.LOOT)

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
	_lyris_data = load("res://data/characters/npcs/lyris.tres")

# ============================================================
# ESTADOS
# ============================================================

func _enter_state(new_state: State) -> void:
	_state = new_state
	match _state:
		State.LOOT:         _state_loot()
		State.LYRIS_ARRIVAL: _state_lyris_arrival()
		State.PARTY:        _state_party()
		State.MORNING:      _state_morning()
		State.DONE:         _state_done()

# ── SAQUEO ────────────────────────────────────────────────────

func _state_loot() -> void:
	scene_label.text = "Fuerte de Piedra Gris — Tras la batalla"
	_build_loot_interactables()
	EventBus.narrator_bark.emit(
		"El fuerte es vuestro. Hay tiempo antes de que llegue el ejército.",
		3.0
	)

func _build_loot_interactables() -> void:
	# Aposentos de Vorn
	var vorn_room := _make_loot_point(
		Vector2(500, 350), "Aposentos de Vorn",
		Color(0.4, 0.3, 0.5), _on_vorn_room_looted
	)
	interactables.add_child(vorn_room)

	# Armería
	var armory := _make_loot_point(
		Vector2(750, 400), "Armería del fuerte",
		Color(0.5, 0.4, 0.3), _on_armory_looted
	)
	interactables.add_child(armory)

	# Botón para continuar
	var continue_btn := Button.new()
	continue_btn.text = "Continuar →"
	continue_btn.position = Vector2(860, 520)
	continue_btn.pressed.connect(func(): _enter_state(State.LYRIS_ARRIVAL))
	add_child(continue_btn)

func _on_vorn_room_looted() -> void:
	if WorldState.has_flag("vorn_room_looted"):
		EventBus.narrator_bark.emit("Ya habéis registrado estos aposentos.", 2.0)
		return
	WorldState.set_flag("vorn_room_looted", true)
	# Carta misteriosa (sets up Meredan arc)
	WorldState.add_item({"id": "carta_meredan", "name": "Carta sin firma", "desc": "Sello de Meredan. Dirigida a 'C.R.'"})
	# Oro
	WorldState.add_gold(200)
	EventBus.narrator_bark.emit("200 PO y una carta con el sello de Meredan. C.R.", 4.0)

func _on_armory_looted() -> void:
	if WorldState.has_flag("armory_looted"):
		EventBus.narrator_bark.emit("La armería ya está vacía.", 2.0)
		return
	WorldState.set_flag("armory_looted", true)
	WorldState.add_item({"id": "armadura_fuerte", "name": "Armadura de guardia", "desc": "Cota de mallas estándar."})
	WorldState.add_gold(75)
	EventBus.narrator_bark.emit("75 PO y una cota de mallas en buen estado.", 3.0)

# ── LLEGADA DE LYRIS ──────────────────────────────────────────

func _state_lyris_arrival() -> void:
	scene_label.text = "El ejército aliado llega al fuerte"
	for child in interactables.get_children():
		child.queue_free()
	_open_dialogue("res://data/dialogues/lyris_llegada_fuerte.tres", _lyris_data,
		func(_id): _enter_state(State.PARTY)
	)

# ── FIESTA EN EL PUERTO ───────────────────────────────────────

func _state_party() -> void:
	scene_label.text = "Puerto del fuerte — Celebración"
	_open_dialogue("res://data/dialogues/fiesta_puerto.tres", _lyris_data,
		_on_party_dialogue_closed
	)

func _on_party_dialogue_closed(_id: String) -> void:
	# La resaca afecta SOLO al protagonista (el que bebió)
	if WorldState.has_flag("personaje_borracho"):
		var protagonist_id := WorldState.protagonist_id
		var protagonist_data: CharacterData = _party_data_map.get(protagonist_id)
		if protagonist_data and "resaca" not in protagonist_data.persistent_conditions:
			protagonist_data.persistent_conditions.append("resaca")
		EventBus.narrator_bark.emit(
			"La mañana llega con luz demasiado brillante y sonidos demasiado fuertes.",
			4.0
		)
	_enter_state(State.MORNING)

# ── MAÑANA — BRIEFING DE LYRIS ────────────────────────────────

func _state_morning() -> void:
	scene_label.text = "Puerto del fuerte — Amanecer"
	_open_dialogue("res://data/dialogues/lyris_briefing_arcanis.tres", _lyris_data,
		func(_id): _enter_state(State.DONE)
	)

# ── FIN DE MISIÓN ─────────────────────────────────────────────

func _state_done() -> void:
	# La resaca dura hasta el primer combate en Arcanis (se elimina entonces)
	WorldState.set_flag("mision_01_completada", true)
	LevelManager.complete_hazana("fuerte_conquistado")
	SaveManager.autosave()

	# Volver al Bastión para preparar el viaje a Arcanis
	BastionManager.resolve_bastion_turn()
	GameManager.go_to_scene("res://scenes/world/bastion_scene.tscn")

# ============================================================
# UTILIDADES
# ============================================================

func _make_loot_point(pos: Vector2, label: String, color: Color, callback: Callable) -> InteractableObject:
	var obj := InteractableObject.new()
	obj.display_name = label
	obj.position = pos
	obj.requires_proximity = false  # se puede clickar desde lejos

	var rect := ColorRect.new()
	rect.name = "Sprite"
	rect.color = color
	rect.size = Vector2(56, 40)
	rect.position = Vector2(-28, -40)
	obj.add_child(rect)

	var lbl := Label.new()
	lbl.text = label
	lbl.position = Vector2(-40, 4)
	lbl.add_theme_font_size_override("font_size", 9)
	obj.add_child(lbl)

	var indicator := Label.new()
	indicator.name = "Indicator"
	indicator.text = "!"
	indicator.position = Vector2(-5, -56)
	indicator.add_theme_font_size_override("font_size", 18)
	indicator.visible = true
	obj.add_child(indicator)

	var area := Area2D.new()
	area.name = "DetectionArea"
	var shape_node := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = 200.0
	shape_node.shape = shape
	area.add_child(shape_node)
	obj.add_child(area)

	obj.interacted.connect(func(_o): callback.call())
	return obj

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
