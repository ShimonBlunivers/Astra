extends TileMap


const helm_scene = preload("res://Ship/Objects/Helm/Helm.tscn")
const NPC_scene = preload("res://Character/NPC/NPC.tscn")

var ship = null


func load_ship(_ship, path : String = "station") -> bool:
	ship = _ship
	
	clear()
	
	var layer : int = 0
	
	if not FileAccess.file_exists("user://saves/ships/" + path + "/objects.dat"):
		return false
	var save_file := FileAccess.open("user://saves/ships/" + path + "/objects.dat", FileAccess.READ)
	
	var contents := []
	
	while save_file.get_position() != save_file.get_length():
		contents = [save_file.get_float(), save_file.get_float(), save_file.get_16(), save_file.get_float(), save_file.get_float(), save_file.get_16()]
		var tile:= Vector2()
		tile.x = contents[0]
		tile.y = contents[1]
		set_cell(layer, tile, contents[2], Vector2i(contents[3], contents[4]), contents[5])

	save_file.close()
	
	return _replace_interactive_tiles()
	

func _replace_interactive_tiles() -> bool:
	var layer := 0
	for cellpos in get_used_cells(layer):
		var cell = get_cell_tile_data(layer, cellpos)

		var tile_position = map_to_local(cellpos) * Limits.TILE_SCALE

		match cell.get_custom_data("type"):
			"helm":
				var helm_object = helm_scene.instantiate()
				helm_object.init(ship, cellpos)
				helm_object.position = tile_position

				ship.object_tiles.add_child(helm_object)

				set_cell(layer, cellpos, -1)

			"NPC":

				var NPC_object = NPC_scene.instantiate()
				NPC_object.spawn_point = tile_position
				NPC_object.spawn()
				NPC_object.init()
				NPC_object.ship = ship
				ship.passengers_node.add_child(NPC_object)
				ship.passengers.append(NPC_object)
				
				set_cell(layer, cellpos, -1)



	return true
