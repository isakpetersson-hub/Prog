extends Interactable

@onready var car = $".."

func interact(interactor):
	#find_parent("CarPlayerManager")
	car._enter_car()
