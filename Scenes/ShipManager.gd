class_name ShipManager extends Node2D


@onready var ship_scene = preload("res://Ship/Ship.tscn")

@onready var main_station := $"Station-0"
@onready var player = $"../Player"

static var instance

func _ready() -> void:
	instance = self
	_load()
	spawn_ship(Vector2(0, 2200), "small_shuttle")

func _load() -> void:
	main_station.load_ship(Vector2.ZERO, "station")

func spawn_ship(_position : Vector2, path : String = "station") -> void:
	var _ship = ship_scene.instantiate()
	_ship.name = "Ship-" + str(get_children().size() - 1)
	add_child(_ship)
	_ship.load_ship(_position, path)
