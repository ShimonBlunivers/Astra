extends Node

var SHIPS = []

func get_closest_ship(from_global_pos : Vector2) -> Ship:
	var ships = ObjectList.SHIPS;
	var closest = ships[0];
	for ship in ships:
		if closest.get_closest_point(from_global_pos).distance_to(from_global_pos) > ship.get_closest_point(from_global_pos).distance_to(from_global_pos): 
			closest = ship;
	return closest;