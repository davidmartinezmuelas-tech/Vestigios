## bastion_scene.gd
## Escena principal del Bastión. Instancia facilidades y compañeros dinámicamente,
## gestiona las interacciones y el flujo hacia misiones.

extends Node2D

# ============================================================
# POSICIONES EN EL MAPA (ajustar cuando llegue el arte isométrico)
## Coordenadas en píxeles desde el centro de la escena
# ============================================================
const ZONE_POSITIONS: Dictionary = {
	"mesa_mapas":      Vector2(0,    -100),
	"cofre_equipo":    Vector2(200,  -50),
	"facility_row_1":  Vector2(-250, 50),   # primera fila de facilidades
	"facility_row_2":  Vector2(-100, 100),
	"facility_row_3":  Vector2(50,   100),
	"facility_row_4":  Vector2(200,  100),
	"characters_area": Vector2(-200, 200),  # compañeros en descanso
	"mild_spot":       Vector2(300,  150),
	"player_start":    Vector2(0,    0),
}

const FACILITY_SLOT_POSITIONS: Array[Vector2] = [
	Vector2(-250, 50),
	Vector2(-100, 100),
	Vector2(50,   100),
	Vector2(200,  100),
	Vector2(-200, 180),
	Vector2(-50,  180),
]

const CHARACTER_POSITIONS: Array[Vector2] = [
	Vector2(-220, 220),
	Vector2(-160, 240),
	Vector2(-100, 220),
	Vector2(-40,  240),
	Vector2(20,   220),
]

# ============================================================
# NODOS
# ============================================================
@onready var interactables_layer: Node2D     = $InteractablesLayer
@onready var characters_layer: Node2D        = $CharactersLayer
@onready var player_node: BastionPlayer      = $Player
@onready var facility_panel: PanelContainer  = $BastionUI/FacilityPanel
@onready var gold_label: Label               = $BastionUI/TopBar/GoldLabel
@onready var level_label: Label              = $BastionUI/TopBar/LevelLabel
@onready var turn_btn: Button                = $BastionUI/TopBar/TurnButton
@onready var event_log: RichTextLabel        = $BastionUI/EventLog

# ============================================================
# ESTADO
# ============================================================
var _facility_panel_ui: Node = null

# ============================================================
# LIFECYCLE
# ============================================================

func _ready() -> void:
	_connect_signals()
	_build_fixed_interactables()
	_build_facility_interactables()
	_build_resting_characters()
	_spawn_mild_maybe()
	_update_hud()

	BastionManager.bastion_event_occurred.connect(_on_bastion_event)
	BastionManager.facility_order_completed.connect(_on_order_completed)

func _connect_signals() -> void:
	turn_btn.pressed.connect(_on_resolve_turn)

# ============================================================
# CONSTRUCCIÓN DE INTERACTUABLES
# ============================================================

func _build_fixed_interactables() -> void:
	# Mesa de Mapas — siempre presente
	var mesa := _spawn_interactable(
		"Mesa de Mapas",
		ZONE_POSITIONS["mesa_mapas"],
		Color(0.3, 0.5, 0.8)
	)
	mesa.interacted.connect(_on_mesa_mapas_interacted)

	# Cofre de Equipo — siempre presente
	var cofre := _spawn_interactable(
		"Cofre de Equipo",
		ZONE_POSITIONS["cofre_equipo"],
		Color(0.7, 0.6, 0.2)
	)
	cofre.interacted.connect(_on_cofre_interacted)

func _build_facility_interactables() -> void:
	var facilities := BastionManager.get_all_facilities()
	for i in facilities.size():
		if i >= FACILITY_SLOT_POSITIONS.size():
			break
		var instance := facilities[i]
		var pos := FACILITY_SLOT_POSITIONS[i]
		var color := Color(0.4, 0.7, 0.4) if instance.is_operational else Color(0.5, 0.3, 0.3)
		var obj := _spawn_interactable(instance.facility_data.display_name, pos, color)
		obj.interacted.connect(func(_o): _on_facility_interacted(instance))
		# Marcar con resultado pendiente
		if instance.has_result():
			_add_result_badge(obj)

