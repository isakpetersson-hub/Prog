extends Node3D



func _ready() -> void:
	get_tree().paused = true
	
	var dir := DirAccess.open("res://Items/Scenes/Icon_scenes/")
	if dir == null: printerr("Could not open folder"); return
	dir.list_dir_begin()
	for file: String in dir.get_files():
		var item_resource := load(dir.get_current_dir() + "/" + file)
		var item_instance = item_resource.instantiate()
		
		add_child(item_instance)
		_generate_icon(item_instance)
		
		await get_tree().create_timer(0.1).timeout
		remove_child(item_instance)
		#remove_child(item_instance)
		#print(resource)
	
	get_tree().quit()
	
	
	
	

func _generate_icon(item_inst):
	for child in get_children():
		if child is SubViewport:
			await RenderingServer.frame_post_draw
			var img = child.get_texture().get_image()
			img.save_png("res://Items/Icons/" + child.name + ".png")
			print("Saved: res://Items/Icons/" + child.name + ".png")
			
