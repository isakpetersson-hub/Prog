extends Interactable

func interact(interactor):
	var success = interactor.pickup(name.split(" ")[0])
	if success: get_parent().queue_free()
