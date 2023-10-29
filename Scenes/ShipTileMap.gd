extends TileMap

const doors = preload("res://Ship/Door.tscn")

var DockPosition : Vector2 = Vector2(100, 100)

func _ready() -> void:

	load_ship()
	
	var layer := 0;
	for cellpos in get_used_cells(layer):
		var cell = get_cell_tile_data(layer, cellpos)
		if cell.get_custom_data("type") == "door":
			var doorObject = doors.instantiate()
			doorObject.direction = cell.get_custom_data("direction")
			doorObject.position = map_to_local(cellpos)
			add_child(doorObject)
			set_cell(layer, cellpos, -1)



func load_ship(path : String = "station") -> bool:
	
	clear()
	
	var layer : int = 0;
	
	if not FileAccess.file_exists("user://saves/ships/" + path + ".dat"):
		return false
	var save_file := FileAccess.open("user://saves/ships/" + path + ".dat", FileAccess.READ)
	
	var contents := [];
	
	while save_file.get_position() != save_file.get_length():
		contents = [save_file.get_float(), save_file.get_float(), save_file.get_16(), save_file.get_float(), save_file.get_float(), save_file.get_16()]
		var tile:= Vector2()
		tile.x = contents[0]
		tile.y = contents[1]
		set_cell(layer, tile, contents[2], Vector2i(contents[3], contents[4]), contents[5])
		
	save_file.close()

	return true
