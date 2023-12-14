class_name InteractableShipPart extends ShipPart

var interactable = false

var player_in_range = null

func interact():
	if interactable: _interact()

func _interact(): # VIRTUAL METHOD
	pass
