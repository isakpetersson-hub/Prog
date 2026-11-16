extends Inventory

@onready var UI = $"inventory UI"
@onready var car = $".."
@onready var huv = $"../huv"
@onready var light = $OmniLight3D
@onready var itemInfo = $"inventory UI/ColorRect2/infoText"

var items = ["lucky_charms","gun","moai","zingo","cola", "murklor","murklor","murklor","murklor","burkskinka","burkskinka", "beer", "beer","beer","cola","cola","cola"]

var spawned_items : Dictionary = {}

var hover_item = ""
var hover_object : RigidBody3D = null
var hover_mesh : MeshInstance3D = null
var rMouseDown = false
var active_hover = false
var is_inventory_open = false

func _ready() -> void:
	set_hotbar_rects($"inventory UI/hotbar/HBoxContainer/ColorRect/TextureRect",
					 $"inventory UI/hotbar/HBoxContainer/ColorRect2/TextureRect",
					 $"inventory UI/hotbar/HBoxContainer/ColorRect3/TextureRect",
					 $"inventory UI/hotbar/HBoxContainer/ColorRect4/TextureRect")
	set_hotbar(["gun","moai","beer","zingo"])
	set_cam($InventoryCam)
	
	inv_cam.current = false
	UI.visible = false
	light.visible = false
	
	#print(ItemDB.get_item_scene(items[0]))	
	
func _input(event: InputEvent) -> void:
	if (Input.is_action_just_pressed("inventory") and car.is_player_in_car()):
		if (is_inventory_open):
			close_inventory()
		else:
			open_inventory()
		AudioManager.play_location("swosh", global_position)
		is_inventory_open = !is_inventory_open
		print(is_inventory_open)

	if event is InputEventMouse and !rMouseDown:
		var result = raycast(event, get_world_3d().direct_space_state)

		if result and spawned_items.has(result.collider):
			active_hover = true
			var found_item = spawned_items[result.collider]

			if hover_mesh != null:
				hover_mesh.scale = Vector3.ONE

			hover_object = result.collider
			hover_mesh = hover_object.get_child(0)
			
			hover_item = found_item
			#var clicked_object = result.collider
			itemInfo.text = ItemDB.get_item_name(found_item)
			hover_mesh.scale = Vector3.ONE * 1.2
			#print("Ray hit: ", clicked_object.name)
		else:
			active_hover = false
			if hover_mesh != null:
				hover_mesh.scale = Vector3.ONE
		
		#print(active_hover)
		
	if car.is_player_in_car():
		if Input.is_action_just_pressed("slot1"):
			drop(0)
			pickup_car(0)
		
		if Input.is_action_just_pressed("slot2"):
			drop(1)
			pickup_car(1)
		
		if Input.is_action_just_pressed("slot3"):
			drop(2)
			pickup_car(2)
		
		if Input.is_action_just_pressed("slot4"):
			drop(3)
			pickup_car(3)
		
		if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT and car.is_player_in_car():
			var clicked_result = raycast(event, get_world_3d().direct_space_state)
			
			if clicked_result and spawned_items.has(clicked_result.collider):
				var clicked_object = clicked_result.collider
				var clicked_item = spawned_items[clicked_object]
				var empty_index = -1
				for i in range(4):
					if(hotbar[i] == ""):
						empty_index = i
						break
				if empty_index != -1:
					hotbar[empty_index] = clicked_item
					update_hotbar()
					#clicked_item.queue_free()
					remove_item(clicked_item, clicked_object)

		if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
			rMouseDown = true
		if event is InputEventMouseButton and event.is_released() and event.button_index == MOUSE_BUTTON_RIGHT:
			rMouseDown = false

func get_hotbar() -> Array[String]:
	return hotbar


func set_hotbar(o_hotbar : Array[String]):
	hotbar = o_hotbar

func drop(index):
	if hotbar[index] != "":
		var item_resource = load(ItemDB.get_scene(hotbar[index]))
		var item_instance = item_resource.instantiate()
		
		spawn_item(hotbar[index], item_instance)
		
		hotbar[index] = ""
		update_hotbar()
		
# Pickup item from car, removes it from the car
func pickup_car(index):
	if(active_hover):
		pickup(index, hover_item)
		remove_item(hover_item, hover_object)

		active_hover = false

func open_inventory():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	light.visible = true
	UI.visible = true
	inv_cam.current = true
	
	# Populate player hotbar
	update_hotbar()
	
	# spawn objects
	for item in items:
		#print(load(ItemDB.get_scene(item)))
		var item_resource = load(ItemDB.get_scene(item))

		if item_resource:
			var item_instance = item_resource.instantiate()
			get_tree().root.add_child(item_instance)
			item_instance.position = global_position + Vector3(randf()-0.5,randf()-1,randf()-0.5) * 0.5
			spawned_items[item_instance] = item
		else:
			print("item scene FAIL")


func close_inventory():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	light.visible = false
	#huv.rotation.x = 0
	UI.visible = false
	inv_cam.current = false
	for item in spawned_items:
		item.queue_free()
	spawned_items.clear()
		
func is_open() -> bool:
	return is_inventory_open

func _process(delta: float) -> void:
	if(is_inventory_open):
		huv.rotation.x = lerp(huv.rotation.x, deg_to_rad(90.0), 20 * delta)
	else:
		huv.rotation.x = lerp(huv.rotation.x, 0.0, 10 * delta)
		
	if rMouseDown and active_hover:
		var mouse_pos_world = get_mouse_xz_position(get_viewport().get_mouse_position(), global_position)
		mouse_pos_world = mouse_pos_world.clamp(global_position - Vector3(0.3,0.3,0.3), global_position + Vector3(0.3,0.3,0.3))

		hover_object.position =  mouse_pos_world
		
		hover_object.linear_velocity = Vector3.ZERO


func remove_item(item: String, object: RigidBody3D):
	items.remove_at(items.find(item))
	get_tree().root.remove_child(object)
	spawned_items.erase(object)

func spawn_item(item: String, instance):
		get_tree().root.add_child(instance)
		instance.position = global_position + Vector3(randf()-0.5,randf()-1,randf()-0.5) * 0.5
		spawned_items[instance] = item
		items.append(item)

func _on_button_1_pressed() -> void:
	drop(0)

func _on_button_2_pressed() -> void:
	drop(1)

func _on_button_3_pressed() -> void:
	drop(2)

func _on_button_4_pressed() -> void:
	drop(3)
	
