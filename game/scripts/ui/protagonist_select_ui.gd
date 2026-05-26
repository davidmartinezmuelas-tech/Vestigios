extends Control

## Personajes elegibles como protagonista en la Mision 1.
## Vael se une en la Mision de Ilvernis, no esta disponible desde el inicio.
const CHARACTERS: Array[Dictionary] = [
	{"id": "johannes", "name": "Johannes Varell", "class": "Bardo", "desc": "Semielfo sin saberlo. Creció en caravana gitana. Habilidad natural para estar donde no debe.", "path": "res://data/characters/heroes/johannes.tres"},
	{"id": "naeren",   "name": "Naeren",           "class": "Hechicera", "desc": "Tiefling que viaja con Lyth. Conexion con El Arquitecto que aun no comprende.", "path": "res://data/characters/heroes/naeren.tres"},
	{"id": "lyth",     "name": "Lyth",              "class": "Cazadora", "desc": "Harengon de la Iglesia de Cazadores. Busca a Garreth Ashveil. Viaja con Naeren.", "path": "res://data/characters/heroes/lyth.tres"},
	{"id": "mia",      "name": "Mia",               "class": "Monje", "desc": "Discipula de Sylvara Dusk. Siempre en el grupo. Habia quedado con Johannes en Karreth.", "path": "res://data/characters/npcs/mia.tres"},
]

func _ready() -> void:
	$VBox/CustomButton.pressed.connect(_on_custom)
	_build_characters()

func _build_characters() -> void:
	var grid := $VBox/CharactersGrid
	for entry in CHARACTERS:
		var btn := Button.new()
		btn.custom_minimum_size = Vector2(180, 110)
		btn.text = "%s\n%s" % [entry["name"], entry["class"]]
		btn.mouse_entered.connect(func(): _show_desc(entry))
		btn.mouse_exited.connect(func(): _clear_desc())
		btn.pressed.connect(func(): _pick(entry))
		grid.add_child(btn)

func _show_desc(entry: Dictionary) -> void:
	var lbl := $VBox/Description as Label
	if lbl:
		lbl.text = entry.get("desc", "")

func _clear_desc() -> void:
	var lbl := $VBox/Description as Label
	if lbl:
		lbl.text = ""

func _pick(entry: Dictionary) -> void:
	var data: CharacterData = load(entry["path"])
	if data == null:
		push_error("No se pudo cargar: " + entry["path"])
		return
	WorldState.set_protagonist(entry["id"])
	WorldState.add_to_roster(entry["id"])
	## Naeren y Lyth siempre se unen, salvo que una de ellas sea el protagonista
	for c in ["naeren", "lyth"]:
		if c != entry["id"]:
			WorldState.add_to_roster(c)
	SaveManager.autosave()
	GameManager.go_to_scene("res://scenes/taberna_karreth.tscn")

func _on_custom() -> void:
	GameManager.go_to_scene("res://scenes/ui/character_creation_scene.tscn")
