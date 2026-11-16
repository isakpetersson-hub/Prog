extends Skeleton3D

const JSON_PATH = "res://Data/bone_grip_data.json"
var items : Dictionary = {}
var first_frame = false
var bone_names = ["Rindex1","Rindex2","Rindex3","Rmiddle1","Rmiddle2","Rmiddle3",
				  "Rpinky1","Rpinky2","Rpinky3","Rring1","Rring2","Rring3","Rthumb1","Rthumb2"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#print(get_bone_count())
	#print(get_bone_name(0))
	#print(get_bone_pose_rotation(0))
	
	var file_in = FileAccess.open(JSON_PATH, FileAccess.READ)
	if file_in:
		var json = JSON.new()
		json.parse(file_in.get_as_text())
		items = json.get_data()
	
	var frame_data : Dictionary = {}
	for i in range(get_bone_count()):
		if get_bone_name(i) in bone_names:
			frame_data[get_bone_name(i)] = get_bone_pose_rotation(i)
	
		
	if first_frame:
		items["open"] = frame_data
		print("saved first frame")
	else:
		items["close"] = frame_data
		print("saved second frame")
	
	var json_string = JSON.stringify(items, "\t")
	#print(json_string)
	var file = FileAccess.open(JSON_PATH, FileAccess.WRITE)
	file.store_string(json_string)
	file.close()
