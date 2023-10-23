extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _unhandled_input(event: InputEvent) -> void:
	var layer : int = 0;

	if (event.is_action_pressed("mb_left")):
		var tile = local_to_map(to_local(get_global_mouse_position()))
		set_cells_terrain_connect(layer, [tile], 0, 0)
		
func save_ship() -> void:
	var layer : int = 0;
	DirAccess.make_dir_absolute("user://saves/")
	DirAccess.make_dir_absolute("user://saves/ships/")
	var save_file := FileAccess.open("user://saves/ships/default_ship_save.dat", FileAccess.WRITE)
	
	print(get_used_cells(layer))
	
	for cell in get_used_cells(layer):
		save_file.store_double(cell.x)
		save_file.store_double(cell.y)
		save_file.store_8(get_cell_source_id(layer, Vector2i(cell.x, cell.y)))
		save_file.store_double(get_cell_atlas_coords(layer, Vector2i(cell.x, cell.y)).x)
		save_file.store_double(get_cell_atlas_coords(layer, Vector2i(cell.x, cell.y)).y)
#		print("X: ", cell.x," Y: ", cell.y, " ID: ", get_cell_source_id(layer, Vector2i(cell.x, cell.y)))
		set_cell(layer, Vector2i(cell.x, cell.y), -1)
		
func load_ship() -> bool:
	
	clear()
	
	var layer : int = 0;
	
	if not FileAccess.file_exists("user://saves/ships/default_ship_save.dat"):
		return false
	var save_file := FileAccess.open("user://saves/ships/default_ship_save.dat", FileAccess.READ)
	
	while save_file.get_position() != save_file.get_length():
		var tile:= Vector2()
		tile.x = save_file.get_double()
		tile.y = save_file.get_double()
		set_cell(layer, tile, save_file.get_8(), Vector2i(save_file.get_double(), save_file.get_double()))
		
	save_file.close()
	return true


func _on_save_pressed() -> void:
	print("SAVING")
	save_ship()


func _on_load_pressed() -> void:
	print("LOADING")
	load_ship()
