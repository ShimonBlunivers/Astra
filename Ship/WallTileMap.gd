extends TileMap


const door_scene = preload("res://Ship/Walls/Door/Door.tscn")
const wall_scene = preload("res://Ship/Walls/Wall/Wall.tscn")

var ship = null


func _load_hitbox(_layer: int):

	ship.hitbox.polygon = simplifyEdges(toShape(deleteEdges(createEdges(_layer))))
	ship.visual.polygon = ship.hitbox.polygon
	ship.area.polygon = ship.hitbox.polygon

	ship.hitbox.scale = scale
	ship.visual.scale = scale
	ship.area.scale = scale


func getPoints(tile: Vector2i):
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

func getPointsRect(rect: Rect2):
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
func getLines(points):
	return [
		[points[0], points[1]],
		[points[1], points[2]],
		[points[2], points[3]],
		[points[3], points[0]]
	]
func createEdges(layer: int):
	var edges = []
	var grid = get_used_cells(layer)
	for tile in grid:
		for line in getLines(getPoints(tile)):
			edges.append(line)
	return edges
func deleteEdges(edges):
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
func toShape(edges):
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

func simplifyEdges(edges):
	var result = []
	var point = edges[0]
	var checking = edges[1]
	var vector
	for idx in range(1, edges.size() + 2):
		vector = point - checking
		checking = edges[idx%edges.size()]
		var newVector = point - checking
		var viable : bool = false
		if vector == newVector:	
			viable = true
		
		elif newVector.x == 0 && vector.x == 0:
			viable = true
				
		elif newVector.y == 0 && vector.y == 0:
			viable = true
			
		elif newVector.x != 0 && newVector.y != 0 && vector.x / newVector.x == vector.y / newVector.y:
			viable = true

		if !viable:
			result.append(edges[idx%edges.size() - 1])
			point = checking
	
	return result

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

	_load_hitbox(layer)

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
				_door_object.init(ship)
				ship.mass += _door_object.mass
				_door_object.direction = cell.get_custom_data("direction")
				_door_object.position = map_to_local(cellpos)
				add_child(_door_object)
				set_cell(layer, cellpos, -1)
			
			"wall":


				var _wall_object = wall_scene.instantiate()
				_wall_object.init(ship)
				ship.mass += _wall_object.mass
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
