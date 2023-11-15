extends TileMap


const door_scene = preload("res://Ship/Walls/Door/Door.tscn")
const wall_scene = preload("res://Ship/Walls/Wall/Wall.tscn")

var ship = null

func load_ship(_ship, path : String = "station") -> bool:
	ship = _ship
	
	clear()
	
	var layer : int = 0;
	
	if not FileAccess.file_exists("user://saves/ships/" + path + "/walls.dat"):
		return false
	var save_file := FileAccess.open("user://saves/ships/" + path + "/walls.dat", FileAccess.READ)
	
	var contents := [];
	
	while save_file.get_position() != save_file.get_length():
		contents = [save_file.get_float(), save_file.get_float(), save_file.get_16(), save_file.get_float(), save_file.get_float(), save_file.get_16()]
		var tile:= Vector2()
		tile.x = contents[0]
		tile.y = contents[1]
		set_cell(layer, tile, contents[2], Vector2i(contents[3], contents[4]), contents[5])
		
	save_file.close()
	
	_load_hitbox()
	_replace_interactive_tiles()

	return true
	
func _replace_interactive_tiles() -> bool:
	var layer := 0;
	for cellpos in get_used_cells(layer):
		var cell := get_cell_tile_data(layer, cellpos)

		match cell.get_custom_data("type"):

			"door":
				var door_object = door_scene.instantiate()
				door_object.direction = cell.get_custom_data("direction")
				door_object.position = map_to_local(cellpos)
				add_child(door_object)
				set_cell(layer, cellpos, -1)
			
			"wall":
				if (get_cell_atlas_coords(layer, cellpos) != Vector2i(-1, -1)):
					var wall_object = wall_scene.instantiate()
					wall_object.position = map_to_local(cellpos)
					add_child(wall_object)
					set_cell(layer, cellpos, -1)

					var atlas := tile_set.get_source(0) as TileSetAtlasSource
					var atlasImage := atlas.texture.get_image()
					var tileImage := atlasImage.get_region(atlas.get_tile_texture_region(get_cell_atlas_coords(layer, cellpos)))
					var tiletexture := ImageTexture.create_from_image(tileImage)

					tiletexture.set_size_override(Vector2i(1, 1))
					wall_object.set_texture(tiletexture)

	return true

func _load_hitbox():
	pass
	
