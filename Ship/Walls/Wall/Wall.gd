class_name Wall extends ShipPart


@onready var sprite : Sprite2D = $Sprite2D
@onready var light_occluder : LightOccluder2D = $LightOccluder2D
@onready var hp : ProgressBar = $HP
@onready var cracks : AnimatedSprite2D = $Cracks
@onready var button : Button = $Button

static var debris_scene = preload("res://Ship/Walls/Debris/Debris.tscn")

var wall_tile_map : TileMap = null;
var layer : int = 0;


func init(_ship, _durability : float = 100, _mass : float = 4):
	super(_ship, _durability, _mass)

func set_texture(texture) -> void:
	sprite.texture = texture


func _on_button_pressed():
	damage(hp.step)

func damage(dmg: float):
	
	hp.value += dmg

	button.tooltip_text = str(snapped(hp.value / hp.max_value, 0.01)) + "%"

	match hp.value / hp.max_value:
		1:
			cracks.frame = 0

		0.75:
			cracks.frame = 1
		0.5:
			cracks.frame = 2
		0.25:
			cracks.frame = 3

	if (hp.value <= 0):
		destroy()


func destroy():
	var _debris_object := debris_scene.instantiate()

	_debris_object.position = position

	get_parent().add_child(_debris_object)
	var _pos = wall_tile_map.local_to_map(position)
	wall_tile_map.set_cells_terrain_connect(layer, [_pos] , 0, -1, false)


	remove()
