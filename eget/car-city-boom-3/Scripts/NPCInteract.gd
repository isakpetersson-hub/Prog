extends Interactable
@onready var dialouge = $"../Label3D"
@export var character : String

var dialouges : Array[String]

func _ready() -> void:
	const JSON_PATH = "res://Data/npc.json"
	var file = FileAccess.open(JSON_PATH, FileAccess.READ)
	var npc_data
	if file:
		var json = JSON.new()
		json.parse(file.get_as_text())
		npc_data = json.get_data()
	
	dialouge.text = $"..".name

func interact(interactor):
	pass
