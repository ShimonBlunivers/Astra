class_name Connector extends ShipPart


@onready var sprite : Sprite2D = $Sprite2D

var layer : int = 0;


func init(_ship, _durability : float = 200, _mass : float = 5):
	super(_ship, _durability, _mass)

