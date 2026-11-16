@tool
extends EditorPlugin

var adjust_grip_btn: Button

var create_item_btn: Button
var item_popup: Window
var item_id: LineEdit
var item_name: LineEdit
var item_value: SpinBox
var item_weight: SpinBox
var item_type: OptionButton
var grip_factor : SpinBox

var model_select_btn: Button
var texture_select_btn: Button

var create_btn: Button
var cancel_btn: Button

var model_label: Label
var texture_label: Label

var texturePath
var modelPath

# ---------------

var regenerate_btn: Button

# ---------------

var add_sound_btn : Button


func _enter_tree():
	# Initialization of the plugin goes here.
	adjust_grip_btn = Button.new()
	adjust_grip_btn.text = "Adjust Grip"
	adjust_grip_btn.pressed.connect(_on_gripadjust)
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, adjust_grip_btn)
	
	create_item_btn = Button.new()
	create_item_btn.text = "Add Item"
	create_item_btn.pressed.connect(_show_popup_window)
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, create_item_btn)
	
	add_sound_btn = Button.new()
	add_sound_btn.text = "Add Sound"
	add_sound_btn.pressed.connect(_on_add_sound)
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, add_sound_btn)
	
	_create_popup_windows()
	
	regenerate_btn = Button.new()
	regenerate_btn.text = "Rerender Items"
	regenerate_btn.pressed.connect(_on_rerender)
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, regenerate_btn)
	
	
	
func _exit_tree():
	if adjust_grip_btn:
		remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, adjust_grip_btn)
		adjust_grip_btn.queue_free()
	
	if create_item_btn:
		remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, create_item_btn)
		create_item_btn.queue_free()
		
	if regenerate_btn:
		remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, regenerate_btn)
		regenerate_btn.queue_free()
	
	if item_popup:
		item_popup.queue_free()

# --- Rerender Icons ---
func _on_rerender():
	get_editor_interface().open_scene_from_path("res://Scenes/Utility/icon_creater.tscn")
		
	call_deferred("_run_current_scene_deferred")

# --- Add Sound ---
func _on_add_sound():
	get_editor_interface().open_scene_from_path("res://Scenes/audio_manager.tscn")
		
	call_deferred("_run_current_scene_deferred")




# --- Ajust Grip ---
func _on_gripadjust():
	get_editor_interface().open_scene_from_path("res://Scenes/Utility/grip_adjust.tscn")
		
	# Small delay to ensure scene is loaded, then run it
	call_deferred("_run_current_scene_deferred")

func _run_current_scene_deferred():
	get_editor_interface().play_current_scene()
	print("Running scene")

