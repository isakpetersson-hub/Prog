extends Node3D

const SENSITIVITY = 0.002
@onready var rotPoint : Node3D = $Skeleton3D/ModifierBoneTarget3D/ItemHolder/CamRot
@onready var rotPoint2 : Node3D = $Skeleton3D/ModifierBoneTarget3D/ItemHolder/CamRot/CamRot2

@onready var posBoxes : Array[SpinBox] = [
	$right/XposBox,
	$right/YposBox,
	$right/ZposBox]

@onready var rotBoxes : Array[SpinBox] = [
	$right/XrotBox, 
	$right/YrotBox, 
	$right/ZrotBox, 
	$right/WrotBox]

@onready var gripBox : SpinBox = $right/GripBox

@onready var dropDown : OptionButton = $left/Items
@onready var loadBtn : Button = $left/Load
@onready var saveBtn : Button = $left/Save

var item_instance: RigidBody3D = null
var item_held = ""
#var held_pos = Vector3(0.4,-0.1,-1)
#var held_rot = Vector3(0,-PI/3,PI/2)
@onready var hand: Node3D = $Skeleton3D/ModifierBoneTarget3D/ItemHolder
@onready var ikHand : SkeletonIK3D = $Skeleton3D/IKRightHand
@onready var skeleton : Skeleton3D = $Skeleton3D
var item_loaded : bool = false

var R_finger_data : Dictionary = {}
var bone_names = ["Rindex1","Rindex2","Rindex3","Rmiddle1","Rmiddle2","Rmiddle3",
				  "Rpinky1","Rpinky2","Rpinky3","Rring1","Rring2","Rring3","Rthumb1","Rthumb2"]

const JSON_PATH = "res://Data/items.json"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var items = ItemDB.get_all_ids()
	for i in range(items.size()):
		dropDown.add_icon_item(load(ItemDB.get_icon(items[i])),items[i],i)
	
	ikHand.start(true)
	
	
	var file_in = FileAccess.open("res://Data/bone_grip_data.json", FileAccess.READ)
	var raw : Dictionary
	if file_in:
		var json = JSON.new()
		json.parse(file_in.get_as_text())
		raw = json.get_data()
	
	for grip_name in raw:
		R_finger_data[grip_name] = {}
		for bone_name in raw[grip_name]:
			var s : String = raw[grip_name][bone_name]
			# Strip parentheses and split by ", "
			s = s.trim_prefix("(").trim_suffix(")")
			var parts = s.split(", ")
			R_finger_data[grip_name][bone_name] = Quaternion(
				float(parts[0]),
				float(parts[1]),
				float(parts[2]),
				float(parts[3])
			).normalized()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	set_hand_grip(gripBox.value/100)
	if item_instance != null:
		item_instance.position = Vector3(posBoxes[0].value, posBoxes[1].value, posBoxes[2].value)
		item_instance.rotation = Vector3(rotBoxes[0].value, rotBoxes[1].value, rotBoxes[2].value)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.is_action_pressed("leftMB"):
		rotPoint.rotate_y(-event.relative.x * SENSITIVITY);
		rotPoint2.rotate_x(-event.relative.y * SENSITIVITY)
		


func load_item(item : String) -> RigidBody3D:
	if item_loaded:
		hand.remove_child(item_instance)
		item_instance.queue_free()
		item_held = ""
		set_hand_grip(0)
	
	var item_resource = load(ItemDB.get_scene(item))
	item_instance = item_resource.instantiate()
	item_held = item
	
	hand.add_child(item_instance)
	item_instance.set_owner(hand)
	item_instance.global_position = hand.global_position
	item_instance.freeze = true
	item_instance.scale = Vector3.ONE / scale
	print(item_instance.scale)
	
	var children = item_instance.get_children()
	
	for child in children:
		if child is not MeshInstance3D:
			item_instance.remove_child(child)
			child.queue_free()
	item_loaded = true
	return item_instance

func set_hand_grip(grip_factor : float): # 1 = closed, 0 = open
	for bone in bone_names:
		var bone_idx : int = skeleton.find_bone(bone)
		var rot : Quaternion = R_finger_data["open"][bone].slerp(R_finger_data["close"][bone], grip_factor)
		#print(rot)
		skeleton.set_bone_pose_rotation(bone_idx, rot)


func _on_load_pressed() -> void:
	var item = dropDown.get_item_text(dropDown.selected)
	item_instance = load_item(item)
	
	var grip = ItemDB.get_grip(item)
	if grip != -1:
		gripBox.value = grip * 100
		
		posBoxes[0].value = ItemDB.get_grip_pos(item).x
		posBoxes[1].value = ItemDB.get_grip_pos(item).y
		posBoxes[2].value = ItemDB.get_grip_pos(item).z
		
		rotBoxes[0].value = ItemDB.get_grip_rot(item).x
		rotBoxes[1].value = ItemDB.get_grip_rot(item).y
		rotBoxes[2].value = ItemDB.get_grip_rot(item).z
	
	

func _on_save_pressed() -> void:
	var file = FileAccess.open(JSON_PATH, FileAccess.READ)
	var items
	if file:
		var json = JSON.new()
		json.parse(file.get_as_text())
		items = json.get_data()
	
	var item : Dictionary = items[item_held]
	item["grip"] = gripBox.value / 100
	var grip_pos : Dictionary = {}
	var grip_rot : Dictionary = {}
	grip_pos["x"] = posBoxes[0].value
	grip_pos["y"] = posBoxes[1].value
	grip_pos["z"] = posBoxes[2].value
	grip_rot["x"] = rotBoxes[0].value
	grip_rot["y"] = rotBoxes[1].value
	grip_rot["z"] = rotBoxes[2].value
	
	item["grip_pos"] = grip_pos
	item["grip_rot"] = grip_rot
	
	items[item_held] = item
	
	var json_string = JSON.stringify(items, "\t")
	#print(json_string)
	var file2 = FileAccess.open(JSON_PATH, FileAccess.WRITE)
	file2.store_string(json_string)
	file2.close()
	print("saved ", item_held)
