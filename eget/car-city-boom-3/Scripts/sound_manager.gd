extends Node3D

var clips : Dictionary = {}
const JSON_PATH = "res://Data/sound_data.json"

var limits : Dictionary[String, int] = {}

var music_new : AudioStreamPlayer = null
var music_old : AudioStreamPlayer = null
var changing_music = false

var tween_new: Tween
var tween_old: Tween


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_json()
	print("Loaded ", str(clips.keys().size()), " sound effects")
	if get_tree().current_scene == self:
		var popup := preload("res://Scenes/Utility/add_new_sound.tscn").instantiate()
		add_child(popup)
		load_json()
	
	music_new = AudioStreamPlayer.new()

#func _process(delta: float) -> void:
	

func play_location(sound : String, pos : Vector3 = Vector3(0,0,0)) -> void: 
	var clip = clips[sound]
	
	if limits.has(sound):
		if limits[sound] >= clips[sound]["limit"]:
			return
	else:
		limits[sound] = 0
		
	change_audio_count(sound, true)
	var new_audio: AudioStreamPlayer3D = AudioStreamPlayer3D.new()
	add_child(new_audio)
	new_audio.position = pos
	new_audio.stream = load(clip["sound_effects"][GameManager.rng.randi_range(0, clip["sound_effects"].size()-1)])
	new_audio.volume_db = clip["volume"]
	new_audio.pitch_scale = clip["pitch_scale"]
	new_audio.pitch_scale += GameManager.rng.randf_range(-clip["pitch_randomness"], clip["pitch_randomness"] )
	new_audio.finished.connect(change_audio_count.bind(sound, false))
	new_audio.finished.connect(new_audio.queue_free)
	new_audio.play()


func play(sound : String) -> void:
	var clip = clips[sound]
	
	if limits.has(sound):
		if limits[sound] >= clips[sound]["limit"]:
			return
	else:
		limits[sound] = 0
		
	change_audio_count(sound, true)
	var new_audio: AudioStreamPlayer = AudioStreamPlayer.new()
	add_child(new_audio)
	new_audio.stream = load(clip["sound_effects"][GameManager.rng.randi_range(0, clip["sound_effects"].size()-1)])
	new_audio.volume_db = clip["volume"]
	new_audio.pitch_scale = clip["pitch_scale"]
	new_audio.pitch_scale += GameManager.rng.randf_range(-clip["pitch_randomness"], clip["pitch_randomness"] )
	new_audio.finished.connect(change_audio_count.bind(sound, false))
	new_audio.finished.connect(new_audio.queue_free)
	new_audio.play()


func play_raw(sound : String, limit : int, paths: Array, volume : float, pitch_scale : float, pitch_randomness : float):
	#if limits[sound] < clips[sound]["limit"]:
	print(sound, limit, paths, volume, pitch_scale, pitch_randomness)
	if limits.has(sound):
		if limits[sound] >= limit:
			return
			
	else:
		limits[sound] = 0
		
	change_audio_count(sound, true)
	var new_audio: AudioStreamPlayer = AudioStreamPlayer.new()
	add_child(new_audio)
	new_audio.stream = load(paths[GameManager.rng.randi_range(0, paths.size()-1)])
	new_audio.volume_db = volume
	new_audio.pitch_scale = pitch_scale
	new_audio.pitch_scale += GameManager.rng.randf_range(-pitch_randomness, pitch_randomness )
	new_audio.finished.connect(change_audio_count.bind(sound, false))
	new_audio.finished.connect(new_audio.queue_free)
	new_audio.play()

# maybe add ambiance layer that can play at the same time??
func change_music(music : String, fade_time : float):
	# Global old and new music  (music1, music2)
	# Crossfade the volume over specified time
	# remove music1, music1 := music2
	
	# Special case for first time
	
	changing_music = true
	if music_old != null:
		music_old.queue_free()
	music_old = music_new
	
	music_new = AudioStreamPlayer.new()
	add_child(music_new)
	music_new.volume_db = -80
	music_new.stream = load(clips["music"][music]["path"])
	music_new.playing = true
	
	# change volume with a tween????
	tween_old = get_tree().create_tween()
	tween_old.tween_property(music_old, "volume_db", -80, fade_time)
	tween_new = get_tree().create_tween()
	tween_new.tween_property(music_new, "volume_db", clips["music"][music]["volume"], fade_time)

func get_all_music() -> Array:
	return clips["music"].keys()

func stop_music():
	music_new.volume_db = -80

func change_audio_count(sound : String, increase : bool = false):
	if increase:
		limits[sound] += 1
	else:
		limits[sound] -= 1
		

func load_json():
	var file = FileAccess.open(JSON_PATH, FileAccess.READ)
	if file:
		var json = JSON.new()
		json.parse(file.get_as_text())
		clips = json.get_data()

func save_json():
	var json_string = JSON.stringify(clips, "\t")
	var file = FileAccess.open(JSON_PATH, FileAccess.WRITE)
	file.store_string(json_string)
	file.close()
