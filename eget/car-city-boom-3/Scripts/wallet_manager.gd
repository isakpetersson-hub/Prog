extends Node3D

@onready var money_label : Label = $CCB3wallet/Armature/Skeleton3D/ModifierBoneTarget3D/money/SubViewport/Label

@onready var sub_viewport: SubViewport = $menu/SubViewport
@onready var collision_shape: CollisionShape3D = $StaticBody3D/CollisionShape3D
@onready var sprite : Sprite3D = $menu

@onready var debug : ColorRect = $menu/SubViewport/WalletMenu/screen/debug

@onready var anim : AnimationPlayer = $AnimationPlayer

var active : bool = false

@onready var player : CharacterBody3D = $"../../../../.."
@onready var car : VehicleBody3D

var menu_index : int = 0
# 0 : menu
# 1 : stats
# 2 : music player?
#~2~:~news~~
# 3 : console
# 4 : calc (short for calculator)
var menus : int = 5

@onready var menu_dict : Dictionary[int, Control] = { 
	0 : $menu/SubViewport/WalletMenu/screen/menu,
	1 : $menu/SubViewport/WalletMenu/screen/stats,
	2 : $menu/SubViewport/WalletMenu/screen/music,
	3 : $menu/SubViewport/WalletMenu/screen/console,
	4 : $menu/SubViewport/WalletMenu/screen/calc
}

@onready var mainP : Control = $menu/SubViewport/WalletMenu/screen/menu/main
@onready var optionsP : Control = $menu/SubViewport/WalletMenu/screen/menu/options
@onready var optionsBack : Button = $menu/SubViewport/WalletMenu/screen/menu/options/back

@onready var left : Button = $menu/SubViewport/WalletMenu/left
@onready var right : Button = $menu/SubViewport/WalletMenu/right

@onready var wallet_button_L : MeshInstance3D = $CCB3wallet/Armature/Skeleton3D/Bone/Circle_001
@onready var wallet_button_R : MeshInstance3D = $CCB3wallet/Armature/Skeleton3D/Bone/Circle

# Menu
@onready var pauseB : Button = $menu/SubViewport/WalletMenu/screen/menu/main/pause
var paused : bool = false
@onready var optionsB : Button = $menu/SubViewport/WalletMenu/screen/menu/main/options
@onready var exitB : Button = $menu/SubViewport/WalletMenu/screen/menu/main/exit
# Console
@onready var text_label : Label = $menu/SubViewport/WalletMenu/screen/console/commandLabel
const COMAND_PROMPT: String = ">"
var curr_comand: String = ""
var prev_comand_lines: Array[String] = ["h for help","","",""]
const MAX_LINES : int = 4
var traceback : int = 0 

# Calc
@onready var container = $menu/SubViewport/WalletMenu/screen/calc/GridContainer
@onready var display : Label = $menu/SubViewport/WalletMenu/screen/calc/result
var calc_buttons : Array = []
var expr : String = ""
var expression : Expression

# Comfirm
@onready var comfirm = $menu/SubViewport/WalletMenu/screen/yesno
@onready var questionLabel = $menu/SubViewport/WalletMenu/screen/yesno/Question
@onready var yesB = $menu/SubViewport/WalletMenu/screen/yesno/yes
@onready var noB = $menu/SubViewport/WalletMenu/screen/yesno/no

var music_list : Array
var music_index = 0
@onready var song_name = $menu/SubViewport/WalletMenu/screen/music/song_name
@onready var music_prev = $menu/SubViewport/WalletMenu/screen/music/VBoxContainer/prev
@onready var music_play = $menu/SubViewport/WalletMenu/screen/music/VBoxContainer/pause
@onready var music_stop = $menu/SubViewport/WalletMenu/screen/music/VBoxContainer/stop
@onready var music_next = $menu/SubViewport/WalletMenu/screen/music/VBoxContainer/next


func _process(delta: float) -> void:
	$menu/SubViewport/WalletMenu/screen/music/band_wheel.rotation += delta * 2
	$menu/SubViewport/WalletMenu/screen/music/band_wheel2.rotation += delta * 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	left.pressed.connect(prev_menu)
	right.pressed.connect(next_menu)
	
	#menu
	pauseB.pressed.connect(pause)
	optionsB.pressed.connect(options)
	exitB.pressed.connect(exit)
	optionsBack.pressed.connect(exitOptions)
	
	update_money()
	update_text()
	calc_buttons = container.get_children()
	calc_buttons.append($menu/SubViewport/WalletMenu/screen/calc/back)
	for button in calc_buttons:
		button.pressed.connect(calc_pressed.bind(button.text))
	car = GameManager.car
	
	for node in get_children():
		if node is Button:
			node.mouse_entered.connect()
	
	expression = Expression.new()
	
	music_next.pressed.connect(next_music)
	music_prev.pressed.connect(prev_music)
	music_play.pressed.connect(play_music)
	music_stop.pressed.connect(stop_music)
	music_list = AudioManager.get_all_music()
	song_name.text = music_list[music_index].split("/")[-1].split(".")[0]

