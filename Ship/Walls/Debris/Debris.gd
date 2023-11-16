extends Node2D

@onready var sprite : Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var _random := RandomNumberGenerator.new()
	sprite.rotation_degrees = 90 * _random.randi_range(0, 3)


