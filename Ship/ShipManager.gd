class_name ShipManager extends Node2D


static var ship_scene = preload("res://Ship/Ship.tscn")

static var instance : ShipManager
static var number_of_ships = 0

func _ready() -> void:
	instance = self
	ShipManager.spawn_ship(Vector2(0, 0))
	ShipManager.spawn_ship(Vector2(0, -2600), "small_shuttle")
	ShipManager.spawn_ship(Vector2(0, -4000), "small_shuttle")
	ShipManager.spawn_ship(Vector2(2000, -2500), "small_shuttle")

static func spawn_ship(_position : Vector2, path : String = "station", custom_object_spawn : CustomObjectSpawn = null) -> Ship:
	var _ship = ship_scene.instantiate()
	_ship.name = "Ship-" + str(_ship.id)
	instance.add_child(_ship)
	_ship.load_ship(_position, path, custom_object_spawn)
	return _ship


static func get_quest_ship_path(_mission_id : int) -> String:
	return "small_shuttle"
