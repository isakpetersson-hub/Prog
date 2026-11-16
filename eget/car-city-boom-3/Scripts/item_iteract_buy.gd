extends Interactable

var price = 0

func interact(interactor):
	if GameManager.buy(price):
		if interactor.pickup(name.split(" ")[0]):
			get_parent().get_parent().item_bought(get_parent())
			get_parent().queue_free()
		else: 
			GameManager.sell(price) # goofy ahh, but it is more anoying to revert item pickup
