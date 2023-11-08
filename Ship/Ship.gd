extends Node2D


@onready var wall_tile_map := $WallTileMap
@onready var object_tile_map := $ObjectTileMap

var DockPosition : Vector2 = Vector2(100, 100)


func _ready() -> void:
	pass

func load_ship(x: int, y: int) -> bool:
	position = Vector2i(x, y)
	return wall_tile_map.load_ship() && object_tile_map.load_ship()