func _build_resting_characters() -> void:
	var bench := WorldState.get_bench()
	for i in bench.size():
		if i >= CHARACTER_POSITIONS.size():
			break
		var character_id := bench[i]
		var pos := CHARACTER_POSITIONS[i]
		_spawn_character_sprite(character_id, pos)

func _spawn_mild_maybe() -> void:
	if RngManager.chance(0.4):  # 40% de que Mild esté hoy
		var mild_obj := _spawn_interactable("Mild", ZONE_POSITIONS["mild_spot"], Color(0.8, 0.4, 0.8))
		mild_obj.interacted.connect(_on_mild_interacted)

# ============================================================
# INTERACCIONES
# ============================================================

func _on_mesa_mapas_interacted(_obj: InteractableObject) -> void:
	# Cargar la primera misión disponible
	# TODO: mostrar lista de misiones disponibles en el mapa del mundo
	var mission: MissionData = load("res://data/missions/mision_01_fuerte_piedra_gris.tres")
	if mission == null:
		return

	# Construir el mapa de CharacterData para la selección
	var char_data_map := _build_character_data_map()

	# Instanciar la pantalla de selección de party
	var selection_scene := preload("res://scenes/ui/party_selection_scene.tscn").instantiate()
	selection_scene.setup(mission, char_data_map)
	selection_scene.party_confirmed.connect(_on_party_confirmed.bind(mission))
	add_child(selection_scene)

func _on_cofre_interacted(_obj: InteractableObject) -> void:
	# TODO: abrir pantalla de inventario/equipamiento
	EventBus.narrator_bark.emit("Inventario — próximamente.", 2.0)

func _on_facility_interacted(instance: BastionFacilityInstance) -> void:
	if _facility_panel_ui == null:
		_facility_panel_ui = facility_panel
	var panel := _facility_panel_ui as PanelContainer
	if panel.has_method("show_facility"):
		panel.show_facility(instance)

func _on_mild_interacted(_obj: InteractableObject) -> void:
	# TODO: abrir diálogo con Mild
	EventBus.narrator_bark.emit("Mild te mira fijamente. No dice nada. Luego se va.", 4.0)

func _on_party_confirmed(ids: Array[String], mission: MissionData) -> void:
	SaveManager.autosave()
	# Ir directamente a la escena de exploración de la misión
	GameManager.change_state(GameManager.GameState.EXPLORATION)
	GameManager.go_to_scene(mission.exploration_scene)

# ============================================================
# TURNO DE BASTIÓN
# ============================================================

func _on_resolve_turn() -> void:
	BastionManager.resolve_bastion_turn()
	_rebuild_facility_interactables()
	_update_hud()
	SaveManager.autosave()

func _on_bastion_event(event_id: String, details: Dictionary) -> void:
	var description := _event_description(event_id, details)
	event_log.append_text("\n• " + description)
	event_log.show()

func _on_order_completed(instance: BastionFacilityInstance, result: Dictionary) -> void:
	_add_result_badge(_find_interactable_for(instance))
	EventBus.narrator_bark.emit(
		"[%s] ha terminado: %s" % [instance.facility_data.display_name, result.get("option", "")],
		3.0
	)

# ============================================================
# HUD
# ============================================================

func _update_hud() -> void:
	gold_label.text = "⚙ %d PO" % WorldState.gold
	level_label.text = "Nivel %d  |  Bastión %d" % [
		LevelManager.get_level(), BastionManager.bastion_level
	]
	turn_btn.text = "Resolver turno de Bastión"

# ============================================================
# UTILIDADES
# ============================================================

