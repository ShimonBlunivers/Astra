extends RigidBody2D


@onready var wall_tile_map := $WallTileMap
@onready var object_tile_map := $ObjectTileMap
@onready var hitbox := $Hitbox
@onready var visual := $Visual
@onready var area := $Area/AreaHitbox

var dock_position : Vector2 = Vector2(100, 100)

var passengers := []

var controlled_by = null

var acceleration := Vector2(0, 0)

var thrust_power : Vector4 = Vector4(0, 0, 0, 0) # LEFT UP RIGHT DOWN

var thrusters := [[], [], [], []]; # LEFT UP RIGHT DOWN

# TODO: ✅ Fix bugging when the player exits at high speed

# TODO: ✅ Fix infinity position while moving too fast

# TODO: ✅? Fix player moving into walls when encountering moving ship

# TODO: Add Ship Connector

# TODO: Make Area2Ds for each room

# TODO: Make ships destroyable by collisions

# TODO: Add Thrusters & Canons

# TODO: Add Radar

# TODO: Create planets/moons/asteroids


var _old_position = position
var difference_in_position := Vector2(0, 0)

func load_ship(x: int, y: int) -> void:
	position = Vector2i(x, y)
	mass = 1
	wall_tile_map.load_ship(self)
	object_tile_map.load_ship(self)
	mass -= 1
	
	for direction in thrusters: for thruster in direction: thruster.set_status(false)


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:

	acceleration = Vector2(0, 0)
	if controlled_by != null: 
		control()
	state.apply_central_impulse(acceleration)
	update_thrusters()

	if abs(get_linear_velocity().x) > Limits.VELOCITY_MAX or abs(get_linear_velocity().y) > Limits.VELOCITY_MAX:
		var new_speed = get_linear_velocity().normalized()
		new_speed *= Limits.VELOCITY_MAX
		set_linear_velocity(new_speed)

func _physics_process(_delta: float) -> void:
	difference_in_position = position - _old_position
	# print("Ship moved by: ", _difference_in_position)
	_old_position = position
	


func control():
	
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if !controlled_by.alive: direction = Vector2.ZERO
	if direction.x < 0: acceleration.x -= thrust_power.x
	elif direction.x > 0: acceleration.x += thrust_power.z

	if direction.y < 0: acceleration.y -= thrust_power.y
	elif direction.y > 0: acceleration.y += thrust_power.w

func update_thrusters():
	for thruster in thrusters[0]: if thruster.running != (acceleration.x < 0): thruster.set_status(acceleration.x < 0)
	for thruster in thrusters[2]: if thruster.running != (acceleration.x > 0): thruster.set_status(acceleration.x > 0)
	for thruster in thrusters[1]: if thruster.running != (acceleration.y < 0): thruster.set_status(acceleration.y < 0)
	for thruster in thrusters[3]: if thruster.running != (acceleration.y > 0): thruster.set_status(acceleration.y > 0)

func get_rect():
	return wall_tile_map.get_rect()

func get_tile_size():
	return Vector2(wall_tile_map.tile_set.tile_size) * wall_tile_map.scale

func start_controlling(player):
	controlled_by = player

func stop_controlling():
	controlled_by = null

func _on_area_2d_body_entered(body:Node2D) -> void:
	if body.is_in_group("Character"):
		passengers.append(body)
		body.get_in(self)

	# if body.is_in_group("Player"):
		# if body.max_impact_velocity < (body.acceleration - _difference_in_position).length(): body.kill()   TODO: OPRAVIT

func _on_area_2d_body_exited(body:Node2D) -> void:
	if body.is_in_group("Character"):
		passengers.erase(body)
		body.get_off(self)
	# if body.is_in_group("Player"):
