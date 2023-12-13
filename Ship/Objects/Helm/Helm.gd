class_name Helm extends InteractableShipPart

var controlled : bool = false

var player_in_range = null


func init(_ship, _durability : float = 10, _mass : float = 1):
	super(_ship, _durability, _mass)

# TODO: Rework how "interact" works. Create interactables in player and activate it throught player script.

func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("ui_control")) && interactable: interact()


func _interact():
	if controlled:
		player_in_range.control_ship(null)
	else:
		player_in_range.control_ship(ship)
	controlled = !controlled
		

func _on_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		player_in_range = area.get_owner()
		interactable = true


func _on_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("Player"):
		player_in_range = null
		interactable = false