func _spawn_interactable(label: String, pos: Vector2, color: Color) -> InteractableObject:
	var obj := InteractableObject.new()
	obj.display_name = label
	obj.position = pos

	# Sprite placeholder (ColorRect simulando isométrico)
	var placeholder := ColorRect.new()
	placeholder.name = "Sprite"
	placeholder.color = color
	placeholder.size = Vector2(64, 32)
	placeholder.position = Vector2(-32, -16)
	obj.add_child(placeholder)

	# Área de detección
	var area := Area2D.new()
	area.name = "DetectionArea"
	var shape_node := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = 80.0
	shape_node.shape = shape
	area.add_child(shape_node)
	obj.add_child(area)

	# Label indicador
	var indicator := Label.new()
	indicator.name = "Indicator"
	indicator.text = "!"
	indicator.position = Vector2(-5, -40)
	indicator.add_theme_font_size_override("font_size", 20)
	indicator.visible = false
	obj.add_child(indicator)

	# Nombre debajo
	var name_lbl := Label.new()
	name_lbl.text = label
	name_lbl.position = Vector2(-40, 18)
	name_lbl.add_theme_font_size_override("font_size", 10)
	obj.add_child(name_lbl)

	interactables_layer.add_child(obj)
	return obj

func _spawn_character_sprite(character_id: String, pos: Vector2) -> void:
	var sprite := ColorRect.new()
	sprite.color = Color(0.6, 0.6, 0.9)
	sprite.size = Vector2(32, 48)
	sprite.position = pos - Vector2(16, 48)

	var label := Label.new()
	label.text = character_id
	label.position = Vector2(-20, -16)
	label.add_theme_font_size_override("font_size", 9)
	sprite.add_child(label)

	characters_layer.add_child(sprite)

func _add_result_badge(obj: Node) -> void:
	if obj == null:
		return
	var badge := Label.new()
	badge.text = "★"
	badge.position = Vector2(20, -40)
	badge.add_theme_color_override("font_color", Color(1, 0.9, 0.2))
	badge.add_theme_font_size_override("font_size", 18)
	obj.add_child(badge)

func _rebuild_facility_interactables() -> void:
	for child in interactables_layer.get_children():
		if child.has_method("interacted"):
			child.queue_free()
	_build_fixed_interactables()
	_build_facility_interactables()

func _find_interactable_for(_instance: BastionFacilityInstance) -> Node:
	for child in interactables_layer.get_children():
		if child.display_name == _instance.facility_data.display_name:
			return child
	return null

func _build_character_data_map() -> Dictionary:
	# Devuelve un diccionario {character_id → CharacterData} para todos los personajes del roster
	# Por ahora carga los .tres directamente. En producción habría un catálogo centralizado.
	var map: Dictionary = {}
	var paths := {
		"vael":      "res://data/characters/heroes/vael.tres",
		"lyth":      "res://data/characters/heroes/lyth.tres",
		"bicho":     "res://data/characters/heroes/bicho.tres",
		"johannes":  "res://data/characters/heroes/johannes.tres",
		"naeren":    "res://data/characters/heroes/naeren.tres",
	}
	for id in WorldState.get_roster():
		if paths.has(id) and ResourceLoader.exists(paths[id]):
			map[id] = load(paths[id])
	return map

func _event_description(event_id: String, details: Dictionary) -> String:
	match event_id:
		"all_is_well":         return "Todo tranquilo en el Bastión."
		"attack":
			var lost: int = details.get("defenders_lost", 0)
			return "¡Ataque al Bastión! %d defensor/es caído/s." % lost
		"friendly_visitors":
			return "Visitantes amistosos ofrecen %d PO." % details.get("gold_offer", 0)
		"magical_discovery":   return "¡Los hirelings han creado una poción mágica!"
		"treasure":            return "El Bastión ha adquirido un tesoro."
		"refugees":
			return "%d refugiados piden cobijo." % details.get("refugee_count", 0)
		"guest":               return "Un huésped ha llegado al Bastión."
		"lost_hirelings":      return "Una facilidad ha perdido sus hirelings temporalmente."
		"criminal_hireling":   return "Problemas con un hireling — requiere atención."
		"request_for_aid":     return "Un líder local pide ayuda. ¿Envías defensores?"
		"extraordinary_opportunity": return "¡Oportunidad extraordinaria disponible!"
		_:                     return event_id
