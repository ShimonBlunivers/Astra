class_name Wall extends ShipPart


@onready var sprite : Sprite2D = $Sprite2D
@onready var light_occluder : LightOccluder2D = $LightOccluder2D
@onready var progress_bar : ProgressBar = $Node2D/ProgressBar

static var debris_scene = preload("res://Ship/Walls/Debris/Debris.tscn")

var wall_tile_map : TileMap = null;
var layer : int = 0;


func _init() -> void:
	super(100)

func set_texture(texture) -> void:
	sprite.texture = texture


func _on_button_pressed():
	progress_bar.value -= 40
	if (progress_bar.value <= 0):
		destroy()

func destroy():
	var _debris_object := debris_scene.instantiate()

	_debris_object.position = position

	get_parent().add_child(_debris_object)
	var _pos = wall_tile_map.local_to_map(position)
	wall_tile_map.set_cells_terrain_connect(layer, [_pos] , 0, -1, false)

	queue_free()
