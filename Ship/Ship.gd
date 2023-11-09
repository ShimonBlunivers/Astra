extends Node2D


@onready var wall_tile_map := $WallTileMap
@onready var object_tile_map := $ObjectTileMap

var dock_position : Vector2 = Vector2(100, 100)

var passengers := []

func load_ship(x: int, y: int) -> bool:
	position = Vector2i(x, y)
	return wall_tile_map.load_ship(self) && object_tile_map.load_ship(self)
	
func move(delta: float, direction: Vector2):
	
	var SPEED = 100
	
	var difference = Vector2(direction.x * SPEED * delta, direction.y * SPEED * delta)
	
	position += difference
	
	for passenger in passengers:
		passenger.position += difference
