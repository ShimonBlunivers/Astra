class_name InteractableShipPart extends ShipPart

var interactable = false

var player_in_range = null


func init(_ship, _coords : Vector2i, _durability : float = 10, _mass : float = 1):
	super(_ship, _coords, _durability, _mass)


func interact():
	if interactable: _interact()

func _interact(): # VIRTUAL METHOD
	pass
