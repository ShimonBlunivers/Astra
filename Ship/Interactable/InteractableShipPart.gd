class_name InteractableShipPart extends ShipPart

var direction := "horizontal"

var interactable = false

var player_in_range = null

var hitboxes_to_shift = []

func init(_ship, _coords : Vector2i, _durability : float = 10, _mass : float = 1):
	super(_ship, _coords, _durability, _mass)

func _physics_process(_delta: float) -> void:
	for hitbox in hitboxes_to_shift:
		if direction == "horizontal":
			hitbox.position = - ship.difference_in_position;
		elif direction == "vertical":
			var difference = Vector2(ship.difference_in_position.y, - ship.difference_in_position.x);
			hitbox.position = - difference;

func _process(_delta: float) -> void:
	if (!Options.DEBUG_MODE): return;
	queue_redraw()

func _draw() -> void:

	for hitbox in hitboxes_to_shift:
		var rect = hitbox.get_child(0).shape.get_rect()
		rect.position += hitbox.position
		draw_rect(rect, Color.YELLOW);

func interact():
	if interactable: _interact()

func _interact(): # VIRTUAL METHOD
	pass
