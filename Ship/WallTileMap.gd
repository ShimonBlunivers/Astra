extends TileMap


const door_scene = preload("res://Ship/Walls/Door/Door.tscn")
const wall_scene = preload("res://Ship/Walls/Wall/Wall.tscn")
const floor_scene = preload("res://Ship/Walls/Floor/Floor.tscn")
const core_scene = preload("res://Ship/Walls/Core/Core.tscn")
const thruster_scene = preload("res://Ship/Walls/Thruster/Thruster.tscn")
const connector_scene = preload("res://Ship/Walls/Connector/Connector.tscn")

var ship : Ship = null

var _first_rect : Rect2i

var test_polygon = null

func get_rect():
	return _first_rect

func _load_hitbox(_layer: int):
	var start_time = Time.get_ticks_usec()
	test_polygon = _create_polygon(_layer)

	var end_time = Time.get_ticks_usec()
	var elapsed_time = end_time - start_time
	print(test_polygon)
	print("Function execution time: %s microseconds" % elapsed_time)

	start_time = Time.get_ticks_usec()
	ship.polygon = _to_shape(_delete_edges(_create_edges(_layer)))

	end_time = Time.get_ticks_usec()
	elapsed_time = end_time - start_time
	print(ship.polygon)
	print("Function execution time: %s microseconds" % elapsed_time)

	ship.hitbox.polygon = ship.polygon
	ship.visual.polygon = ship.polygon
	ship.area.polygon = ship.polygon



	print_debug("!!!!!! TEST !!!!!!")


	var _scale = 100
	var test := [Vector2i(0, 0), Vector2i(2 * _scale, 0), Vector2i(2 * _scale, 2 * _scale), Vector2i(1 * _scale, 2 * _scale), Vector2i(1 * _scale, 1 * _scale), Vector2i(0, 1 * _scale)]
	print("before:" + str(test))
	var after = Geometry2D.convex_hull(test)
	print("after:" + str(after))

	test_polygon = after
	



func _create_polygon(_layer: int):
	var cells := get_used_cells(_layer)

	var magic_number = 5 # I don't know why I have to multiply it by 5, but it works

	for i in range(cells.size()):
		cells[i].x *= tile_set.tile_size.x * magic_number
		cells[i].y *= tile_set.tile_size.y * magic_number

	var unique_points = {}
	
	for cell in cells:
		unique_points[cell] = true

	for i in range(cells.size()):
		var cell = cells[i]
		unique_points[cell] = true
		unique_points[Vector2i(cell.x + tile_set.tile_size.x * magic_number, cell.y)] = true
		unique_points[Vector2i(cell.x + tile_set.tile_size.x * magic_number, cell.y + tile_set.tile_size.y * magic_number)] = true
		unique_points[Vector2i(cell.x, cell.y + tile_set.tile_size.y * magic_number)] = true


	if unique_points.keys().size() > 2:
		print("unique")

		print(unique_points.keys())
		var polygon := Geometry2D.convex_hull(unique_points.keys())

		return unique_points.keys()
	else:
		printerr("Not enough points to form a polygon.")
	return null

func _get_points(tile: Vector2i):
	
	# 1   2
	#  
	# 0   3  

	var tile_size = tile_set.tile_size
	
	return [ 
		Vector2(tile.x * tile_size.x, tile.y * tile_size.y + tile_size.y), # 0
		Vector2(tile.x * tile_size.x, tile.y * tile_size.y), # 1
		Vector2(tile.x * tile_size.x + tile_size.x, tile.y * tile_size.y), # 2
		Vector2(tile.x * tile_size.x + tile_size.x, tile.y * tile_size.y + tile_size.y) # 3
	]

func _get_points_rect(rect: Rect2):

	# 1   2
	#  
	# 0   3  

	var rect_position = rect.position * Vector2(tile_set.tile_size)
	var rect_size = rect.size * Vector2(tile_set.tile_size)
	return [ 
		Vector2(rect_position.x, rect_position.y + rect_size.y), # 0
		Vector2(rect_position.x, rect_position.y), # 1
		Vector2(rect_position.x + rect_size.x, rect_position.y), # 2
		Vector2(rect_position.x + rect_size.x, rect_position.y + rect_size.y) # 3
	]

func _get_lines(points, _scale = Limits.TILE_SCALE):
	return [
		[points[0] * _scale, points[1] * _scale],
		[points[1] * _scale, points[2] * _scale],
		[points[2] * _scale, points[3] * _scale],
		[points[3] * _scale, points[0] * _scale]
	]

func _create_edges(layer: int):
	var edges = []
	var grid = get_used_cells(layer)
	for tile in grid:
		for line in _get_lines(_get_points(tile)):
			edges.append(line)
	return edges

func _delete_edges(edges):
	var markForDeletion = []
	for currentLineIdx in range(edges.size()):
		var currentLine = edges[currentLineIdx]
		var currentLineInverted = [currentLine[1], currentLine[0]]
		for lineIdx in range(edges.size()):
			var line = edges[lineIdx]
			if lineIdx == currentLineIdx: continue # skip itself
			if currentLine == line or currentLineInverted == line:
				markForDeletion.append(currentLine)
				markForDeletion.append(currentLineInverted)
	for line in markForDeletion:
		var idx = edges.find(line)
		if idx >= 0: 
			edges.remove_at(idx)
	return edges

func _to_shape(edges):
	var result = PackedVector2Array()
	var nextLine = edges[0]
	for idx in range(edges.size()):
		for otherLine in edges:
			if otherLine == nextLine: continue
			if nextLine[1] == otherLine[0]:
				nextLine = otherLine
				break
			elif nextLine[1] == otherLine[1]:
				nextLine = [otherLine[1], otherLine[0]]
		
		result.append(nextLine[0])
	return result

