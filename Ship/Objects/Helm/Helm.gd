class_name Helm extends InteractableShipPart

var controlled : bool = false

func init(_ship, _durability : float = 10, _mass : float = 1):
	super(_ship, _durability, _mass)

func _interact():
	if controlled:
		player_in_range.control_ship(null)
	else:
		player_in_range.control_ship(ship)
	controlled = !controlled

func _on_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("PlayerArea"):
		player_in_range = area.get_owner()
		player_in_range.hovering_controllables.append(self)
		interactable = true

func _on_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("PlayerArea"):
		player_in_range.hovering_controllables.erase(self)
		player_in_range = null
		interactable = false

