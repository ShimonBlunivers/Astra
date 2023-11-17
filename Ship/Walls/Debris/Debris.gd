extends Node2D

@onready var sprite : Sprite2D = $Sprite2D
@onready var spawn_sound : AudioStreamPlayer2D = $Sounds/Spawn

# Called when the node enters the scene tree for the first time.
func _ready():
	var _random := RandomNumberGenerator.new()
	sprite.rotation_degrees = 90 * _random.randi_range(0, 3)
	spawn_sound.pitch_scale = randf_range(0.9, 1.1)
	spawn_sound.play()


