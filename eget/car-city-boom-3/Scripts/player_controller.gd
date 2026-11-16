extends CharacterBody3D

const SPEED = 3.0
const RUNNING_SPEED = 9.0
const RUNNING_STEP_RATIO = 2
const AIR_SPEED = 0.1
const CROUCH_SPEED = 1
const CROUCH_HEIGHT = 1.3
const CROUCH_STEP_RATIO = 0.5
const NORMAL_HEIGHT = 1.8
const COLLIDER_POS = 0.971
const SLIDE_SPEED = 0.05
const SLIDE_SLOPE_AFFECT = 1
var speed = 0
const CROUCH_SLIDE_THRESHOLD = 3
var sliding = false
var running = false

const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.002

const RELATIVE_TO_GROUND_FACTOR = 1.3
var BOB_FREQ_BASE = 3.5 / RELATIVE_TO_GROUND_FACTOR
var BOB_FREQ = BOB_FREQ_BASE
const BOB_AMP = 0.12
var t_bob = 0
var l_foot_air := false
var r_foot_air := false

const ACCELERATION = 0.2
const DEACCELERATION = 0.1
var direction: Vector3 = Vector3(0,0,0)

var current_interactable = null
var is_looking_at_interactable = false

# Inventory list
var hotbar: Array[String] = ["", "", "", ""]
var selected_item = -1
var item_instance: RigidBody3D = null
var item_held = ""
@onready var hand: Node3D = $CCBMainCharacter/Armature/Skeleton3D/ModifierBoneTarget3D/ItemHolder
var rhand_idx : int
var lhand_idx : int
#@onready var hand: Node3D = $Neck/Head/Camera3D/CameraCoordinateTargetRightHand/ItemHolder

@onready var IKList: Array[SkeletonIK3D] = [
	$CCBMainCharacter/Armature/Skeleton3D/IKLeftHand,
	$CCBMainCharacter/Armature/Skeleton3D/IKRightHand,
	$CCBMainCharacter/Armature/Skeleton3D/IKLeftFoot,
	$CCBMainCharacter/Armature/Skeleton3D/IKRightFoot]

@onready var neck = $Neck
var neckOffset
var neck_idx : int
@onready var head = $Neck/Head

var mouse_delta : Vector2 = Vector2.ZERO
@onready var cam: Camera3D = $Neck/Head/Camera3D
@onready var skeleton : Skeleton3D = $CCBMainCharacter/Armature/Skeleton3D
@onready var character = $CCBMainCharacter

@onready var footRay : RayCast3D = $FootRay

@onready var ray_cast : RayCast3D = $Neck/Head/Camera3D/RayCast3D
@onready var interact_label = $"Interact text"


@onready var player_slots_rect : Array[TextureRect] = [
		$hotbar/HBoxContainer/ColorRect/TextureRect, 
		$hotbar/HBoxContainer/ColorRect2/TextureRect,
		$hotbar/HBoxContainer/ColorRect3/TextureRect,
		$hotbar/HBoxContainer/ColorRect4/TextureRect
	]

@onready var left_foot = $IKTargets/TargetLeftFoot
@onready var right_foot = $IKTargets/TargetRightFoot
@onready var left_hand = $IKTargets/TargetLeftHand
@onready var right_hand = $IKTargets/TargetRightHand

@onready var hand_l_body = $IKTargets/BodyCoordinateTargetLeftHand
@onready var hand_l_cam = $Neck/Head/Camera3D/CameraCoordinateTargetLeftHand

@onready var hand_r_body = $IKTargets/BodyCoordinateTargetRightHand
@onready var hand_r_cam = $Neck/Head/Camera3D/CameraCoordinateTargetRightHand
var blend_right = 0.0
var blend_left = 0.0
var arm_camera_mode = false # right arm
var arm_wallet_mode = false # left arm 
#@onready var left_hand = $Neck/Head/Camera3D/IkArms/TargetLeftHand
#@onready var right_hand = $Neck/Head/Camera3D/IkArms/TargetRightHand
var R_finger_data : Dictionary = {}
var bone_names = ["Rindex1","Rindex2","Rindex3","Rmiddle1","Rmiddle2","Rmiddle3",
				  "Rpinky1","Rpinky2","Rpinky3","Rring1","Rring2","Rring3","Rthumb1","Rthumb2"]
var bone_idx : Array = []


