extends VehicleBody3D

var handling: Dictionary

var engineForce
var driftEngineForce
var brakeForce
var maxRPM
var jump_force = 3000
var jump_rotation_force = 1300
var air_rotation_force = 2000

func _ready():
	#handling = load_handling("res://Data/car_data.json")
	handling = load_handling("res://Data/initial_unity.json")
	mass = handling.mass
	center_of_mass = Vector3(handling.center_of_mass[0], handling.center_of_mass[1], handling.center_of_mass[2])
	
	engineForce = handling.engine_force
	driftEngineForce = handling.drift_engine_force
	brakeForce = handling.brake_force
	maxRPM = handling.max_rpm



func _physics_process(delta: float) -> void:
	print(is_gounded_wheels())
			
	steering = lerp(steering, Input.get_axis("right", "left") * lerp(PI/4, PI/7, clamp(linear_velocity.length() / 50.0, 0, 1)), 5*delta)
	
	var force = engineForce
	if is_drifting():
		force = driftEngineForce
	engine_force = Input.get_axis("back","forward") * force * (1.0 - get_rpm() / maxRPM)
	
	print(1.0 - get_rpm() / maxRPM)
	
	if Input.is_action_pressed("brake"):
		$bl.brake = brakeForce
		$br.brake = brakeForce
		engine_force = 0
	else:
		$bl.brake = 0
		$br.brake = 0
		
	if !is_gounded_wheels():
		apply_torque(transform.basis.x * Input.get_axis("back", "forward") * air_rotation_force 
				   + transform.basis.z * Input.get_axis("left", "right") * air_rotation_force 
				   + transform.basis.y * Input.get_axis("turnR", "turnL") * air_rotation_force)

	if Input.is_action_just_pressed("jump"):
		if(is_gounded_wheels()):
			apply_central_impulse(transform.basis.y * jump_force)
			
	if Input.is_action_just_pressed("kickflipL"):
		if(is_gounded_wheels()):
			apply_central_impulse(transform.basis.y * jump_force)
			apply_torque_impulse(transform.basis.z * -jump_rotation_force)

	if Input.is_action_just_pressed("kickflipR"):
		if(is_gounded_wheels()):
			apply_central_impulse(transform.basis.y * jump_force)
			apply_torque_impulse(transform.basis.z * jump_rotation_force)
			
	#var lateral = transform.basis.x.dot(linear_velocity)
	#linear_velocity -= transform.basis.x * lateral * 0.015

# check of any wheel is touching the ground
func is_gounded_wheels() -> bool:
	if   $fl.is_in_contact(): return true
	elif $fr.is_in_contact(): return true
	elif $bl.is_in_contact(): return true
	elif $br.is_in_contact(): return true
	else: return false
	
# check if any part of the car is touching the ground
func is_grounded():
	if is_gounded_wheels(): return true
	elif get_contact_count() == 0: # Not working
		print("collision")
		return true
		
# Current status NOT WORKING
func check_backflip() -> int: # check only "one direction" of degrees
	var flip_counter = 0
	var flip_counter2 = 0
	
	if rotation.z > flip_counter:
		flip_counter2 += rotation.z - flip_counter
		flip_counter = rotation.z
	if flip_counter2 >= 360:
		flip_counter2 = 0
		return 1
	else: return 0






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
