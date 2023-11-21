extends Node2D


@onready var console := $"../HUD/ConsoleLog"
@onready var tool_preview := $"../HUD/ToolPreview"
@onready var wall_tile_map := $WallTileMap
@onready var object_tile_map := $ObjectTileMap

enum tools {wall, door, floor}
var tool_previews = {"wall" : Vector2i(3, 0), "door" : Vector2i(4, 0), "floor" : Vector2i(0, 0)}
var tool : tools = tools.floor

# TODO: Make placing tiles smoother

# TODO: Add autoflooring

# TODO: Create menu for tools

# TODO: Add Interactables

# TODO: Make money system


func _ready() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	handle_input()
	var layer := 0;
	if (event.is_action_pressed("mb_left")):
		var tile = wall_tile_map.local_to_map(to_local(get_global_mouse_position()))
		use_tool(tile, layer)
	if (event.is_action_pressed("mb_right")):
		var tile = wall_tile_map.local_to_map(to_local(get_global_mouse_position()))
		wall_tile_map.set_cells_terrain_connect(layer, [tile], 0, -1, false)
		
func use_tool(tile, layer) -> void:
	tools.values()
	match tool:
		tools.wall: 
			wall_tile_map.set_cells_terrain_connect(layer, [tile], 0, 0)
		tools.door:
			print(wall_tile_map.get_cell_atlas_coords(layer, tile))
			if (wall_tile_map.get_cell_atlas_coords(layer, tile) == Vector2i(2, 0) || wall_tile_map.get_cell_atlas_coords(layer, tile) == Vector2i(2, 0)):
				wall_tile_map.set_cells_terrain_connect(layer, [tile], 0, 1)
		tools.floor:
			wall_tile_map.set_cells_terrain_connect(layer, [tile], 0, -1, false)
			wall_tile_map.set_cell(layer, tile, 0,  Vector2i(0, 0))
		_: 
			return
		
func change_tool(key : String) -> void:
	tool = tools[key]
	
func handle_input():
	for i in tools:
		if (Input.is_action_just_pressed("ui_tool_set_" + i)):
			change_tool(i)
			change_tool_preview(i)
			
func change_tool_preview(_tool):
	var atlas = wall_tile_map.tile_set.get_source(0) as TileSetAtlasSource
	var atlasImage = atlas.texture.get_image()
	var tileImage = atlasImage.get_region(atlas.get_tile_texture_region(tool_previews[_tool]))
	var tiletexture = ImageTexture.create_from_image(tileImage)
	tiletexture.set_size_override(Vector2i(1, 1))
	tool_preview.texture = tiletexture


func save_ship(path : String = "default_ship") -> void:
	var layer : int = 0;
	DirAccess.make_dir_absolute("user://saves/")
	DirAccess.make_dir_absolute("user://saves/ships/")
	DirAccess.make_dir_absolute("user://saves/ships/"+path+"/")
	
	var walls_save_file := FileAccess.open("user://saves/ships/" + path + "/walls.dat", FileAccess.WRITE)
	var objects_save_file := FileAccess.open("user://saves/ships/" + path + "/objects.dat", FileAccess.WRITE)
	
	for cell in wall_tile_map.get_used_cells(layer):
		walls_save_file.store_float(cell.x)	# 0
		walls_save_file.store_float(cell.y)	# 1
		walls_save_file.store_16(wall_tile_map.get_cell_source_id(layer, Vector2i(cell.x, cell.y)))	# 2
		walls_save_file.store_float(wall_tile_map.get_cell_atlas_coords(layer, Vector2i(cell.x, cell.y)).x)	# 3
		walls_save_file.store_float(wall_tile_map.get_cell_atlas_coords(layer, Vector2i(cell.x, cell.y)).y)	# 4
		walls_save_file.store_16(wall_tile_map.get_cell_alternative_tile(layer, Vector2i(cell.x, cell.y)))	# 5
		# set_cell(layer, Vector2i(cell.x, cell.y), -1)
		
	for cell in object_tile_map.get_used_cells(layer):
		objects_save_file.store_float(cell.x)	# 0
		objects_save_file.store_float(cell.y)	# 1
		objects_save_file.store_16(object_tile_map.get_cell_source_id(layer, Vector2i(cell.x, cell.y)))	# 2
		objects_save_file.store_float(object_tile_map.get_cell_atlas_coords(layer, Vector2i(cell.x, cell.y)).x)	# 3
		objects_save_file.store_float(object_tile_map.get_cell_atlas_coords(layer, Vector2i(cell.x, cell.y)).y)	# 4
		objects_save_file.store_16(object_tile_map.get_cell_alternative_tile(layer, Vector2i(cell.x, cell.y)))	# 5
		# set_cell(layer, Vector2i(cell.x, cell.y), -1)
	
	walls_save_file.close()
	objects_save_file.close()
	
	console.print_out("SAVING, file <- " + path)
	
func load_ship(path : String = "default_ship") -> bool:
	
	wall_tile_map.clear()
	object_tile_map.clear()
	
	var layer : int = 0;
	
	if not FileAccess.file_exists("user://saves/ships/" + path + "/walls.dat"):
		return false
	if not FileAccess.file_exists("user://saves/ships/" + path + "/objects.dat"):
		return false

	var walls_save_file := FileAccess.open("user://saves/ships/" + path + "/walls.dat", FileAccess.READ)
	var objects_save_file := FileAccess.open("user://saves/ships/" + path + "/objects.dat", FileAccess.READ)
	
	var contents := [];
	
	while walls_save_file.get_position() != walls_save_file.get_length():
		contents = [walls_save_file.get_float(), walls_save_file.get_float(), walls_save_file.get_16(), walls_save_file.get_float(), walls_save_file.get_float(), walls_save_file.get_16()]
		var tile:= Vector2()
		tile.x = contents[0]
		tile.y = contents[1]
		wall_tile_map.set_cell(layer, tile, contents[2], Vector2i(contents[3], contents[4]), contents[5])

	while objects_save_file.get_position() != objects_save_file.get_length():
		contents = [objects_save_file.get_float(), objects_save_file.get_float(), objects_save_file.get_16(), objects_save_file.get_float(), objects_save_file.get_float(), objects_save_file.get_16()]
		var tile:= Vector2()
		tile.x = contents[0]
		tile.y = contents[1]
		object_tile_map.set_cell(layer, tile, contents[2], Vector2i(contents[3], contents[4]), contents[5])

	walls_save_file.close()
	objects_save_file.close()
	
	console.print_out("LOADING, file -> " + path)
	return true


func _on_save_pressed() -> void:
	save_ship("station")


func _on_load_pressed() -> void:
	load_ship("station")
