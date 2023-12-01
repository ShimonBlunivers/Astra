class_name ShipPart extends Node2D


var durability_max: float: 
    get: return durability_max
    set(value):
        durability_max = value
        durability_current = min(durability_current, durability_max)

var durability_current : float :
    get: return durability_current if durability_max >= 0 else 6942069.
    set(value): durability_current = min(value, durability_max)

var mass : float

var ship

func init(_ship, _durability : float = 60, _mass : float = 1):
    ship = _ship
    durability_max = _durability
    durability_current = _durability
    mass = _mass

    ship.mass += mass

func remove() -> void:
    ship.mass -= mass
    queue_free()