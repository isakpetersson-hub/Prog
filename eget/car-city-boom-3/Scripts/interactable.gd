extends Area3D
class_name Interactable

signal interacted(interactor)

func interact(interactor):
	print("interacted with ", name)
	pass

func on_look_at():
	print("looking at itercactable ", name)
	pass

func on_look_away():
	print("looking away from itercactable ", name)
	pass
