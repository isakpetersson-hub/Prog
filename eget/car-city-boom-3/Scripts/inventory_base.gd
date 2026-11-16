extends Node3D
class_name Inventory

var inv_cam: Camera3D
var hotbar_rects : Array[TextureRect]
var hotbar = ["","","",""]
var active: bool

func set_cam(cam: Camera3D):
	inv_cam = cam
	
func set_hotbar_rects(r1,r2,r3,r4):
	hotbar_rects = [r1,r2,r3,r4]
	
func set_hotbar(hb: Array[String]):
	hotbar = hb
	
func set_active():
	active = true
	
func set_inactive():
	active = false


func drop(index) -> String:
	var item = ""
	if hotbar[index] != "":
		item = hotbar[index]
		hotbar[index] = ""
		update_hotbar()
	return item
	
func pickup(index, item):
	hotbar[index] = item
	update_hotbar()



func get_mouse_xz_position(screen_pos: Vector2, hover_pos: Vector3) -> Vector3:
	var from = inv_cam.project_ray_origin(screen_pos)
	var dir = inv_cam.project_ray_normal(screen_pos)
	
	# Create horizontal plane at specified height
	var plane = Plane(Vector3(0, 1, 0), hover_pos.y)
	var intersection = plane.intersects_ray(from, dir)
	
	if intersection:
		return Vector3(intersection.x, hover_pos.y, intersection.z)
	
	return Vector3.ZERO

# Casts a ray from the camera, only collides with items
func raycast(event: InputEventMouse, space_state: PhysicsDirectSpaceState3D):
	var ray_origin = inv_cam.project_ray_origin(event.position)
	var ray_end = ray_origin + inv_cam.project_ray_normal(event.position) * 1000
	
	#var space_state = get_world_3d().direct_space_state # huh, what
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	
	query.collision_mask = 8

	return space_state.intersect_ray(query)
	

func update_hotbar():
		for i in range(4):
		#print(ItemDB.get_icon(player_hotbar[i]))
		#print(player_slots_rect[i])
			if hotbar[i] != "":
				if (ResourceLoader.exists(ItemDB.get_icon(hotbar[i]))):
					
					hotbar_rects[i].texture = load(ItemDB.get_icon(hotbar[i]))
				else:
					hotbar_rects[i].texture = load("res://Items/Icons/missing.png")
					
			else:
				hotbar_rects[i].texture = null 		
