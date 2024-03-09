extends Node2D

@onready var skin_node = $Skin
@onready var eyes_node = $Eyes
@onready var hair_node = $Hair
@onready var torso_node = $Torso
@onready var legs_node = $Legs
@onready var boots_node = $Boots

# Called when the node enters the scene tree for the first time.
func _ready():
	var random := RandomNumberGenerator.new()

	skin_node.set_modulate(_random_color())
	eyes_node.set_modulate(_random_color())
	hair_node.set_modulate(_random_color())

	hair_node.frame = random.randi_range(0, 6)
	hair_node.flip_h = random.randi_range(0, 1) == 0

	torso_node.set_modulate(_random_color())
	legs_node.set_modulate(_random_color())
	boots_node.set_modulate(Color.BLACK)
	
	eyes_node.stop()
	$Timer.set_wait_time(random.randf_range(0, 2))
	$Timer.start()
	await $Timer.timeout
	eyes_node.play("default")

func _random_color() -> Color:
	var random := RandomNumberGenerator.new()
	return Color(random.randfn() * 0.75, random.randfn() * 0.75, random.randfn() * 0.75, 1)