var step_length_base = 0.75 * RELATIVE_TO_GROUND_FACTOR
var step_length = 0.75 * RELATIVE_TO_GROUND_FACTOR

var left_foot_offset_standing = Vector3(0.2, 0.1, 0)
var right_foot_offset_standing = Vector3(-0.2, 0.1, 0)
var left_foot_offset_crouching = Vector3(0.2, 0.1 + (NORMAL_HEIGHT - CROUCH_HEIGHT) * 3/2, 0)
var right_foot_offset_crouching = Vector3(-0.2, 0.1 + (NORMAL_HEIGHT - CROUCH_HEIGHT) * 3/2, 0)

var left_foot_offset = Vector3(0.2, 0.1, 0)
var right_foot_offset = Vector3(-0.2, 0.1, 0)


var left_foot_jump_pos = Vector3(0.1, 0.7, 0.2)
var right_foot_jump_pos = Vector3(-0.25, 0.5, 0)

var left_foot_jump_pos_crouch = Vector3(2, 0.7, 0.0)
var right_foot_jump_pos_crouch = Vector3(-2, 0.7, 0)

var left_foot_jump_pos_run = Vector3(0.3, 0, 2)
var right_foot_jump_pos_run = Vector3(-0.3, 1, -1)
var jump_run_step = 0


@onready var collider = $CollisionShape3D

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var state_machine = anim_tree.get("parameters/arms")

@onready var debugObj : CSGSphere3D = $debug

@onready var wallet : Node3D = $CCBMainCharacter/Armature/Skeleton3D/ModifierBoneTarget3D2/Wallet

@onready var whole_character = $CCBMainCharacter

var ignore_next_mouse_motion := false

func _ready() -> void:
	ray_cast.enabled = true
	ray_cast.collision_mask = 2
	cam.current = true
	neckOffset = neck.position
	neck_idx = skeleton.find_bone("neck")
	rhand_idx = skeleton.find_bone("Rhand")
	lhand_idx = skeleton.find_bone("Lhand")
	
	for i in range(bone_names.size()):
		bone_idx.append(skeleton.find_bone(bone_names[i]))
	#print(skeleton.get_bone_count(), " bones")
	
	for ik in IKList:
		ik.start()
		
	IKList[0].target_node = "../../../../IKTargets/TargetLeftHand"
	IKList[1].target_node = "../../../../IKTargets/TargetRightHand"
	
	#anim.set_blend_time("Idle", "Walk", 0.2)
	#anim.set_blend_time("Walk", "Idle", 0.2)
	
	anim.playback_default_blend_time = 0.2
	
	anim_tree.active = true
	$AnimationPlayer.play("RESET")  # Play a reset animation
	$AnimationPlayer.stop()
	
	IKList[1].process_priority = 100
	
	# --- Grip setup ---
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
	set_hand_grip(0)



func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if ignore_next_mouse_motion:
			ignore_next_mouse_motion = false
			return
		mouse_delta += event.relative

