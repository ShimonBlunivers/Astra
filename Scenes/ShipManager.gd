extends Node2D


@onready var ship_scene = "res://Ship/Ship.tscn"

@onready var main_station := $Station0
@onready var player = $"../Player"


func _ready() -> void:
	_load()

func _load() -> void:
	main_station.load_ship(0, 0)

func spawn_ship(x: int = 0, y: int = 0) -> bool:
	var _ship = ship_scene.instantiate()
	return _ship.load_ship(x, y)
