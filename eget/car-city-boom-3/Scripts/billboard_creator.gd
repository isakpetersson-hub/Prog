extends Node3D

@onready var file_dialog : FileDialog = $margin/container/FileDialog
@onready var path_label = $margin/container/scene_path
@onready var id_input = $margin/container/id_input

var current_scene = ""
var instance

var CELL_SIZE = Vector2(256,256)
var FRAMES : float = 16.0

@onready var viewport = $SubViewport
@onready var light = $SubViewport/lightHolder

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$margin/container/load.pressed.connect(func(): file_dialog.popup_centered(Vector2i(600, 400)))
	file_dialog.files_selected.connect(files_selected)
	$margin/container/generate.pressed.connect(generate)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func get_scene_aabb(node: Node) -> AABB:
	var combined_aabb: AABB
	var first_valid = false
	# Find all MeshInstance3D descendants in the scene/node tree
	for child in node.find_children("", "MeshInstance3D", true, false):
		if child is MeshInstance3D and child.mesh != null:
			# Get local AABB from the Mesh and transform it to global/world space
			var local_aabb = child.get_aabb()
			var global_aabb = child.global_transform * local_aabb
			
			if not first_valid:
				combined_aabb = global_aabb
				first_valid = true
			else:
				combined_aabb = combined_aabb.merge(global_aabb)
	return combined_aabb


func files_selected(paths: PackedStringArray) -> void:
	var path = paths[0]
	print(path)
	current_scene = path
	path_label.text = current_scene
	
	if instance:
		instance.queue_free()
	
	instance = (load(current_scene)).instantiate()
	add_child(instance)
	
	var aabb = get_scene_aabb(instance)
	print(aabb)
	
	instance.position.z = -3 * max(aabb.size.x, max(aabb.size.y, aabb.size.z))
	instance.position -= aabb.position + (aabb.size / 2)
	print( aabb.position + (aabb.size / 2))
	
func generate():
	var atlas := Image.create(CELL_SIZE.x * FRAMES, CELL_SIZE.y, false, Image.FORMAT_RGBA8)
	
	for i in range(FRAMES):
		var a := -TAU * i / FRAMES            
		instance.rotation.y = a
		light.rotation.y = a       
		
		await get_tree().create_timer(0.1).timeout
		
		await RenderingServer.frame_post_draw
		await RenderingServer.frame_post_draw
		
		var img = viewport.get_texture().get_image()
		img.convert(Image.FORMAT_RGBA8)
		atlas.blit_rect(img, Rect2i(Vector2i.ZERO, CELL_SIZE), Vector2i(i * CELL_SIZE.x, 0))
		
		await get_tree().create_timer(0.1).timeout
	
	atlas.save_png("res://Billboards/" + id_input.text + ".png")