func _create_popup_windows():
	item_popup = Window.new()
	item_popup.title = "CCB3 Item Wizard"
	item_popup.size = Vector2i(400,300)
	item_popup.wrap_controls = true
	item_popup.close_requested.connect(_on_popup_close)
	
	# Create VBoxContainer for layout
	var vbox = VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	item_popup.add_child(vbox)
	
	#var bg_color = ColorRect.new()
	#bg_color.color = Color.WHITE
	#bg_color.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	#bg_color.size_flags_vertical = Control.SIZE_EXPAND_FILL
	#
	#vbox.add_child(bg_color)
	
	# Create grid with 2 cols
	var grid = GridContainer.new()
	grid.columns = 2
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.add_child(grid)

	# --- ITEM ID ---
	var id_label = Label.new()
	id_label.text = "Item ID: "
	grid.add_child(id_label)
	
	item_id = LineEdit.new()
	item_id.placeholder_text = "Enter item id"
	grid.add_child(item_id)
	
	# --- ITEM NAME ---
	var name_label = Label.new()
	name_label.text = "Item Name: "
	grid.add_child(name_label)
	
	item_name = LineEdit.new()
	item_name.placeholder_text = "Enter item name"
	grid.add_child(item_name)
	
	# --- ITEM VALUE ---
	var value_label = Label.new()
	value_label.text = "Item Value: "
	grid.add_child(value_label)
	
	item_value = SpinBox.new()
	item_value.value = 10
	item_value.step = 1
	grid.add_child(item_value)
	
	# --- ITEM WEIGHT
	var weight_label = Label.new()
	weight_label.text = "Item Weight: "
	grid.add_child(weight_label)
	
	item_weight = SpinBox.new()
	item_weight.value = 1
	item_weight.step = 0.1
	grid.add_child(item_weight)
	
	# --- ITEM TYPE ---
	var type_label = Label.new()
	type_label.text = "Item Type: "
	grid.add_child(type_label)
	
	item_type = OptionButton.new()
	item_type.add_item("consume", 0)
	item_type.add_item("gadget", 1)
	item_type.add_item("relic", 2)
	item_type.add_item("Key Item", 4)
	grid.add_child(item_type)
	
	# --- Grip factor
	#var grip_label = Label.new()
	#grip_label.text = "Grip Factor: "
	#grid.add_child(grip_label)
	#
	#grip_factor = SpinBox.new()
	#grip_factor.value = 0.5
	#grip_factor.step = 0.01
	#grid.add_child(grip_factor)
	
	# --- MODEL ---
	model_select_btn = Button.new()
	model_select_btn.text = "Load 3D Model"
	grid.add_child(model_select_btn)
	
	var model_file_dialog = EditorFileDialog.new()
	model_file_dialog.file_mode = EditorFileDialog.FILE_MODE_OPEN_FILE
	model_file_dialog.access = EditorFileDialog.ACCESS_RESOURCES
	model_file_dialog.add_filter("*.obj, *.glb, *.gltf ; 3D Files")
	model_file_dialog.file_selected.connect(_on_model_selected)
	
	get_editor_interface().get_base_control().add_child(model_file_dialog)
	model_select_btn.pressed.connect(model_file_dialog.popup_centered)
	
	model_label = Label.new()
	model_label.text = "No file loaded"
	grid.add_child(model_label)
	
	# --- TEXTURE ---
	texture_select_btn = Button.new()
	texture_select_btn.text = "Load Texture"
	grid.add_child(texture_select_btn)
	
	var tex_file_dialog = EditorFileDialog.new()
	tex_file_dialog.file_mode = EditorFileDialog.FILE_MODE_OPEN_FILE
	tex_file_dialog.access = EditorFileDialog.ACCESS_RESOURCES
	tex_file_dialog.add_filter("*.png, *.jpg, *.jpeg, *.webp ; Image Files")
	tex_file_dialog.file_selected.connect(_on_texture_selected)
	
	get_editor_interface().get_base_control().add_child(tex_file_dialog)
	texture_select_btn.pressed.connect(tex_file_dialog.popup_centered)
	
	texture_label = Label.new()
	texture_label.text = "No file loaded"
	grid.add_child(texture_label)
	
	# -----------------------------------------------------
	# Button container
	var button_hbox = HBoxContainer.new()
	button_hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button_hbox.alignment = BoxContainer.ALIGNMENT_END
	vbox.add_child(button_hbox)

	# CREATE BUTTON
	create_btn = Button.new()
	create_btn.text = "Create"
	button_hbox.add_child(create_btn)
	create_btn.pressed.connect(_on_create_item)
	
	# CANCEL BUTTON
	cancel_btn = Button.new()
	cancel_btn.text = "Cancel"
	cancel_btn.pressed.connect(_on_popup_close)
	button_hbox.add_child(cancel_btn)
	
	
	# Add to editor
	get_editor_interface().get_base_control().add_child(item_popup)
	item_popup.hide()

func _show_popup_window():
	# Reset form
	item_id.text = ""
	item_name.text = ""
	item_value.value = 10
	item_weight.value = 1
	item_type.selected = 0
	model_label.text = "No file loaded"
	texture_label.text = "No file loaded"
	
	# Center and show popup
	#var viewport_size = get_editor_interface().get_base_control().size
#	item_popup.position = (viewport_size - item_popup.size) / 2
	item_popup.position = Vector2i(100,100)
	item_popup.popup_centered()
	
func _on_popup_close():
	item_popup.hide()
	


func _on_model_selected(path: String):
	var model = load(path)
	if model is Mesh:
		modelPath = path
		model_label.text = path
		print("Model loaded: ", path)
		# Store or use the texture variable for your item
		
func _on_texture_selected(path: String):
	var tex = load(path)
	if tex is Texture2D:
		texturePath = path
		texture_label.text = path
		print("Texture loaded: ", path)
		# Store or use the texture variable for your item

# -------- ITEM CREATION ---------------------------------------------------------------------------

