extends Node3D

var selected_item = -1
var item_instance: RigidBody3D = null
var item_held = ""
var held_pos = Vector3(0.4,-0.1,-1)
var held_rot = Vector3(0,-PI/3,PI/2)
@onready var hand: Node3D = $CCBMainCharacter/Armature/Skeleton3D/ModifierBoneTarget3D/ItemHolder

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func drop_item(index):
	print(hotbar)
	var pos = -cam.global_basis.z * 0.5 + cam.global_position
	#var force = (cam.global_position) - (-cam.global_basis + cam.global_position) * 0.1
	var i_velocity = ((cam.global_position + (-cam.global_basis.z))-(cam.global_position)) * 4
	
	if hotbar[index] != "":
		var item_resource = load(ItemDB.get_scene(hotbar[index]))
		var item_instance: RigidBody3D = item_resource.instantiate()
		get_tree().root.add_child(item_instance)
		item_instance.position = pos
		item_instance.linear_velocity = i_velocity + velocity
		hotbar[index] = ""
		update_hotbar()
		set_hand_grip(0)

func pickup(item_id) -> bool:
	var empty_index = -1
	for i in range(4):
		if(hotbar[i] == ""):
			empty_index = i
			break
	if empty_index != -1:
		hotbar[empty_index] = item_id
		update_hotbar()
		
		return true
	else:
		return false


func arm_space_blending():
	var blend_smoothing = 0.2
	var blend_target = 0.0
	if arm_camera_mode:
		blend_target = 1.0
	blend = lerp(blend, blend_target, blend_smoothing)
	right_hand.global_transform = lerp(hand_r_body.global_transform,hand_r_cam.global_transform, blend)
	
	# only blending right arm for now
	left_hand.global_transform = hand_l_body.global_transform
	
	
func update_holding():
	# 1 get selected hotbar or not selected if -1
	# 2 Get scene from itemdb
	# 3 instansiate on hand
	# 4 disable physics
	# 5 animation stuff maybe elsewhere
	
	
	#print("item held: ", item_held, " item selected: ", hotbar[selected_item])
	
	# remove from hand
	if item_held != hotbar[selected_item] and item_instance != null:
		#fprint("remove")
		hand.remove_child(item_instance)
		item_instance.queue_free()
		item_held = ""
		set_hand_grip(0)
	
	# instantiate on hand
	if selected_item != -1 and hotbar[selected_item] != "" and hotbar[selected_item] != item_held:
		var item = hotbar[selected_item]
		var item_resource = load(ItemDB.get_scene(item))
		item_instance = item_resource.instantiate()
		
		hand.add_child(item_instance)
		item_instance.set_owner(hand)
		item_instance.global_position = hand.global_position
		#item_instance.global_scale(Vector3.ONE)
		item_instance.freeze = true
		item_instance.scale = Vector3.ONE / scale
		
		var children = item_instance.get_children()
		
		for child in children:
			if child is not MeshInstance3D:
				
				item_instance.remove_child(child)
				child.queue_free()
		#print(item_instance.get_children())
		
		item_held = hotbar[selected_item]
		set_hand_grip(0.5)
		
		
		
func set_hand_grip(grip_factor : float): # 1 = closed, 0 = open
	for bone in bone_names:
		var bone_idx : int = skeleton.find_bone(bone)
		var rot : Quaternion = R_finger_data["open"][bone].slerp(R_finger_data["close"][bone], grip_factor)
		print(rot)
		skeleton.set_bone_pose_rotation(bone_idx, rot)