func _physics_process(delta: float) -> void:
	#skeleton.set_bone_pose_position(head_idx, cam.position)
	
	_check_for_interactables()
	_handle_interaction_input()
	# Add the gravity.
	if not is_on_floor():
		velocity.y += -9.81 * delta
		#velocity.y += -12 * delta

	var damp = 10
	if Input.is_action_pressed("crouch"):
		collider.shape.height = lerp(collider.shape.height, CROUCH_HEIGHT, 1.0 - exp(-damp * delta))
		collider.position.y = lerp(collider.position.y, COLLIDER_POS + (NORMAL_HEIGHT - CROUCH_HEIGHT) / 2, 1.0 - exp(-damp * delta))
		left_foot_offset = lerp(left_foot_offset, left_foot_offset_crouching, 1.0 - exp(-damp * delta))
		right_foot_offset = lerp(right_foot_offset, right_foot_offset_crouching, 1.0 - exp(-damp * delta))
		
		step_length = step_length_base * CROUCH_STEP_RATIO
		BOB_FREQ = BOB_FREQ_BASE / CROUCH_STEP_RATIO
		
		
	else:
		collider.shape.height = lerp(collider.shape.height, NORMAL_HEIGHT, 1.0 - exp(-damp * delta))
		collider.position.y = lerp(collider.position.y, COLLIDER_POS, 1.0 - exp(-damp * delta))
		left_foot_offset = lerp(left_foot_offset, left_foot_offset_standing, 1.0 - exp(-damp * delta))
		right_foot_offset =  lerp(right_foot_offset, right_foot_offset_standing, 1.0 - exp(-damp * delta))
		
		if running:
			step_length = step_length_base * RUNNING_STEP_RATIO
			BOB_FREQ = BOB_FREQ_BASE / RUNNING_STEP_RATIO
		else:
			step_length = step_length_base
			BOB_FREQ = BOB_FREQ_BASE

	# Handle jump.
	if Input.is_action_just_pressed("brake") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_run_step += 1
		jump_run_step = jump_run_step % 2
		#print(jump_run_step)
	sliding = false
	running = false
	if is_on_floor():
		if Input.is_action_pressed("crouch"):
			if velocity.length() >= CROUCH_SLIDE_THRESHOLD:
				speed = SLIDE_SPEED
				sliding = true
			else:
				speed = CROUCH_SPEED
				sliding = false
		elif Input.is_action_pressed("shift"):
			running = true
			speed = RUNNING_SPEED
		else:
			running = false
			speed = SPEED
	else:
		speed = AIR_SPEED

	var input_dir := Input.get_vector("left", "right", "forward", "back")
	direction = (transform.basis * Vector3(input_dir.x,0,input_dir.y)).normalized()
	if(is_on_floor()):
		if sliding:
			if direction:
				velocity.x += (direction.x * speed)
				velocity.z += (direction.z * speed)
				# Half life damping
			var floorVec : Vector3 = get_floor_vector()
			var slopeVec : Vector3 = floorVec.cross(floorVec.cross(Vector3.UP))
			velocity += slopeVec * SLIDE_SLOPE_AFFECT * Vector3(1,2,1)
			#print(floorVec , " : " , slopeVec)
			#debugObj.position = slopeVec + Vector3(0,1,0)
			
			velocity.x *= pow(0.5, delta * 2.5)
			velocity.z *= pow(0.5, delta * 2.5)
		else:
			if direction:
				velocity.x = lerp(velocity.x, direction.x * speed, ACCELERATION)
				velocity.z = lerp(velocity.z, direction.z * speed, ACCELERATION)
			else:
				velocity.x = lerp(velocity.x, 0.0, DEACCELERATION)
				velocity.z = lerp(velocity.z, 0.0, DEACCELERATION)
	else:
		if direction:
			velocity.x += direction.x * speed
			velocity.z += direction.z * speed

	if Input.is_action_just_pressed("slot1"):
		selected_item = 0
	if Input.is_action_just_pressed("slot2"):
		selected_item = 1
	if Input.is_action_just_pressed("slot3"):
		selected_item = 2
	if Input.is_action_just_pressed("slot4"):
		selected_item = 3
	
	if Input.is_action_just_pressed("scrollDown"):
		selected_item = selected_item + 1
		if selected_item > 3: selected_item = 0
		elif selected_item < 0: selected_item = 3
			 
	elif Input.is_action_just_pressed("scrollUp"):
		selected_item = selected_item - 1 
		if selected_item > 3: selected_item = 0
		elif selected_item < 0: selected_item = 3
		
	if Input.is_action_just_pressed("turnR"):
		selected_item = -1
	
	if Input.is_action_just_pressed("turnL"):
		drop_item(selected_item)
	
	update_hotbar()
	move_and_slide()

func set_hotbar(items : Array[String]):
	hotbar = items
	update_hotbar()

func get_hotbar() -> Array[String]:
	return hotbar

func _headbob(time) -> Vector3:
	var pos: Vector3 = Vector3.ZERO
	pos.y = abs(sin(time * BOB_FREQ)) * BOB_AMP - BOB_AMP
	pos.x = cos(time * BOB_FREQ) * BOB_AMP/4
	return pos

