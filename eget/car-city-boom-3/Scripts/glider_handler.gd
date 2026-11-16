extends Node

var car: VehicleBody3D

const MAX_SPEED = 100.0
const MIN_SPEED = 10.0

var max_pitch_angle = 75
var roll_angle = 20

var pitch = 0
var roll = 0

var fwd
# Inputs
var pitch_input = 0
var roll_input = 0

var current_speed = 0

var last_active = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_speed = MIN_SPEED
	car = $".."

func _physics_process(delta: float) -> void:
	if car.glider_active:
		if last_active == false:
			last_active = true
			current_speed = 0
		handle_input()
		handle_physics(delta)
	else:
		last_active = false
	
func handle_input():
	pitch_input = Input.get_axis("forward", "back")
	roll_input = Input.get_axis("right", "left")
	
func handle_physics(delta: float):
	fwd = car.basis.z
	
	car.rotate_object_local(car.get_child(0).basis.x, pitch_input * delta)
	car.rotate_object_local(car.get_child(0).basis.z, roll_input * delta)
	
	var current_acceleration = -fwd.dot(Vector3.UP)
	current_speed += current_acceleration
	print (current_acceleration)
	print (current_speed)
	current_speed = clamp(current_speed, MIN_SPEED, MAX_SPEED)
	
	#car.apply_central_force(fwd * current_speed*10)
	car.position += fwd * current_speed * delta
	#car.linear_velocity.y = _GRAVITY * 10 * delta		
	#print(car.linear_velocity)
	#print(current_speed)
