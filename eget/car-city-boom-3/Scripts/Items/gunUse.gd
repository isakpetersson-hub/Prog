extends RigidBody3D

func on_equip(player : CharacterBody3D):
	AudioManager.play_location("gun_equip", global_position)
	
func on_unequip(player : CharacterBody3D):
	AudioManager.play_location("gun_unequip", global_position)

func on_right_hold(player : CharacterBody3D):
	pass
	
func on_right_press(player : CharacterBody3D):
	AudioManager.play_location("gun_aim", global_position)
	
func on_right_release(player : CharacterBody3D):
	AudioManager.play_location("gun_unaim", global_position)
	
func on_use(player : CharacterBody3D):
	print("shoot")
