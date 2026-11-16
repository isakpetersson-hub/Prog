extends Node


# Boom engine parts
# Other collectables
# 

# Save vars, set to dafault values
var money = 50
var player_inverntory = []
var player_pos
var car_pos
var active_viewpoint_pos
var car_inverntory = []

var boom_engine_part = [false,false,false,false,false]

# Options
var volume = 0

const save_file_path = "res://Data/save_data.json"
var save_data : Dictionary = {}

@onready var car
@onready var inventory
#@onready var player
var rng = RandomNumberGenerator.new()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("reset_game"):
		car.position = Vector3(-58.627, 18.113, -0.078)
		car._enter_car()
		
		#get_tree().reload_current_scene()

func _ready() -> void:
	if get_tree().current_scene.name == "game" or get_tree().current_scene.name == "testmap":
		car = get_tree().get_root().get_node("game/CarM1V2")
		inventory = car.get_node("./Inventory")
		AudioManager.change_music("city_theme", 0.5)

func get_player_inventory():
	pass

func get_car_inventory():
	pass

########################
## Transaction system ##
########################
func buy(value : int) -> bool:
	if money >= value:
		money -= value
		return true
	else:
		return false

func sell(value : int) -> bool:
	money += value
	return true

func get_money() -> int:
	return money

#################
## Save system ##
#################
func save_game():
	save_data["money"] = money
	save_data["boom_engine_part"] = boom_engine_part
	save_data["volume"] = volume
	

	save_data["player_inventory"] = player_inverntory
	save_data["car_inventory"] = car_inverntory
	
	# ----- Save Json -----
	var json_string = JSON.stringify(save_data, "\t")
	var file = FileAccess.open(save_file_path, FileAccess.WRITE)
	file.store_string(json_string)
	file.close()
	print("Saved game")


func load_game():
	var file = FileAccess.open(save_file_path, FileAccess.READ)
	if file:
		var json = JSON.new()
		json.parse(file.get_as_text())
		save_data = json.get_data()
		print("Loaded game")
		
	money = save_data["money"]
	boom_engine_part = save_data["boom_engine_part"]
	volume = save_data["volume"]
