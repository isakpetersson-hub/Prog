extends Node

var ITEMS_SCENE_PATH = "res://Items/Scenes/"
var ITEMS_ICON_PATH = "res://Items/Icons/"
var JSON_PATH = "res://Data/items.json"
var items : Dictionary = {}

func _ready():
	load_items()

func load_items():
	var file = FileAccess.open(JSON_PATH, FileAccess.READ)
	if file:
		var json = JSON.new()
		json.parse(file.get_as_text())
		items = json.get_data()
	
	print("Loaded ", items.size(), " items")
	#print(items["moai"]["equipable"])
	#print(items)

func exists(item_id) -> bool:
	return items.has(item_id)

func get_item_name(item_id) -> String:
	return items[item_id]["name"]

func get_type(item_id):
	return items[item_id]["type"]

func _equipable(item_id):
	return items[item_id]["equipable"]

func get_scene(item_id):
		return ITEMS_SCENE_PATH + items[item_id]["scene"]

func get_icon(item_id):
	return ITEMS_ICON_PATH + items[item_id]["icon"]

# --- Grip Stuff ---
func get_grip(item_id):
	#if items[item_id].has["grip"]:
	return items[item_id]["grip"]
	#return -1
	
func get_grip_pos(item_id) -> Vector3:
	var pos = items[item_id]["grip_pos"]
	return Vector3(pos["x"],pos["y"],pos["z"])
	
func get_grip_rot(item_id) -> Vector3:
	var rot = items[item_id]["grip_rot"]
	return Vector3(rot["x"],rot["y"],rot["z"])

# --- Animation ---
func get_hold_anim(item_id):
	return items[item_id]["hold_anim"]

func get_rmb_anim(item_id):
	return items[item_id]["rmb_anim"]

func get_use_anim(item_id):
	return items[item_id]["use_anim"]

# --- Special ---
func get_all_ids() -> Array[String]:
	var ids : Array[String] = []
	for item in items:
		ids.append(item)
	return ids
		
		
		
# --- Data ---
func get_value(item_id):
	return items[item_id]["value"]


#TODO
#weight
#sats
#hold_anim
#use_anim
