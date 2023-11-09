extends Node2D


var controlled : bool = false

var ship = null;


func _on_area_2d_body_entered(player):
	if player.name == "Player":
		controlled = false
		player.ship_controlled = ship
		ship.passengers.append(player)		
		player.change_view(0)
func _on_area_2d_body_exited(player):
	if player.name == "Player":
		controlled = false
		player.ship_controlled = null
		ship.passengers.erase(player)		
		player.change_view(1)
		
