extends Control

@onready var label: Label = $Label
#@onready var anim: AnimationPlayer = $AnimationPlayer
var tween: Tween


func play(text: String, screen_size: Vector2, value : float):
	label.text = text
	value = clampf(value,0,1)
	label.add_theme_color_override("font_color", Color(1,1-value,1-value))

	# Random position (keep it on screen)
	var margin := 200
	position = Vector2(
		randf_range(margin, screen_size.x - margin),
		randf_range(margin, screen_size.y - margin)
	)
	
	# Harald tween code 🤫🧏‍♂️
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	tween.tween_property(label, "scale", Vector2(1+1*value,1+1*value), 0.6)
	tween.tween_callback(queue_free)
	
	# Rasmus goofy ahh animation code
	#anim.speed_scale = 1
	#anim.play("pop_in")

	#await get_tree().create_timer(1.0).timeout
	
	#anim.speed_scale = 0.5
	#anim.play("fade_out")

	#await anim.animation_finished
	#queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
