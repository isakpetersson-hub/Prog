extends CanvasLayer

@export var trick_text_scene: PackedScene

func show_trick(text: String, value : float):
	var trick = trick_text_scene.instantiate()
	add_child(trick)

	trick.play(text, get_viewport().get_visible_rect().size, value)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
