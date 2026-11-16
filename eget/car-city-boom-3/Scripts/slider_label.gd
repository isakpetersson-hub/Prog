extends Label

@onready var slider : HSlider = $".."
@export var decimals : int = 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = "%.*f" % [decimals, slider.value] 
