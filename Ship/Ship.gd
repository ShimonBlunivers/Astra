class_name Ship extends RigidBody2D


@onready var wall_tile_map := $WallTileMap
@onready var object_tile_map := $ObjectTileMap

@onready var wall_tiles := $WallTiles
@onready var object_tiles := $ObjectTiles
@onready var items := $Items

@onready var hitbox := $Hitbox
@onready var visual := $Visual
@onready var area := $Area/AreaHitbox
@onready var passengers_node := $Passengers

var polygon

var dock_position : Vector2 = Vector2(100, 100)

var passengers := []

var controlled_by = null

var acceleration := Vector2.ZERO

var rotation_speed : float = 0 

var velocity := Vector2.ZERO

var thrust_power : Vector4 = Vector4(0, 0, 0, 0) # LEFT UP RIGHT DOWN

var thrusters := [[], [], [], []] # LEFT UP RIGHT DOWN

var interactables := []

# TODO: ✅ Fix bugging when the player exits at high speed

# TODO: ✅ Fix infinity position while moving too fast

# TODO: ✅? Fix player moving into walls when encountering moving ship

# TODO: CREATE OWN COLLISIONS

# TODO: Add Ship Connector

# TODO: Make Area2Ds for each room

# TODO: Make ships destroyable by collisions

# TODO: Add Thrusters & Canons

# TODO: Add Radar

# TODO: Create planets/moons/asteroids


var _old_position = position
var difference_in_position := Vector2.ZERO

func _ready() -> void:
	ObjectList.SHIPS.append(self)

func load_ship(_position : Vector2, path : String) -> void:
	global_position = _position
	mass = 1
	wall_tile_map.load_ship(self, path)
	object_tile_map.load_ship(self, path)
	mass -= 1
	
	for direction in thrusters: for thruster in direction: thruster.set_status(false)

func get_tile(coords : Vector2i):
	for tile in wall_tile_map.get_children():
		if (tile is ShipPart):
			if (coords == tile.tilemap_coords):
				return tile
	return null

func get_closest_point(point1 : Vector2) -> Vector2:
	var closest = polygon[0].rotated(global_rotation) + global_position
	for point2 in polygon:
		point2 = point2.rotated(global_rotation) + global_position
		if closest.distance_to(point1) > point2.distance_to(point1):
			closest = point2
	return closest


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	acceleration = Vector2.ZERO
	rotation_speed = 0

	if controlled_by != null: 
		control()

	update_thrusters()
	update_side_trusters()

	acceleration = acceleration.rotated(global_rotation)
	
	state.apply_central_impulse(acceleration)
	state.apply_torque_impulse(rotation_speed)

	if abs(get_linear_velocity().x) > Limits.VELOCITY_MAX or abs(get_linear_velocity().y) > Limits.VELOCITY_MAX:
		var new_speed = get_linear_velocity().normalized()
		new_speed *= Limits.VELOCITY_MAX
		set_linear_velocity(new_speed)

func _physics_process(_delta: float) -> void:
	difference_in_position = position - _old_position
	# print("Ship moved by: ", _difference_in_position)
	# for passenger in passengers: 
	# 	if passenger.is_in_group("NPC"):
	# 		passenger.legs.position = passenger.legs_offset + difference_in_position
			
	# area.position = -difference_in_position
	_old_position = position


func control():
	
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var rotation_direction := Input.get_axis("game_turn_left","game_turn_right")

	var _rotation_power = 8000 * mass

	if !controlled_by.alive: direction = Vector2.ZERO

	if direction.x < 0: acceleration.x -= thrust_power.x
	elif direction.x > 0: acceleration.x += thrust_power.z

	if direction.y < 0: acceleration.y -= thrust_power.y
	elif direction.y > 0: acceleration.y += thrust_power.w

	if ((thrusters[0].size() + thrusters[1].size() + thrusters[2].size() + thrusters[3].size()) == 0): rotation_speed = 0
	else: rotation_speed = _rotation_power * rotation_direction + rotation_direction * (thrusters[0].size() + thrusters[1].size() + thrusters[2].size() + thrusters[3].size())

func update_side_trusters():
	for thruster_list in thrusters:
		for thruster in thruster_list:
			thruster.side_thrusters(rotation_speed)

func update_thrusters():
	for thruster in thrusters[0]: if thruster.running != (acceleration.x < 0): 
		thruster.set_status(acceleration.x < 0)
	for thruster in thrusters[2]: if thruster.running != (acceleration.x > 0): 
		thruster.set_status(acceleration.x > 0)
	for thruster in thrusters[1]: if thruster.running != (acceleration.y < 0): 
		thruster.set_status(acceleration.y < 0)
	for thruster in thrusters[3]: if thruster.running != (acceleration.y > 0): 
		thruster.set_status(acceleration.y > 0)

func get_rect():
	return wall_tile_map.get_rect()

func get_tile_size():
	return Vector2(wall_tile_map.tile_set.tile_size) * wall_tile_map.scale

func start_controlling(player):
	controlled_by = player

func stop_controlling():
	controlled_by = null

func _on_area_area_entered(_area:Area2D) -> void:
	if _area.is_in_group("PlayerInteractArea"):
		var body = _area.get_parent()
		if (!body.spawned): 				return
		if (body in passengers): 			return
		passengers.append(body)
		body.get_in(self)

	# if body.is_in_group("Player"):
		# if body.max_impact_velocity < (body.acceleration - _difference_in_position).length(): body.kill()   TODO: OPRAVIT


func _on_area_area_exited(_area:Area2D) -> void:
	if _area.is_in_group("PlayerInteractArea"):
		var body = _area.get_parent()
		if (!body.spawned): 				return
		if !(body in passengers): 			return
		passengers.erase(body)
		body.get_off(self)
