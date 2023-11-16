class_name Helm extends InteractableShipPart

var controlled : bool = false

var ship = null;

func _init() -> void:
	super(10)

func _on_area_2d_body_entered(player):
	if player.name == "Player":
		controlled = true
		player.control_ship(ship)
		
func _on_area_2d_body_exited(player):
	if player.name == "Player":
		controlled = false
		player.control_ship(null)

