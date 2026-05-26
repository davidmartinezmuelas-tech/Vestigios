## character_animator.gd
## Componente de animacion para personajes con 8 direcciones.
## Carga frames de PNG individuales y genera un SpriteFrames en tiempo de ejecucion.
## Adjuntar a un nodo que tenga un hijo AnimatedSprite2D llamado "AnimatedSprite2D".
##
## Uso:
##   update_direction(velocity)  -- llama en _physics_process con el vector de movimiento
##   play_idle()                 -- llama cuando el personaje para

extends Node

const FPS_WALK := 10
const FPS_IDLE := 6

## Ruta base de los assets del personaje. Debe contener:
##   walk/{direction}/frame_000.png ... frame_007.png
##   idle/{direction}/frame_000.png ... (cuando existan)
##   {direction}.png                    (pose estatica de fallback)
@export var assets_base_path: String = ""
@export var frame_count_walk: int = 8
@export var frame_count_idle: int = 8

var _sprite: AnimatedSprite2D
var _frames: SpriteFrames
var _current_anim: String = ""

## Mapa de nombre de direccion a nombre de animacion
const DIR_NAMES: Array[String] = [
	"south", "south-east", "east", "north-east",
	"north", "north-west", "west", "south-west"
]

func _ready() -> void:
	## Esperar un frame por si AnimatedSprite2D se anade en el mismo _ready() del padre
	await get_tree().process_frame
	_sprite = get_parent().get_node_or_null("AnimatedSprite2D")
	if _sprite == null:
		push_error("CharacterAnimator: no se encontro AnimatedSprite2D en " + str(get_parent().name))
		return
	_build_sprite_frames()
	play_idle()

## Construye el SpriteFrames cargando los PNG individuales.
func _build_sprite_frames() -> void:
	_frames = SpriteFrames.new()
	_frames.remove_animation("default")

	for dir in DIR_NAMES:
		_add_animation("walk_" + dir, "walk/" + dir, frame_count_walk, FPS_WALK)
		_add_animation("idle_" + dir, "idle/" + dir, frame_count_idle, FPS_IDLE)

	_sprite.sprite_frames = _frames
	_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

## Carga frames individuales y crea una animacion en _frames.
## Si la carpeta no existe, intenta usar la pose estatica como fallback (1 frame).
func _add_animation(anim_name: String, subfolder: String, count: int, fps: int) -> void:
	_frames.add_animation(anim_name)
	_frames.set_animation_speed(anim_name, fps)
	_frames.set_animation_loop(anim_name, true)

	var loaded := 0
	for i in count:
		var path: String = assets_base_path + "/" + subfolder + "/frame_%03d.png" % i
		if ResourceLoader.exists(path):
			var tex: Texture2D = load(path)
			_frames.add_frame(anim_name, tex)
			loaded += 1

	# Fallback: pose estatica si no hay frames
	if loaded == 0:
		# Intentar pose estatica segun la direccion del nombre de animacion
		var dir_part: String = anim_name.split("_", false, 1)[1] if "_" in anim_name else anim_name
		var static_path: String = assets_base_path + "/" + dir_part + ".png"
		if ResourceLoader.exists(static_path):
			var tex: Texture2D = load(static_path)
			_frames.add_frame(anim_name, tex)
		else:
			# Ultimo recurso: pixel blanco transparente
			var img := Image.create(68, 68, false, Image.FORMAT_RGBA8)
			_frames.add_frame(anim_name, ImageTexture.create_from_image(img))

## Actualiza la animacion segun el vector de velocidad.
## Llamar en _physics_process del personaje.
func update_direction(velocity: Vector2) -> void:
	if velocity.length_squared() < 1.0:
		play_idle()
		return
	var dir_name: String = _velocity_to_dir(velocity)
	_play_anim("walk_" + dir_name)

## Fuerza animacion idle en la direccion actual.
func play_idle() -> void:
	# Extraer direccion de la animacion actual
	var dir_name: String = "south"
	if _current_anim != "":
		var parts := _current_anim.split("_", false, 1)
		if parts.size() == 2:
			dir_name = parts[1]
	_play_anim("idle_" + dir_name)

func _play_anim(anim_name: String) -> void:
	if _sprite == null or _current_anim == anim_name:
		return
	if not _frames.has_animation(anim_name):
		return
	_current_anim = anim_name
	_sprite.play(anim_name)

## Convierte un vector de velocidad a nombre de direccion isometrica.
## El eje Y apunta hacia abajo. Sur = abajo-derecha en pantalla.
func _velocity_to_dir(v: Vector2) -> String:
	var angle: float = v.angle()  # radianes, -PI a PI
	# Convertir a grados 0-360
	var deg: float = fmod(rad_to_deg(angle) + 360.0, 360.0)

	# 8 sectores de 45 grados. East=0 grados (derecha en pantalla).
	# Mapeamos a las 8 direcciones isometricas.
	# En vista isometrica: mover a la derecha (East) en pantalla = moverse al Este.
	if deg < 22.5 or deg >= 337.5:
		return "east"
	elif deg < 67.5:
		return "south-east"
	elif deg < 112.5:
		return "south"
	elif deg < 157.5:
		return "south-west"
	elif deg < 202.5:
		return "west"
	elif deg < 247.5:
		return "north-west"
	elif deg < 292.5:
		return "north"
	else:
		return "north-east"
