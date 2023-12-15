class_name NPC extends Character


@onready var shifted_position = position

var difference = Vector2.ZERO

func init():
	print("NPC SPAWNED on: " , position)

func move(by: Vector2):
	shifted_position += by;