func update_money():
	money_label.text = "b$ " + str(GameManager.get_money())


func next_menu():
	menu_dict[menu_index].visible = false
	menu_index += 1
	menu_index = menu_index % menus
	menu_dict[menu_index].visible = true
	
	move_wallet_button(false)
	

func prev_menu():
	menu_dict[menu_index].visible = false
	menu_index -= 1
	menu_index = (menu_index + menus) % menus
	menu_dict[menu_index].visible = true
	
	move_wallet_button(true)

func move_wallet_button(left_button : bool):
	AudioManager.play_location("wallet_button", global_position)
	
	var tween = create_tween()
	var button = wallet_button_R
	if left_button: button = wallet_button_L
	tween.tween_property(button, "position",Vector3(-0.025,button.position.y,button.position.z), 0.05) 
	tween.tween_property(button, "position",Vector3(-0.039,button.position.y,button.position.z), 0.05)
	#tween.tween_callback()

func pickup_wallet():
	update_money()
	update_text()
	anim.play("open")
	active = true
	
func putdown_wallet():
	active = false
	
func hover_sound():
	AudioManager.play_location("blip_select", global_position)

############
## 0 Menu ##
############
# Pause <-> resume
func pause():
	paused = !paused
	if paused:
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pauseB.text = "resume"
		pauseB.size.x = 28
		pauseB.position.x = 11.0
	else:
		get_tree().paused = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pauseB.text = "pause"
		pauseB.size.x = 22
		pauseB.position.x = 14.0

# Options <-> options menu
func options():
	mainP.visible = false
	optionsP.visible = true
	

func exitOptions():
	mainP.visible = true
	optionsP.visible = false

func exit():
	# Exit game <-> save game?
	get_tree().quit()

#############
## 1 Stats ##
#############



############
## 2 Music Player ##
############
func next_music():
	music_index += 1
	music_index = music_index % music_list.size()
	song_name.text = music_list[music_index]
	
	

func prev_music():
	music_index -= 1
	music_index = (music_index + music_list.size()) % music_list.size()
	song_name.text = music_list[music_index]
	
	
	
func play_music():
	AudioManager.change_music(music_list[music_index], 0.5)
	
func stop_music():
	AudioManager.stop_music()
	


###############
## 3 Console ##
###############
func update_text() -> void:
	var text: String = ""
	if prev_comand_lines.size() > MAX_LINES: # Max lines
		prev_comand_lines.pop_front()
	for comand_line in prev_comand_lines:
		text += comand_line + "\n"
	text += COMAND_PROMPT + curr_comand
	text_label.text = text

func write_cmd(text : String):
	prev_comand_lines.append(text)
	update_text()

func send_command() -> void:
	prev_comand_lines.append(COMAND_PROMPT + curr_comand)
	
	#split on space and use args
	var args : PackedStringArray = curr_comand.split(" ", false)
	
	match args[0]:
		"h": # help
			write_cmd("commands:")
			write_cmd("  save load tp")
			write_cmd("  gp sp cl    ")
		"save":
			GameManager.save_game()
			write_cmd("game Saved")
			update_text()
		"load":
			GameManager.load_game()
			write_cmd("loaded Save")
			update_text()
		"tp": # teleport
			#var valid = true
			if args.size() > 1 and args[1] == "-h":
				write_cmd("  tp car")
				write_cmd("  tp x z")
				write_cmd("  tp x y z")
				
			elif args.size() > 1 and args[1] == "car":
				player.position = car.position + Vector3(0,2,0)
			elif args.size() == 3: # x z
				player.position.x = float(args[1])
				player.position.z = float(args[2])
			elif args.size() == 4: # x y z
				player.position = Vector3(float(args[1]),float(args[2]),float(args[3]))
			else:
				write_cmd("bad args")
		"gp": # Get player pos
			var p = player.position
			write_cmd("%.0f %.0f %.0f" % [p.x, p.y, p.z])
		"sp": # Spawn
			if args.size() > 1 and args[1] == "-h":
				write_cmd("  sp item-id")
			elif args.size() > 1 and not args[1] == "-h":
				if ItemDB.exists(args[1]):
					var pos = -player.cam.global_basis.z * 0.5 + player.cam.global_position
				
					var item_resource = load(ItemDB.get_scene(args[1]))
					var item_instance = item_resource.instantiate()
					get_tree().root.add_child(item_instance)
					item_instance.position = pos
				else:
					write_cmd("no exist")
		"cl": # lowk broken but can do stuff
			if args.size() > 1 and args[1] == "-h":
				write_cmd("  cl obj.func(x)")
			elif args.size() > 1 and not args[1] == "-h":
				var full_arg = args[1].split(".",true,1)
				var function = full_arg[1].split("(")[0]
				var call_args = full_arg[1].split("(")[1].rstrip(")")
				print(call_args)
				var variant = null
				match full_arg[0]:
					"self":
						variant = self
					"car":
						variant = car
					"player":
						variant = player
				
				if not variant == null:
					var callable = Callable(variant, function)
					if call_args:
						callable.call(call_args)
					else:
						callable.call()
		"play":
			AudioManager.change_music(args[1], float(args[2]))

		"":
			pass
		
			
	curr_comand = ""
	update_text()

