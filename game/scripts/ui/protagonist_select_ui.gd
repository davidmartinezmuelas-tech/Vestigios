## protagonist_select_ui.gd
## Primera pantalla de nueva partida. El jugador elige quién será su protagonista:
## un personaje personalizado propio o uno de los personajes predefinidos del juego.
##
## El protagonista siempre va en las misiones y nunca puede quedarse en el Bastión.

extends Control

# ============================================================
# PERSONAJES PREDEFINIDOS ELEGIBLES COMO PROTAGONISTA
## El jugador puede jugar directamente como uno de ellos.
## Los que no sean elegidos estarán disponibles como compañeros en la historia.
# ============================================================
const PLAYABLE_CHARACTERS: Array[Dictionary] = [
	{
		"id":    "johannes",
		"name":  "Johannes Varell",
		"class": "Bardo / Pícaro",
		"desc":  "Humano con sangre drow oculta. Movido por lealtades complicadas y una habilidad natural para estar donde no debería.",
		"path":  "res://data/characters/heroes/johannes.tres",
	},
	{
		"id":    "naeren",
		"name":  "Naeren",
		"class": "Hechicera psíquica",
		"desc":  "Tiefling que perdió la voz. Lee pensamientos que no quiere leer. Carga con más de lo que muestra.",
		"path":  "res://data/characters/heroes/naeren.tres",
	},
	{
		"id":    "lyth",
		"name":  "Lyth",
		"class": "Cazadora de Sangre",
		"desc":  "Harengon que busca a Garreth Ashveil. Sus orejas delatan lo que su rostro esconde.",
		"path":  "res://data/characters/heroes/lyth.tres",
	},
	{
		"id":    "vael",
		"name":  "Vael",
		"class": "Paladín",
		"desc":  "Ex-soldado de Kethara que sirve ahora al Antiguo de la Vida. La cicatriz de su brazo detecta la Corrupción.",
		"path":  "res://data/characters/heroes/vael.tres",
	},
	{
		"id":    "mia",
		"name":  "Mía",
		"class": "Monje de las Sombras",
		"desc":  "Discípula de Sylvara Dusk. Su pasado con Kethara complica todo lo demás.",
		"path":  "res://data/characters/npcs/mia.tres",
	},
]

# ============================================================
# NODOS
# ============================================================
@onready var custom_btn: Button          = $VBox/CustomButton
@onready var characters_grid: HFlowContainer = $VBox/CharactersGrid
@onready var description_label: Label   = $VBox/Description

# ============================================================
# LIFECYCLE
# ============================================================

func _ready() -> void:
	description_label.text = ""
	custom_btn.pressed.connect(_on_custom_selected)
	_build_character_options()

func _build_character_options() -> void:
	for entry in PLAYABLE_CHARACTERS:
		var btn := _build_character_card(entry)
		characters_grid.add_child(btn)

func _build_character_card(entry: Dictionary) -> Button:
	var btn := Button.new()
	btn.custom_minimum_size = Vector2(160, 100)
	btn.text = "%s\n%s" % [entry["name"], entry["class"]]

	btn.mouse_entered.connect(func():
		description_label.text = entry["desc"]
	)
	btn.pressed.connect(func():
		_on_existing_character_selected(entry)
	)
	return btn

# ============================================================
# SELECCIÓN
# ============================================================

func _on_custom_selected() -> void:
	# El protagonista se asignará al terminar la creación de personaje
	GameManager.go_to_scene("res://scenes/ui/character_creation_scene.tscn")

func _on_existing_character_selected(entry: Dictionary) -> void:
	# Cargar los datos del personaje elegido
	var data: CharacterData = load(entry["path"])
	if data == null:
		return

	# El personaje elegido es el protagonista — añadir al roster con nivel sincronizado
	WorldState.set_protagonist(entry["id"])
	LevelManager.sync_character_to_party_level(data)

	# Los compañeros iniciales (Naeren y Lyth) siempre están disponibles desde el principio,
	# excepto si el jugador elige uno de ellos como protagonista
	var initial_companions := ["naeren", "lyth"]
	for companion_id in initial_companions:
		if companion_id != entry["id"]:
			WorldState.add_to_roster(companion_id)

	SaveManager.autosave()
	GameManager.go_to_scene("res://scenes/world/bastion_scene.tscn")
