extends Node

static var world

func get_closest_ship(from_global_pos : Vector2) -> Ship:
	var ships = Ship.ships
	if ships.size() == 0: return null
	var closest = ships[0]
	for ship in ships:
		if closest.get_closest_point(from_global_pos).distance_to(from_global_pos) > ship.get_closest_point(from_global_pos).distance_to(from_global_pos): 
			closest = ship
	return closest

func _ready() -> void:
	load("res://Items/Chip/Chip.tres").create()
	load("res://Items/Coin/Coin.tres").create()
	world = World.instance

func get_saveable_items():
	var list = []
	list.append_array(Ship.ships)
	list.append_array(NPC.npcs)
	list.append_array(Item.items)
	return list
