extends Node2D

@onready var skin_node = $Skin
@onready var eyes_node = $Eyes
@onready var hair_node = $Hair
@onready var torso_node = $Torso
@onready var legs_node = $Legs
@onready var boots_node = $Boots

# Called when the node enters the scene tree for the first time.
func _ready():
	skin_node.modulate = _random_color()
	eyes_node.modulate = _random_color()
	hair_node.modulate = _random_color()
	torso_node.modulate = _random_color()
	legs_node.modulate = _random_color()
	boots_node.modulate = _random_color()
	
	var random := RandomNumberGenerator.new();
	eyes_node.stop()
	$Timer.set_wait_time(random.randf_range(0, 2))
	$Timer.start()
	await $Timer.timeout
	eyes_node.play("default")

func _random_color() -> Color:
	var random := RandomNumberGenerator.new();
	return Color(random.randfn(), random.randfn(), random.randfn(), 1)