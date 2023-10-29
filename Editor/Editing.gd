extends TileMap

@onready var console = $"../HUD/ConsoleLog"

func _ready() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	var layer := 0;
	if (event.is_action_pressed("mb_left")):
		var tile = local_to_map(to_local(get_global_mouse_position()))
		set_cells_terrain_connect(layer, [tile], 0, 0)
		
	if (event.is_action_pressed("mb_right")):
		var tile = local_to_map(to_local(get_global_mouse_position()))
		set_cell(layer, tile, -1)
		
func save_ship(path : String = "default_ship") -> void:
	var layer : int = 0;
	DirAccess.make_dir_absolute("user://saves/")
	DirAccess.make_dir_absolute("user://saves/ships/")
	var save_file := FileAccess.open("user://saves/ships/" + path + ".dat", FileAccess.WRITE)
	
	for cell in get_used_cells(layer):
		save_file.store_float(cell.x)	# 0
		save_file.store_float(cell.y)	# 1
		save_file.store_16(get_cell_source_id(layer, Vector2i(cell.x, cell.y)))	# 2
		save_file.store_float(get_cell_atlas_coords(layer, Vector2i(cell.x, cell.y)).x)	# 3
		save_file.store_float(get_cell_atlas_coords(layer, Vector2i(cell.x, cell.y)).y)	# 4
		save_file.store_16(get_cell_alternative_tile(layer, Vector2i(cell.x, cell.y)))	# 5
		set_cell(layer, Vector2i(cell.x, cell.y), -1)
		
	console.print_out("SAVING, file <- " + path)
	
func load_ship(path : String = "default_ship") -> bool:
	
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
	
	console.print_out("LOADING, file -> " + path)
	return true


func _on_save_pressed() -> void:
	save_ship("station")


func _on_load_pressed() -> void:
	load_ship("station")