# https://www.desmos.com/calculator/ycrvpv2dx2 <- calculations
func foot_position(time: float, offset: Vector3, direction: Vector3, step_height: float, left_foot : bool) -> Vector3:
	var dir = Vector2(direction.x, direction.z)
	var angle = dir.angle()
	
	var pos: Vector3 = Vector3.ZERO
	var t = fmod(time, 2 * PI/BOB_FREQ)
	var local_y = step_height * max((pow((t-(PI/BOB_FREQ))/(PI/BOB_FREQ),3) - (t-(PI/BOB_FREQ))/(PI/BOB_FREQ)),0)
	var local_z = step_length * (2-abs((t-PI/BOB_FREQ)*(2*BOB_FREQ)/PI) - 1)
	
	var bas = transform.basis
	bas = bas.rotated(Vector3.UP, angle+PI/2) # rotate so walking towards velocity
	bas = bas.scaled(Vector3(-.8,1,1)) # Flip x and smaller steps left and right
	pos = bas * Vector3(0,local_y,local_z)
	
	var is_airborne = local_y > 0.001  # small epsilon, not exactly 0
	if left_foot:
		if l_foot_air and not is_airborne:
			AudioManager.play_location("step", global_position)
		l_foot_air = is_airborne
	else:
		if r_foot_air and not is_airborne:
			AudioManager.play_location("step", global_position)
		r_foot_air = is_airborne
	
	return pos + offset

func foot_rotation(time: float) -> float:
	var angle = clamp(-sin(time)*BOB_FREQ,0,PI/5)
	return angle

func _check_for_interactables():
	if ray_cast.is_colliding():
		var collider = ray_cast.get_collider()
		
		if collider is Interactable:
			if current_interactable != collider:
				if current_interactable:
					current_interactable.on_look_away()
					
				current_interactable = collider
				current_interactable.on_look_at()
				is_looking_at_interactable = true
		else:
			if current_interactable:
				current_interactable.on_look_away()
				current_interactable = null
			is_looking_at_interactable = false
	else:
		if current_interactable:
			current_interactable.on_look_away()
			current_interactable = null
		is_looking_at_interactable = false

func get_floor_vector() -> Vector3:
	var vector : Vector3 = Vector3(0,0,0)
	if footRay.is_colliding():
		vector = footRay.get_collision_normal()
	return vector

func _handle_interaction_input():
	if Input.is_action_just_pressed("interact") and current_interactable:
		current_interactable.interact(self)