func update_center_of_mass(layer : int):
	var grid = get_used_cells(layer)
	var leftmost_point : float = grid[0].x
	var rightmost_point : float = grid[0].x
	var highest_point : float = grid[0].y
	var lowest_point : float = grid[0].y

	for point in grid:
		if point.x < leftmost_point: leftmost_point = point.x
		if point.x > rightmost_point: rightmost_point = point.x
		if point.y > lowest_point: lowest_point = point.y
		if point.y < highest_point: highest_point = point.y

	ship.center_of_mass = Vector2(5 * tile_set.tile_size.x * (0.5 + (leftmost_point + rightmost_point) / 2), 5 * tile_set.tile_size.y * (0.5 + (highest_point + lowest_point) / 2))

func load_ship(_ship, path : String) -> bool:
	ship = _ship
	clear()
	
	var layer : int = 0

	var save_file : FileAccess
	
	print_debug("Loading ship file..")

	if not FileAccess.file_exists("user://saves/ships/" + path + "/walls.dat"):
		if not FileAccess.file_exists("res://DefaultSave/ships/" + path + "/walls.dat"):
			return false
		else:
			save_file = FileAccess.open("res://DefaultSave/ships/" + path + "/walls.dat", FileAccess.READ)
	else:
		save_file = FileAccess.open("user://saves/ships/" + path + "/walls.dat", FileAccess.READ)
	
	var contents := []
	
	while save_file.get_position() != save_file.get_length():
		contents = [save_file.get_float(), save_file.get_float(), save_file.get_16(), save_file.get_float(), save_file.get_float(), save_file.get_16()]
		var tile:= Vector2()
		tile.x = contents[0]
		tile.y = contents[1]
		set_cell(layer, tile, contents[2], Vector2i(contents[3], contents[4]), contents[5])

	save_file.close()

	print_debug("Loading ship hitbox..")

	_load_hitbox(layer)

	print_debug("Updating ship center of mass..")
	
	update_center_of_mass(layer)


	_first_rect = get_used_rect()

	# ship.original_wall_tile_map = self

	print_debug("Replacing tiles..")
	_replace_tiles()	

	return true
	
func _replace_tiles() -> bool:
	var layer := 0

	var atlas := tile_set.get_source(0) as TileSetAtlasSource
	var atlas_image := atlas.texture.get_image()

	for cellpos in get_used_cells(layer):
		var cell := get_cell_tile_data(layer, cellpos)

		var object_direction = get_cell_alternative_tile(layer, cellpos)
		
		var tile_position = map_to_local(cellpos) * Limits.TILE_SCALE

		if cell == null:
				var _connector_object = connector_scene.instantiate()
				_connector_object.init(ship, cellpos)
				_connector_object.position = tile_position

				ship.wall_tiles.add_child(_connector_object)
				
				_connector_object.rotation_degrees = object_direction * 90

				set_cell(layer, cellpos, -1)
				continue

		match cell.get_custom_data("type"):

			"floor":
				var _floor_object = floor_scene.instantiate()
				_floor_object.init(ship, cellpos)
				_floor_object.position = tile_position
				ship.wall_tiles.add_child(_floor_object)
				set_cell(layer, cellpos, -1)

			"door":

				var _door_object = door_scene.instantiate()
				_door_object.init(ship, cellpos)
				_door_object.direction = cell.get_custom_data("direction")
				_door_object.position = tile_position
				ship.wall_tiles.add_child(_door_object)
				var _floor_object = floor_scene.instantiate()
				_floor_object.init(ship, cellpos)
				_floor_object.position = tile_position
				ship.wall_tiles.add_child(_floor_object)
				set_cell(layer, cellpos, -1)

			"wall":

				var _wall_object = wall_scene.instantiate()
				_wall_object.init(ship, cellpos)
				_wall_object.position = tile_position
				ship.wall_tiles.add_child(_wall_object)

				_wall_object.light_occluder.occluder = cell.get_occluder(layer)
				_wall_object.light_occluder.scale = Vector2(1, 1) * Limits.TILE_SCALE
				
				var tile_image := atlas_image.get_region(atlas.get_tile_texture_region(get_cell_atlas_coords(layer, cellpos)))
				
				for i in range(object_direction): tile_image.rotate_90(CLOCKWISE)

				var tile_texture := ImageTexture.create_from_image(tile_image)

				tile_texture.set_size_override(Vector2i(32, 32))
				_wall_object.set_texture(tile_texture)

				set_cell(layer, cellpos, -1)

			"core":
			
				var _core_object = core_scene.instantiate()
				_core_object.init(ship, cellpos)
				_core_object.position = tile_position
				ship.wall_tiles.add_child(_core_object)
				var _floor_object = floor_scene.instantiate()
				_floor_object.init(ship, cellpos)
				_floor_object.position = tile_position
				ship.wall_tiles.add_child(_floor_object)
				set_cell(layer, cellpos, -1)
				
			
			"thruster":
				var _thruster_object = thruster_scene.instantiate()
				_thruster_object.init(ship, cellpos, 150, 5, object_direction)
				_thruster_object.position = tile_position
	
				ship.wall_tiles.add_child(_thruster_object)

				_thruster_object.rotation_degrees = object_direction * 90
				
				set_cell(layer, cellpos, -1)
			
			"connector":
				var _connector_object = connector_scene.instantiate()
				_connector_object.init(ship, cellpos)
				_connector_object.position = tile_position

				ship.wall_tiles.add_child(_connector_object)
				
				_connector_object.rotation_degrees = object_direction * 90

				set_cell(layer, cellpos, -1)

	return true









