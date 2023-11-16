class_name InteractableShipPart extends ShipPart

var interactable = false

func interact():
    if interactable: _interact()

func _interact(): # VIRTUAL METHOD
    pass