############
## 4 Calc ##
############
func calc_pressed(symbol : String):
	if(expr == "<null>" or expr == "inf"): expr = ""
	match symbol:
		"<":
			expr = expr.substr(0, expr.length() - 1)
			display.text = expr
		"=":
			expression.parse(expr.replace("x","*"))
			var res = str(expression.execute())
			display.text = res
			expr = res
		_:
			expr = expr + symbol
			display.text = expr


###########################################################################
## subViewport projection input forwarding raycast magic + Console input ##
###########################################################################
# FIX MOVEMENT TYPE BULLSHIT WTH 
func _input(event):
	if event is InputEventMouseButton or event is InputEventMouseMotion:
		var camera = get_viewport().get_camera_3d()
		var mouse_pos = get_viewport().get_mouse_position()

		var ray_origin = camera.project_ray_origin(mouse_pos)
		var ray_dir = camera.project_ray_normal(mouse_pos)

		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_origin + ray_dir * 10)
		var result = space_state.intersect_ray(query)

		if result and result.collider == $StaticBody3D:
			var local_pos = to_local(result.position)

			# Convert local 3D position to UV (0-1) based on sprite size
			var tex_size = sub_viewport.size
			var sprite_size = Vector2(sprite.texture.get_width(), sprite.texture.get_height()) * sprite.pixel_size * sprite.scale.x
			var uv = Vector2(
				(local_pos.x / sprite_size.x) + 1 + .16, # Dont ask, it works
				0.5 - (local_pos.y / sprite_size.y) - .03
			)
			var viewport_pos = uv * Vector2(tex_size)

			# Create and forward the event to the SubViewport
			var new_event = event.duplicate()
			if new_event is InputEventMouseButton or new_event is InputEventMouseMotion:
				new_event.position = viewport_pos
				new_event.global_position = viewport_pos
				debug.position = viewport_pos

			sub_viewport.push_input(new_event)
	
	# arrows to control buttons
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_LEFT:
			prev_menu()
		elif event.keycode == KEY_RIGHT:
			next_menu()
	
	# Handle console input
	if event is InputEventKey and event.is_pressed() and menu_index == 3 and active:
		var key: int = event.get_unicode()
		const ASCII_a: int = 97
		const ASCII_z: int = 122
		const ASCII_0: int = 48
		const ASCII_9: int = 57
		
		if (ASCII_a <= key and key <= ASCII_z) or (ASCII_0 <= key and key <= ASCII_9) or (33 <= key and key <= 47) or key == 95:
			AudioManager.play_location("keypress", global_position)
			curr_comand += char(key)
			traceback = 0
			update_text()
		elif event.keycode == KEY_SPACE:
			AudioManager.play_location("keypress", global_position)
			curr_comand += " "
			traceback = 0
			update_text()
		elif event.keycode == KEY_BACKSPACE:
			AudioManager.play_location("keypress", global_position)
			curr_comand = curr_comand.substr(0, curr_comand.length() - 1)
			traceback = 0
			update_text()
			
		# handle up and down arrows
		elif event.keycode == KEY_UP:
			if traceback < MAX_LINES:
				traceback += 1
			while (not prev_comand_lines[-traceback].contains(">")) and traceback < MAX_LINES:
				traceback += 1
			if (not prev_comand_lines[-traceback].contains(">")):
				traceback -= 1
			curr_comand = prev_comand_lines[-traceback].substr(1)
			update_text()
		elif event.keycode == KEY_DOWN:
			if traceback > 0:
				traceback -= 1
			while (not prev_comand_lines[-traceback].contains(">")) and traceback > 0:
				traceback -= 1
			if traceback == 0:
				curr_comand = ""
			else:
				curr_comand = prev_comand_lines[-traceback].substr(1)
			update_text()
		
		elif event.keycode == KEY_ENTER:
			send_command()
