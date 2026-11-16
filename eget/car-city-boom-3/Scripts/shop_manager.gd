extends Node3D
# Possible rework so that buyable items are just normal items that you have to 
# pay to pickup.

# This would solve camera issues and complicated setup, no UI

# Items should only spawn when the player is nearby
# when they are spawned they are rebuilt to have a paywall 
# and renamed to "item for x B$" so interaction works
# if the player moves away the items despawn

# the items spawn on the counter??
# Hopefully no explosion and no falling off 😬😬😬


@export var shop_id : String
var shop_items = ["cola", "cola", "cola", "moai", "moai", "moai", "moai"] # read from json, shop_id????
@onready var player_detector : Area3D = $player_detector
@onready var sell_area : Area3D = $sell_area

var json_path = ""

var spawned_items : Dictionary


func _player_entered(area: Node3D) -> void:
	#print("player enter shop")
	spawn_items()


func _player_exited(area: Node3D) -> void:
	#print("player exit shop")
	remove_items()


func spawn_items():
	for item in shop_items:
		spawn_item(item)

func remove_items():
	for item in spawned_items.keys():
		item.queue_free()
	spawned_items.clear()
	
	
func item_bought(item):
	shop_items.remove_at(shop_items.find(item))
	spawned_items.erase(item)

# selling
func _item_entered(body: Node3D) -> void:
	if body not in spawned_items.keys():
		GameManager.sell(ItemDB.get_value(body.name))
		spawn_item(body.name)
		shop_items.append(body.name)
		body.queue_free()
	
	
func spawn_item(item_id : String):
	var item_resource = load(ItemDB.get_scene(item_id))
	if item_resource:
		var item_instance : RigidBody3D = item_resource.instantiate()
		
		for child in item_instance.get_children():
			if child is Area3D:
				print(item_id)
				child.name = item_id + " for b$" + str(int(ItemDB.get_value(item_id)))
				# Attach buy script
				child.set_script(load("res://Scripts/item_iteract_buy.gd"))
				child.price = int(ItemDB.get_value(item_id))
		spawned_items[item_instance] = item_id
		add_child(item_instance)
		item_instance.position = sell_area.position + (sell_area.get_child(0).shape.size * (Vector3(GameManager.rng.randf(),GameManager.rng.randf(),GameManager.rng.randf()) + Vector3(-0.5,-0.5,-0.5)))
		print(item_instance.position)
	else:
		print("item scene FAIL")
