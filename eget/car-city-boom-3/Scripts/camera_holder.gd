extends Node3D

var camOffset = Vector3(0, 2, -4)
var camAngle = -PI/32
var tiltAngle = PI/4

var SENSITIVITY = 0.002

@onready var cam = $camera
@export var target: Node3D

@export var position_smoothness: float = 100.0
@export var rotation_smoothness: float = 6.0

var last_rotation_y = 0.0
var mouse_tilt = Vector2.ZERO
var mouse_delta = Vector2.ZERO
var angle = 0

var recenter_timer = 2.5
var recenter_time = 0

func _ready() -> void:
	cam.position = camOffset
	cam.rotation.x = camAngle
	if target:
		global_position = target.global_position

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_delta += event.relative

func _process(delta: float) -> void:
	if not target:
		return
	

	global_position = target.position
	
	# Rotation
	
	
	var velocity = Vector2(target.linear_velocity.x, target.linear_velocity.z)
	
	mouse_tilt.x += mouse_delta.x * SENSITIVITY
	mouse_tilt.y += mouse_delta.y * SENSITIVITY
	
	mouse_tilt.x = clamp(mouse_tilt.x, -tiltAngle,tiltAngle)
	mouse_tilt.y = clamp(mouse_tilt.y, -tiltAngle,tiltAngle)
	
	if mouse_delta != Vector2.ZERO:
		recenter_time = recenter_timer
	mouse_delta = Vector2.ZERO
		
	if recenter_time > 0:
		recenter_time -= delta
	else:
		mouse_tilt = lerp(mouse_tilt, Vector2.ZERO, 1.0 - exp(-1 * delta))
	
	
	#
	
	if velocity.length() > 0.1:
		angle = velocity.angle()
	last_rotation_y = -angle + PI/2 - mouse_tilt.x
	
	# Always apply smooth rotation
	var rotation_weight = 1.0 - exp(-rotation_smoothness * delta)
	rotation.y = lerp_angle(rotation.y, last_rotation_y, rotation_weight)
	rotation.x = lerp_angle(rotation.x, camAngle + mouse_tilt.y, rotation_weight)
