## audio_manager.gd
## Gestiona toda la reproducción de audio: música con crossfade y pool de SFX.

extends Node

const SFX_POOL_SIZE: int = 16

var _music_player: AudioStreamPlayer
var _sfx_pool: Array[AudioStreamPlayer] = []
var _current_music_path: String = ""

func _ready() -> void:
	_music_player = AudioStreamPlayer.new()
	_music_player.bus = "Music"
	add_child(_music_player)

	for i in SFX_POOL_SIZE:
		var player := AudioStreamPlayer.new()
		player.bus = "SFX"
		add_child(player)
		_sfx_pool.append(player)

# ============================================================
# MÚSICA
# ============================================================

func play_music(track_path: String, fade_duration: float = 1.0) -> void:
	if _current_music_path == track_path:
		return
	_current_music_path = track_path

	var tween := create_tween()
	tween.tween_property(_music_player, "volume_db", -80.0, fade_duration)
	tween.tween_callback(func():
		if ResourceLoader.exists(track_path):
			_music_player.stream = load(track_path)
			_music_player.play()
			create_tween().tween_property(_music_player, "volume_db", 0.0, fade_duration)
	)

func stop_music(fade_duration: float = 1.0) -> void:
	_current_music_path = ""
	var tween := create_tween()
	tween.tween_property(_music_player, "volume_db", -80.0, fade_duration)
	tween.tween_callback(_music_player.stop)

# ============================================================
# SFX
# ============================================================

func play_sfx(sfx_path: String, volume_db: float = 0.0, pitch: float = 1.0) -> void:
	if not ResourceLoader.exists(sfx_path):
		return
	var player := _get_free_player()
	if player == null:
		return
	player.stream = load(sfx_path)
	player.volume_db = volume_db + randf_range(-1.0, 1.0)
	player.pitch_scale = pitch + randf_range(-0.05, 0.05)
	player.play()

# ============================================================
# VOLUMEN
# ============================================================

func set_music_volume(volume_db: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), volume_db)

func set_sfx_volume(volume_db: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), volume_db)

# ============================================================
# INTERNO
# ============================================================

func _get_free_player() -> AudioStreamPlayer:
	for p in _sfx_pool:
		if not p.playing:
			return p
	return _sfx_pool[0]
