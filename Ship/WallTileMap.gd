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

	var atlas := tile_set.get_source(0) as TileSetAtlasSource
	var atlas_image := atlas.texture.get_image()

	for cellpos in get_used_cells(layer):
		var cell := get_cell_tile_data(layer, cellpos)

		match cell.get_custom_data("type"):

			"door":
				var _door_object = door_scene.instantiate()
				_door_object.direction = cell.get_custom_data("direction")
				_door_object.position = map_to_local(cellpos)
				add_child(_door_object)
				set_cell(layer, cellpos, -1)
			
			"wall":

				var _wall_object = wall_scene.instantiate()
				_wall_object.position = map_to_local(cellpos)
				add_child(_wall_object)

				_wall_object.light_occluder.occluder = cell.get_occluder(layer)
				
				var tile_image := atlas_image.get_region(atlas.get_tile_texture_region(get_cell_atlas_coords(layer, cellpos)))
				
				for i in range(get_cell_alternative_tile(layer, cellpos)): tile_image.rotate_90(CLOCKWISE)

				var tile_texture := ImageTexture.create_from_image(tile_image)

				tile_texture.set_size_override(Vector2i(32, 32))
				_wall_object.set_texture(tile_texture)

				_wall_object.wall_tile_map = self
				_wall_object.layer = layer

				set_cell(layer, cellpos, -1)

	return true

func _load_hitbox():
	pass
	
