extends RigidBody2D


@onready var wall_tile_map := $WallTileMap
@onready var object_tile_map := $ObjectTileMap
@onready var hitbox := $Hitbox
@onready var visual := $Visual
@onready var area := $Area/AreaHitbox

var dock_position : Vector2 = Vector2(100, 100)

var passengers := []

var controlled : bool = false

var acceleration := Vector2(0, 0)

var thrust_power : Vector4 = Vector4(10000, 10000, 10000, 10000) # UP DOWN LEFT RIGHT


# TODO: Make Area2Ds for each room

# TODO: Make ships destroyable by collisions

# TODO: Add Thrusters & Canons

# TODO: Add Radar

# TODO: Make occluded darks completely dark

# TODO: Create planets/moons/asteroids


var _old_position = position

func load_ship(x: int, y: int) -> void:
	position = Vector2i(x, y)
	mass = 1
	wall_tile_map.load_ship(self)
	object_tile_map.load_ship(self)
	mass -= 1

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	state.apply_impulse(acceleration)
	if controlled: control()
	for passenger in passengers: passenger.position += position - _old_position
	_old_position = position

func control():
	
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	acceleration = Vector2(0, 0)

	if direction.x < 0: acceleration.x = -thrust_power.z
	elif direction.x > 0: acceleration.x = thrust_power.w

	if direction.y < 0: acceleration.y = -thrust_power.x
	elif direction.y > 0: acceleration.y = thrust_power.y

func get_rect():
	return wall_tile_map.get_rect()

func get_tile_size():
	return Vector2(wall_tile_map.tile_set.tile_size) * wall_tile_map.scale

func start_controlling():
	controlled = true

func stop_controlling():
	controlled = false


func _on_area_2d_body_entered(body:Node2D) -> void:
	if body.is_in_group("Player"):
		passengers.append(body)


func _on_area_2d_body_exited(body:Node2D) -> void:
	if body.is_in_group("Player"):
		passengers.erase(body)
