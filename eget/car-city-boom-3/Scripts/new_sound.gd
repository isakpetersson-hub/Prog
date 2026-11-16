extends Control
# REWRITE EVERYTHING

@export var clips : Dictionary = {}
const JSON_PATH = "res://Data/sound_data.json"

var sfx_paths: Array = []

@onready var id_edit: LineEdit = $container/IdEdit
@onready var limit_slider: HSlider = $container/LimitSlider 
@onready var limit_label: Label = $container/LimitLabel 
@onready var volume_slider: HSlider = $container/VolumeSlider 
@onready var volume_label: Label = $container/VolumeLabel 
@onready var pitch_scale_slider: HSlider = $container/PitchScaleSlider
@onready var pitch_scale_label: Label = $container/PitchScaleLabel
@onready var pitch_random_slider: HSlider = $container/PitchRandomSlider
@onready var pitch_random_label: Label = $container/PitchRandomLabel
@onready var sfx_label: Label = $container/SfxList
@onready var file_dialog: FileDialog = $container/FileDialog

@onready var sound_list : OptionButton = $left/Sounds

func _ready() -> void:

	$container/load.pressed.connect(func(): file_dialog.popup_centered(Vector2i(600, 400)))
	#$RemoveSfxButton.pressed.connect(_on_remove_sfx)
	$container/save.pressed.connect(save_pressed)
	$container/save_music.pressed.connect(save_to_music)
	file_dialog.files_selected.connect(files_selected)
	$container/test.pressed.connect(test_pressed)
	$container/exit.pressed.connect(get_tree().quit)
	$container/reset.pressed.connect(reset)
	
	load_json()
	for s in clips.keys():
		sound_list.add_item(s)
	$left/Load.pressed.connect(load_selected)

func reset():
	id_edit.text = ""
	limit_slider.value = 5
	volume_slider.value = 0
	pitch_scale_slider.value = 1
	pitch_random_slider.value = 0
	sfx_paths = []
	sfx_label.text = "none"

func _refresh_sfx_list() -> void:
	sfx_label.text = ""
	for p in sfx_paths:
		sfx_label.text += "\n" + p
	sfx_label.text = sfx_label.text.split("\n", true, 1)[1]

func files_selected(paths: PackedStringArray) -> void:
	for p in paths:
		sfx_paths.append(p)
	_refresh_sfx_list()

func save_pressed() -> void:
	var data := {
		"limit": int(limit_slider.value),
		"sound_effects": sfx_paths,
		"volume": volume_slider.value,
		"pitch_scale": pitch_scale_slider.value,
		"pitch_randomness": pitch_random_slider.value,
	}
	add_data_json(id_edit.text, data)
	
func save_to_music() -> void:
	load_json()
	var music : Dictionary = clips["music"]
	var data := {
		"path": sfx_paths[0],
		"volume": volume_slider.value
	}
	music[id_edit.text] = data
	add_data_json("music", music)

func load_selected():
	var data = clips[sound_list.text]
	
	id_edit.text = sound_list.text
	sfx_paths = data["sound_effects"]
	volume_slider.value = data["volume"]
	pitch_scale_slider.value = data["pitch_scale"]
	pitch_random_slider.value = data["pitch_randomness"]
	_refresh_sfx_list()

func test_pressed():
	$"..".play_raw(id_edit.text, limit_slider.value, sfx_paths, volume_slider.value, pitch_scale_slider.value, pitch_random_slider.value)

func load_json():
	var file = FileAccess.open(JSON_PATH, FileAccess.READ)
	if file:
		var json = JSON.new()
		json.parse(file.get_as_text())
		clips = json.get_data()

func add_data_json(id: String, data: Dictionary):
	load_json()
	
	clips[id] = data
	
	var json_string = JSON.stringify(clips, "\t")
	var file = FileAccess.open(JSON_PATH, FileAccess.WRITE)
	file.store_string(json_string)
	file.close()
