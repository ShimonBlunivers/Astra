class_name ShipManager extends Node2D


static var ship_scene = preload("res://Ship/Ship.tscn")

@onready var main_station := $"Station-0"

static var instance : ShipManager
static var number_of_ships = 0

func _ready() -> void:
	instance = self
	_load()
	ShipManager.spawn_ship(Vector2(0, -800), "small_shuttle")
	ShipManager.spawn_ship(Vector2(0, -1500), "small_shuttle")

func _load() -> void:
	main_station.load_ship(Vector2.ZERO, "station", null)

static func spawn_ship(_position : Vector2, path : String = "station", custom_object_spawn : CustomObjectSpawn = null) -> void:

	var _ship = ship_scene.instantiate()
	_ship.id = number_of_ships
	_ship.name = "Ship-" + str(_ship.id)
	number_of_ships += 1
	instance.add_child(_ship)
	_ship.load_ship(_position, path, custom_object_spawn)