func _process(delta: float) -> void:
	if is_looking_at_interactable and current_interactable:
		interact_label.text  = "[F] " + current_interactable.name
	else:
		interact_label.text = ""
	
	#wallet.global_transform = skeleton.get_bone_global_pose(lhand_idx)
	#wallet.position -= Vector3(0.113,0.259,-0.076)
	#wallet.rotation -= Vector3(28.3,174,31.7)
	
	
	# --- Mouse Movement ---	
	if arm_wallet_mode:
		rotate_y(-mouse_delta.x * SENSITIVITY / 6)
		head.rotate_x(-mouse_delta.y * SENSITIVITY / 6)
	else:
		rotate_y(-mouse_delta.x * SENSITIVITY)
		head.rotate_x(-mouse_delta.y * SENSITIVITY)
	head.rotation.x = clamp(head.rotation.x, -PI/2, PI/2)
	
	#if (head.rotation.x >= PI/2 or head.rotation.x <= -PI/2) and !is_on_floor():
	#	whole_character.rotate_x(-mouse_delta.y * SENSITIVITY)
	
	#if is_on_floor() and whole_character.rotation.x != 0:
	#	whole_character.rotation.x = 0
	
	#mouse_delta *= pow(0.5, delta * 75)
	mouse_delta = Vector2.ZERO
	skeleton.set_bone_pose_rotation(neck_idx, Quaternion.from_euler(Vector3(-head.rotation.x, 0, 0)))
	#hand.global_transform = skeleton.get_bone_global_pose(rhand_idx)
	#cam.force_update_transform()
	#right_hand.force_update_transform()
	
	# ----- IK LEG ANIMATION -----
	var lerp_val = 0.5
	if direction and is_on_floor() and not sliding:
		t_bob += delta * velocity.length() * float(is_on_floor())
		var step_h = 2
		if Input.is_action_pressed("crouch"):
			step_h = 0.75
		
		left_foot.position = lerp(left_foot.position, foot_position(t_bob + PI/BOB_FREQ/2, left_foot_offset, direction, step_h, true), lerp_val)
		right_foot.position =  lerp(right_foot.position,foot_position(t_bob - PI/BOB_FREQ/2, right_foot_offset, direction, step_h, false), lerp_val)
		
		#left_foot.rotation.z = lerp(left_foot.rotation.z, foot_rotation(t_bob + PI/BOB_FREQ/2) + PI/2, lerp_val)
		
	# Standing still fade
	elif !direction and is_on_floor():
		t_bob = fmod(t_bob,2 * PI/BOB_FREQ)
		t_bob = lerp(t_bob, 0.0,  1.0 - exp(-10 * delta))
		left_foot.position = lerp(left_foot.position, left_foot_offset, 1.0 - exp(-10 * delta))
		right_foot.position = lerp(right_foot.position, right_foot_offset, 1.0 - exp(-10 * delta))
	
	# Foot position magic, ugly as hell but works
	elif !is_on_floor():
		t_bob = fmod(t_bob,2 * PI/BOB_FREQ)
		t_bob = lerp(t_bob, 0.0,  1.0 - exp(-10 * delta))
		if(Input.is_action_pressed("crouch")):
			left_foot.position = lerp(left_foot.position, left_foot_jump_pos_crouch, 1.0 - exp(-10 * delta))
			right_foot.position = lerp(right_foot.position, right_foot_jump_pos_crouch, 1.0 - exp(-10 * delta))
		elif Input.is_action_pressed("shift"):
			if jump_run_step == 0:
				left_foot.position = lerp(left_foot.position, left_foot_jump_pos_run, 1.0 - exp(-10 * delta))
				right_foot.position = lerp(right_foot.position, right_foot_jump_pos_run, 1.0 - exp(-10 * delta))
			else:
				left_foot.position = lerp(left_foot.position, right_foot_jump_pos_run * Vector3(-1,1,1), 1.0 - exp(-20 * delta))
				right_foot.position = lerp(right_foot.position, left_foot_jump_pos_run * Vector3(-1,1,1), 1.0 - exp(-20 * delta))
		else:
			left_foot.position = lerp(left_foot.position, left_foot_jump_pos, 1.0 - exp(-10 * delta))
			right_foot.position = lerp(right_foot.position, right_foot_jump_pos, 1.0 - exp(-10 * delta))
	
	neck.position = _headbob(t_bob + PI/BOB_FREQ/2) + neckOffset
	character.position = _headbob(t_bob + PI/BOB_FREQ/2)

	# Wallet code
	if Input.is_action_just_pressed("wallet"):
		arm_wallet_mode = !arm_wallet_mode
		if arm_wallet_mode:
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
			ignore_next_mouse_motion = true
			wallet.pickup_wallet()
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			ignore_next_mouse_motion = true
			wallet.putdown_wallet()
	

	
	# I am the GOAT, this is goated code
	if item_held != "":
		
		if Input.is_action_just_pressed("leftMB") and ItemDB.get_use_anim(item_held) != "disabled":
			anim_tree.set("parameters/hold_type/transition_request", ItemDB.get_hold_anim(item_held))
			#print(item_held)
			anim_tree.set("parameters/" + ItemDB.get_hold_anim(item_held) + "_oneshot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
			#print("parameters/" + ItemDB.get_use_anim(item_held) + "_oneshot/request")
			item_instance.on_use(self)
		
		if Input.is_action_pressed("rightMB") and ItemDB.get_rmb_anim(item_held) != "disabled":
			anim_tree.set("parameters/hold_type/transition_request", ItemDB.get_hold_anim(item_held))
			anim_tree.set("parameters/" + ItemDB.get_hold_anim(item_held) + "/transition_request", "hold_rmb")
			
			item_instance.on_right_hold(self)
		else:
			anim_tree.set("parameters/hold_type/transition_request", ItemDB.get_hold_anim(item_held))
			anim_tree.set("parameters/" + ItemDB.get_hold_anim(item_held) + "/transition_request", "hold")
			
		if Input.is_action_just_pressed("rightMB"):
			item_instance.on_right_press(self)
		elif Input.is_action_just_released("rightMB"):
			item_instance.on_right_release(self)

	# ----- ANIMATION -----
	#anim.speed_scale = 1
	if direction and is_on_floor():
		#anim.play("Walk")
		#anim.seek((t_bob/(2*PI) * BOB_FREQ) + PI/BOB_FREQ/2)
		if (not running):
			anim_tree.set("parameters/arms/transition_request", "Walk")
			anim_tree.set("parameters/walk_freq/seek_request", (t_bob/(2*PI) * BOB_FREQ) + PI/BOB_FREQ/2) 
		else:
			anim_tree.set("parameters/arms/transition_request", "Run")
			anim_tree.set("parameters/walk_freq2/seek_request", (t_bob/(2*PI) * BOB_FREQ) + PI/BOB_FREQ/2) 
		
		#anim.speed_scale = 0
	elif !direction and is_on_floor():
		#anim.play("Idle")
		anim_tree.set("parameters/arms/transition_request", "Idle")
	elif !is_on_floor():
		#anim.play("Jump")
		anim_tree.set("parameters/arms/transition_request", "Jump")
		
	if item_held != "":
		arm_camera_mode = true
	else:
		arm_camera_mode = false
		
	arm_space_blending(delta)
	#skeleton.call_deferred("force_update_all_bone_transforms")

func drop_item(index):
	print(hotbar)
	var pos = -cam.global_basis.z * 0.5 + cam.global_position
	#var force = (cam.global_position) - (-cam.global_basis + cam.global_position) * 0.1
	var i_velocity = ((cam.global_position + (-cam.global_basis.z))-(cam.global_position)) * 4
	
	if hotbar[index] != "":
		var item_resource = load(ItemDB.get_scene(hotbar[index]))
		var item_instance = item_resource.instantiate()
		get_tree().root.add_child(item_instance)
		item_instance.position = pos
		item_instance.linear_velocity = i_velocity + velocity
		item_instance.angular_velocity = Vector3(-7, 5, -5) # "random" spin
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

func arm_space_blending(delta):
	var blend_smoothing = 10

	var blend_target_right = 0.0
	var blend_target_left = 0.0
	if arm_camera_mode: blend_target_right = 1.0
	if arm_wallet_mode: blend_target_left = 1.0
	
	# Right Hand
	blend_right = lerp(blend_right, blend_target_right, 1.0 - exp(-blend_smoothing * delta))
	right_hand.global_transform = lerp(hand_r_body.global_transform,hand_r_cam.global_transform, blend_right)
	
	# Left hand
	blend_left = lerp(blend_left, blend_target_left, 1.0 - exp(-blend_smoothing * delta))
	if blend_left < 0.01:
		wallet.visible = false
	else:
		wallet.visible = true
	left_hand.global_transform = lerp(hand_l_body.global_transform,hand_l_cam.global_transform, blend_left)
	
	#skeleton.call_deferred("force_update_all_bone_transforms")
	
func update_holding():
	# 1 get selected hotbar or not selected if -1
	# 2 Get scene from itemdb
	# 3 instansiate on hand
	# 4 disable physics
	# 5 animation stuff maybe elsewhere
	
	
	#print("item held: ", item_held, " item selected: ", hotbar[selected_item])
	
	# remove from hand
	if (item_held != hotbar[selected_item] and item_instance != null) or (selected_item == -1 and item_instance != null):
		#fprint("remove")
		item_instance.on_unequip(self)
		hand.remove_child(item_instance)
		item_instance.queue_free()
		item_instance = null
		item_held = ""
		set_hand_grip(0)
	
	# instantiate on hand
	if selected_item != -1 and hotbar[selected_item] != "" and hotbar[selected_item] != item_held:
		var item = hotbar[selected_item]
		var item_resource = load(ItemDB.get_scene(item))
		item_instance = item_resource.instantiate()
		
		hand.add_child(item_instance)
		item_instance.set_owner(hand)
		#item_instance.global_position = hand.global_position
		set_hand_grip(ItemDB.get_grip(item))
		item_instance.rotation = ItemDB.get_grip_rot(item)
		item_instance.position = ItemDB.get_grip_pos(item)

		item_instance.freeze = true
		item_instance.scale = Vector3.ONE / scale
		#print(item_instance.scale)
		
		item_instance.on_equip(self)
		
		var children = item_instance.get_children()
		
		for child in children:
			if child is not MeshInstance3D: # might have too look through this if doing advanced item stuff
				
				item_instance.remove_child(child)
				child.queue_free()
		#print(item_instance.get_children())
		
		item_held = hotbar[selected_item]

func update_hotbar():
	update_holding()
	for i in range(4):
		if hotbar[i]:
			player_slots_rect[i].texture = load(ItemDB.get_icon(hotbar[i]))
		else:
			player_slots_rect[i].texture = null

func set_hand_grip(grip_factor : float): # 1 = closed, 0 = open
	for i in range(bone_idx.size()):
		var rot : Quaternion = R_finger_data["open"][bone_names[i]].slerp(R_finger_data["close"][bone_names[i]], grip_factor)
		#print(rot)
		skeleton.set_bone_pose_rotation(bone_idx[i], rot)
