extends RigidBody3D

var handling: Dictionary

var engineForce
var driftEngineForce
var brakeForce
var maxRPM
var jump_force
var jump_rotation_force
var air_rotation_force

var alignment_strength = 200.0 # 200
var min_speed_for_alignment = 13.0




var glider_active = false
var disable_car = false

var player_scene = preload("res://Scenes/Player.tscn")
var player
#@onready var car = $"../CarM1V2"

var player_cam
@onready var car_cam = $"../cameraHolder/camera"

@onready var inventory = $Inventory
@onready var exitpos = $playerExitPos

@onready var boost = $CSGBox3D

#signal enter_car
#signal exit_car

var in_car = true


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#handling = load_handling("res://Data/car_data.json")
	handling = load_handling("res://Data/initial_unity.json")
	mass = handling.mass
	center_of_mass = Vector3(handling.center_of_mass[0], handling.center_of_mass[1], handling.center_of_mass[2])
	
	engineForce = handling.engine_force
	driftEngineForce = handling.drift_engine_force
	brakeForce = handling.brake_force
	maxRPM = handling.max_rpm
	
	jump_force = handling.jump_force
	jump_rotation_force = handling.jump_rotation_force
	air_rotation_force = handling.air_rotation_force


func _physics_process(delta: float) -> void:
	#print(clamp(linear_velocity.length() / 40.0, 0, 1))
	if !disable_car && !glider_active:
		var steerVal = Input.get_axis("right", "left") * lerp(PI/4, PI/12, clamp(linear_velocity.length() / 40.0, 0, 1))
		$fl.steering = lerp($fl.steering, steerVal, 5 * delta)
		$fr.steering = lerp($fr.steering, steerVal, 5 * delta)
		if Input.get_axis("right", "left") == 0 and is_any_wheel_grounded() and !is_drifting():
			apply_velocity_alignment_torque(delta)
			#angular_damp = 0.01
		else:
			#angular_damp = 0
			pass 

		var force = engineForce
		if is_drifting() and get_rpm() < 450:
			force = driftEngineForce
	
		var rpm_adjusted = Input.get_axis("back","forward") * force * (1.0 - get_rpm() / maxRPM)
		$bl.engine_force = rpm_adjusted
		$br.engine_force = rpm_adjusted

		if Input.is_action_pressed("brake"):
			$bl.brake = brakeForce
			$br.brake = brakeForce
			$bl.engine_force = 0
			$br.engine_force = 0
		else:
			$bl.brake = 0
			$br.brake = 0

		if !is_any_wheel_grounded():
			apply_torque(transform.basis.x * Input.get_axis("back", "forward") * air_rotation_force 
					   + transform.basis.z * Input.get_axis("left", "right") * air_rotation_force 
					   + transform.basis.y * Input.get_axis("turnR", "turnL") * air_rotation_force)

		# roll faster if on ground but upside down
		if is_grounded() and not is_any_wheel_grounded():
			apply_torque(transform.basis.z * Input.get_axis("left", "right") * air_rotation_force)
	else:
		$bl.brake = brakeForce
		$br.brake = brakeForce
		$bl.engine_force = 0
		$br.engine_force = 0

	if Input.is_action_just_pressed("jump") and !disable_car and !inventory.is_inventory_open and is_any_wheel_grounded():
		apply_central_impulse(transform.basis.y * jump_force)
	elif Input.is_action_just_pressed("alt_jump") and !disable_car and !inventory.is_inventory_open and is_any_wheel_grounded():
		if Input.get_axis("left", "right") < 0:
			apply_central_impulse(transform.basis.y * jump_force)
			apply_torque_impulse(transform.basis.z * -jump_rotation_force)
		elif Input.get_axis("left", "right") > 0:
			apply_central_impulse(transform.basis.y * jump_force)
			apply_torque_impulse(transform.basis.z * jump_rotation_force)
		#elif Input.get_axis("back", "forward") < 0:
		#	apply_central_impulse(transform.basis.y * jump_force)
		#	apply_torque_impulse(transform.basis.x * -jump_rotation_force)
		#elif Input.get_axis("back", "forward") > 0:
		#	apply_central_impulse(transform.basis.y * jump_force)
		#	apply_torque_impulse(transform.basis.x * jump_rotation_force)
		else:
			apply_central_impulse(transform.basis.y * jump_force)
			apply_central_impulse(transform.basis.y * jump_force)
			apply_central_impulse(transform.basis.y * jump_force)

	if Input.is_action_pressed("boost") and !disable_car:
		apply_central_force(transform.basis.z * 600)
		boost.visible = true
	else:
		boost.visible = false

	#if Input.is_action_just_pressed("kickflipL"):
	#	if(is_any_wheel_grounded()):
	#		apply_central_impulse(transform.basis.y * jump_force)
	#		apply_torque_impulse(transform.basis.z * -jump_rotation_force)
