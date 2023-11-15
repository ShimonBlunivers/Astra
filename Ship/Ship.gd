extends RigidBody2D


@onready var wall_tile_map := $WallTileMap
@onready var object_tile_map := $ObjectTileMap

var dock_position : Vector2 = Vector2(100, 100)

var passengers := []

var controlled : bool = false


func load_ship(x: int, y: int) -> bool:
	position = Vector2i(x, y)
	return wall_tile_map.load_ship(self) && object_tile_map.load_ship(self)
	
func _physics_process(delta: float) -> void:
	if controlled: _move(delta)
	
func _move(delta: float):

	var SPEED = 1000
	
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	var _velocity : Vector2 = Vector2(direction.x * SPEED, direction.y * SPEED) * delta
	
	for passenger in passengers:
		passenger.position += _velocity

	move_and_collide(_velocity)

func control(player):
	passengers.append(player)	
	controlled = true

func stop_controlling(player):
	passengers.erase(player)	
	controlled = false
