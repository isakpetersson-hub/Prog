extends Sprite3D

var FRAMES : int = 16

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#billboard = BaseMaterial3D.BILLBOARD_FIXED_Y 
	alpha_cut = SpriteBase3D.ALPHA_CUT_OPAQUE_PREPASS  # avoids transparency sorting issues
	texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var cam := get_viewport().get_camera_3d()
	if cam == null:
		return
	
	var to_cam := cam.global_position - global_position
	var angle := atan2(to_cam.x, to_cam.z)
	var step := TAU / FRAMES
	
	rotation.y = angle
	frame = posmod(int(round(angle / step)), FRAMES)
	#print(frame)
	if frame < 0:
		frame += FRAMES
	