func _on_create_item():
	print ("creating item...")
	var id = item_id.text
	var name = item_name.text
	var value = item_value.value
	var weight = item_weight.value
	var type = item_type.get_item_text(item_type.selected)
	#var grip = grip_factor.value
	
	# ----- Create item Scene -----
	# Create root, rigidbody3D with correct weight, name collision layer
	var root: RigidBody3D = RigidBody3D.new()
	root.name = id
	root.mass = weight
	root.collision_layer = 8 # bitmask 8
	root.collision_mask = 25 # bitmask 1 + 8 + 16
	
	# Item functionality script
	root.set_script("res://Scripts/Items/defaultUse.gd")
	
	# Add mesh
	var mesh_instance = MeshInstance3D.new()
	var item_mesh = load(modelPath)
	mesh_instance.mesh = item_mesh
	mesh_instance.name = id + "_mesh_instance3D"
	root.add_child(mesh_instance)
	mesh_instance.set_owner(root)
	
	# Add collison shape (convex hull)
	var collision: CollisionShape3D = CollisionShape3D.new()
	var shape = mesh_instance.mesh.create_convex_shape()
	collision.shape = shape
	collision.name = id + "_collision3D"
	root.add_child(collision)
	collision.set_owner(root)
	
	# Set material
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_texture = load(texturePath)
	material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	mesh_instance.material_override = material
	
	# Add Iteract Stuff
	var interact_area: Area3D = Area3D.new()
	interact_area.name = id
	interact_area.set_script(load("res://Scripts/item_interact.gd"))
	interact_area.collision_layer = 2
	interact_area.collision_mask = 2
	root.add_child(interact_area)
	interact_area.set_owner(root)
	
	var interact_collision: CollisionShape3D = CollisionShape3D.new()
	interact_collision.name = id + "_collosion3D"
	interact_collision.scale = 1.2 * Vector3.ONE
	interact_collision.shape = shape
	interact_area.add_child(interact_collision)
	interact_collision.set_owner(root)
	
	
	
	# Save scene
	var scene = PackedScene.new()
	var result = scene.pack(root)
	
	if result == OK:
		var save_path = "res://Items/Scenes/"+id+".tscn"
		ResourceSaver.save(scene, save_path)
		print("Scene saved to: ", save_path)
		
		# Refresh the FileSystem dock
		get_editor_interface().get_resource_filesystem().scan()
		
	
	root.queue_free()
	
	# ----- Create Icon Scene -----
	# Create Root, set properties
	var icon_root: SubViewport = SubViewport.new()
	icon_root.size = Vector2(32,32)
	icon_root.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	icon_root.transparent_bg = true
	icon_root.name = id
	
	# Create and parent camera
	var cam: Camera3D = Camera3D.new()
	cam.current = true
	cam.fov = 27.4
	cam.position = Vector3(0, 0, 0.293)
	icon_root.add_child(cam)
	cam.set_owner(icon_root)
	
	var item_scene = load("res://Items/Scenes/"+id+".tscn")
	if item_scene and item_scene is PackedScene:
		var inst_item = item_scene.instantiate()
		
		icon_root.add_child(inst_item)
		inst_item.set_owner(icon_root)
		
	scene = PackedScene.new()
	result = scene.pack(icon_root)
	
	if result == OK:
		var save_path = "res://Items/Scenes/Icon_scenes/"+id+"_icon_scene.tscn"
		ResourceSaver.save(scene, save_path)
		print("Scene saved to: ", save_path)
		
		# Refresh the FileSystem dock
		get_editor_interface().get_resource_filesystem().scan()
		
	icon_root.queue_free()
	
	# ----- Load Json -----
	const JSON_PATH = "res://Data/items.json"
	var file = FileAccess.open(JSON_PATH, FileAccess.READ)
	var items
	if file:
		var json = JSON.new()
		json.parse(file.get_as_text())
		items = json.get_data()
	
	# ----- Add To Json -----
	var new_item: Dictionary
	new_item["id"] = id
	new_item["name"] = name
	new_item["type"] = type
	new_item["value"] = value
	new_item["weight"] = weight
	
	new_item["icon"] = id + ".png"
	new_item["scene"] = id + ".tscn"
	new_item["hold_anim"] = "default"
	new_item["rmb_anim"] = "enabled"
	new_item["use_anim"] = "enabled"
	
	new_item["grip"] = 0.5
	var grip_pos : Dictionary = {}
	var grip_rot : Dictionary = {}
	grip_pos["x"] = 0.0
	grip_pos["y"] = 0.0
	grip_pos["z"] = 0.0
	grip_rot["x"] = 0.0
	grip_rot["y"] = 0.0
	grip_rot["z"] = 0.0
	
	new_item["grip_pos"] = grip_pos
	new_item["grip_rot"] = grip_rot
	
	var stats: Dictionary
	
	match type:
		"consume":
			stats["speed"] = 1
			stats["jump"] = 1
		"gadget":
			stats["damage"] = 1
		"relic":
			pass
		"Key Item":
			pass
			
	new_item["stats"] = stats
	
	items[id] = new_item
	print(new_item)

	
	# ----- Save Json -----
	var json_string = JSON.stringify(items, "\t")
	#print(json_string)
	var file2 = FileAccess.open(JSON_PATH, FileAccess.WRITE)
	file2.store_string(json_string)
	file2.close()
	print("Added item to JSON")
	
	# Refresh the FileSystem dock
	get_editor_interface().get_resource_filesystem().scan()
	
	print("Done generating item files")
	