#
	#if Input.is_action_just_pressed("kickflipR"):
	#	if(is_any_wheel_grounded()):
	#		apply_central_impulse(transform.basis.y * jump_force)
	#		apply_torque_impulse(transform.basis.z * jump_rotation_force)
	#		
	if Input.is_action_just_pressed("gliderModeSwap"): # "gliderModeSwag"
		if !is_any_wheel_grounded():
			glider_active = !glider_active
		print(glider_active)
	if is_grounded() and glider_active:
		glider_active = false
		
	#if glider_active:
	#	freeze = true
	#else:
	#	freeze = false


func _process(delta: float) -> void:
	# Do nothing goonsquad
	return

# check of any wheel is touching the ground
func is_any_wheel_grounded() -> bool:
	if   $fl.is_in_contact(): return true
	elif $fr.is_in_contact(): return true
	elif $bl.is_in_contact(): return true
	elif $br.is_in_contact(): return true
	else: return false

func all_wheels_grounded() -> bool:
	return ($fl.is_in_contact() && $fr.is_in_contact() &&
	$bl.is_in_contact() && $br.is_in_contact())

# check if any part owf the car is touching the ground
func is_grounded():
	if is_any_wheel_grounded(): return true
	elif get_contact_count() != 0: # Maybe working
		return true
		
# Current status NOT WORKING

func get_rpm() -> float:
	return (abs($bl.get_rpm()) + abs($br.get_rpm())) / 2

# Loads a json file with car "stats"
func load_handling(path: String) -> Dictionary:
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var json_data = JSON.parse_string(file.get_as_text())
		if typeof(json_data) == TYPE_DICTIONARY:
			apply_handling(json_data)
			return json_data
		else:
			push_error("JSON invalid: %s" % path)
	var fakeDict = {"fake": "dict"} 
	return fakeDict

# sets variables and such
func apply_handling(data: Dictionary):
	for wheel in get_children():
		if wheel is VehicleWheel3D:
			var is_front = wheel.name.to_lower().contains("f")

			wheel.suspension_stiffness = data.suspension_stiffness
			wheel.damping_compression = data.damping_compression
			wheel.damping_relaxation = data.damping_relaxation
			wheel.suspension_travel = data.suspension_travel

			if is_front:
				wheel.wheel_friction_slip = data.front_friction
			else:
				wheel.wheel_friction_slip = data.rear_friction

func is_drifting() -> bool:
	var vel = linear_velocity
	var forward = transform.basis.z
	var right = transform.basis.x

	var forward_speed = abs(forward.dot(vel))
	var lateral_speed = abs(right.dot(vel))

	# Ratio of sideways movement
	var drift_ratio = lateral_speed / max(forward_speed, 0.1)

	return drift_ratio > 0.25   # 0.2-0.3 works well for arcade drifting
	
func apply_velocity_alignment_torque(delta: float):
	var speed = linear_velocity.length()
	
	if speed > min_speed_for_alignment:
		var current_forward = global_transform.basis.z
		var velocity_dir = linear_velocity.normalized()
		var cross_product = current_forward.cross(velocity_dir)
		var alignment_torque = cross_product * alignment_strength * speed
		
		# Apply torque around the Y axis (up vector)
		apply_torque(Vector3(0, alignment_torque.y, 0))
	

#func _on_car_player_manager_enter_car() -> void:
#	disable_car = false


#func _on_car_player_manager_exit_car() -> void:
#	disable_car = true
	
func is_player_in_car() -> bool:
	return !disable_car


func _enter_car():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#enter_car.emit()
	disable_car = false
	car_cam.current = true
	in_car = true
	if (player):
		inventory.set_hotbar(player.get_hotbar())
	if (player):
		get_tree().root.remove_child(player)
		player.queue_free()

func _exit_car():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#exit_car.emit()
	disable_car = true
	player = player_scene.instantiate()
	get_tree().root.add_child(player)
	player.position = exitpos.global_position
	player.rotation.y = rotation.y + PI
	player.velocity = linear_velocity
	player.set_hotbar(inventory.get_hotbar())
	car_cam.current = false

func _input(event: InputEvent) -> void:
	if (Input.is_action_just_pressed("interact")):
		if (in_car and !inventory.is_open()):
			_exit_car()
			in_car = !in_car




func _on_button_1_pressed() -> void:
	pass # Replace with function body.
