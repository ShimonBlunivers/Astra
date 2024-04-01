class_name Core extends ShipPart


@onready var sprite : AnimatedSprite2D = $Sprite2D

var layer : int = 0


func init(_ship, _coords : Vector2i, _durability : float = 200, _mass : float = 5):
	super(_ship, _coords, _durability, _mass)

