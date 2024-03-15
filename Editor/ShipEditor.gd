class_name ShipEditor extends Node2D


@onready var console : Console = $"../HUD/ConsoleLog"
@onready var wall_tile_map := $WallTileMap
@onready var object_tile_map := $ObjectTileMap

static var instance
static var tool_preview
var inventory : Inventory

static var directions = {
	0 : "doprava",
	1 : "dolů",
	2 : "doleva",
	3 : "nahoru",
}

static var direction := 0

static var autoflooring = false

static var tools := {}

static var tool : Tool = null

# TODO: ✅ Make placing tiles smoother

# TODO: ✅ Create menu for tools

# TODO: ✅ Make money (energy) system

# TODO: ✅ Add autoflooring

# TODO: Add Interactables

func evide_tiles():
	var layer = 0
	for coords in wall_tile_map.get_used_cells(layer):
		var type = ShipValidator.get_tile_type(wall_tile_map, coords)
		if type in tools.keys():
			tools[type].number_of_instances += 1
	for coords in object_tile_map.get_used_cells(layer):
		var type = ShipValidator.get_tile_type(wall_tile_map, coords)
		if type in tools.keys():
			tools[type].number_of_instances += 1

func _ready() -> void:
	load_tools()

	instance = self
	tool_preview = $"../HUD/ToolPreview"

	evide_tiles()

	# ShipValidator.autofill_floor(wall_tile_map)

func load_tools():
	var path = "res://Editor/Tools"
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				if ".tres" in file_name:
					load(path + "/" + file_name).create()
			file_name = dir.get_next()

static func get_mouse_tile() -> Vector2i:
	return instance.wall_tile_map.local_to_map(instance.to_local(instance.get_global_mouse_position()))

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion || event is InputEventMouseButton: 
		var layer = 0
		if event.button_mask == 1:
			use_tool(ShipEditor.get_mouse_tile(), layer)
		elif event.button_mask == 2:
			ShipEditor.sell_tile(wall_tile_map, ShipEditor.get_mouse_tile())
	
	
	if event.is_action_pressed("editor_change_direction"):
		ShipEditor.direction = (ShipEditor.direction + 1) % 4
		Editor.instance.direction_label.text = "Směr: " + directions[direction]
		update_preview_rotation()

func use_tool(tile : Vector2i, layer : int) -> void:
	if tool == null: return
	if !(tool.number_of_instances < tool.world_limit || tool.world_limit < 0): return
	if ShipValidator.get_tile_type(wall_tile_map, tile, layer) == tool.name: return
	var placing_on_something = false
	if tool.placeable_on_atlas_choords != Vector2i(-1, -1):
		placing_on_something = true
		if tool.placeable_on_atlas_choords != wall_tile_map.get_cell_atlas_coords(layer, tile):
			return

	ShipEditor.sell_tile(wall_tile_map, tile, false)

	if !Inventory.add_currency(-tool.price):
		return

	tool.number_of_instances += 1

	if !placing_on_something:
		wall_tile_map.set_cells_terrain_connect(layer, [tile], 0, -1, false)

	if tool.terrain_id != -1:
		wall_tile_map.set_cells_terrain_connect(layer, [tile], 0, tool.terrain_id)	
	elif tool.atlas_coords != Vector2i(-1, -1):
		wall_tile_map.set_cell(layer, tile, 0, tool.atlas_coords, direction if tool.rotatable else 0)

	if tool.name in ShipValidator.walls && autoflooring:
		ShipValidator.autofill_floor(wall_tile_map)

	# wall_tile_map.set_cells_terrain_connect(layer, [tile], 0, -1, false)

static func sell_tile(tilemap : TileMap, coords : Vector2i, delete_tile := true) -> bool:
	var sold = false
	var layer = 0
	var type = ShipValidator.get_tile_type(tilemap, coords, layer)

	if type in tools.keys():
		tools[type].number_of_instances -= 1
		Inventory.add_currency(tools[type].price, delete_tile)
		sold = true

	if delete_tile: tilemap.set_cells_terrain_connect(layer, [coords], 0, -1, false)

	if type in ShipValidator.walls && autoflooring:
		ShipValidator.autofill_floor(tilemap)
	return sold

static func change_tool(key : String) -> void:
	tool = tools[key]
	tool_preview.texture = tool.texture
	update_preview_rotation()

static func update_preview_rotation():
	if tool.rotatable:
		tool_preview.rotation_degrees = 90 * direction
	else:
		tool_preview.rotation_degrees = 0
	
func save_ship(path : String = "default_ship") -> void:
	var layer : int = 0
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
	
	console.print_out("Uložena loď s názvem: " + path)
	
func load_ship(path : String = "default_ship") -> bool:
	
	var layer : int = 0
	for key in tools.keys():
		tools[key].number_of_instances = 0


	if not FileAccess.file_exists("user://saves/ships/" + path + "/walls.dat"):
		return false
	if not FileAccess.file_exists("user://saves/ships/" + path + "/objects.dat"):
		return false

	wall_tile_map.clear()
	object_tile_map.clear()
	
	var walls_save_file := FileAccess.open("user://saves/ships/" + path + "/walls.dat", FileAccess.READ)
	var objects_save_file := FileAccess.open("user://saves/ships/" + path + "/objects.dat", FileAccess.READ)
	
	var contents := []
	
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

	evide_tiles()
	
	console.print_out("Načtena loď s názvem: " + path)
	return true