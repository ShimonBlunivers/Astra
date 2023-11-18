class_name Helm extends InteractableShipPart

var controlled : bool = false

var ship = null;

var player_in_range = null

func _init() -> void:
	super(10)


func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("ui_control")) && interactable: interact()


func _interact():
	if controlled:
		player_in_range.control_ship(null)
	else:
		player_in_range.control_ship(ship)
		
	controlled = !controlled
		

func _on_area_2d_body_entered(player):
	if player.name == "Player":
		player_in_range = player
		interactable = true
		
func _on_area_2d_body_exited(player):
	if player.name == "Player":
		player_in_range = null
		interactable = false

