class_name ShipSaveFile extends Resource

@export var id : int
@export var path : String
@export var position : Vector2
@export var velocity : Vector2
@export var rotation : float

static func save():
	var files = []

	for ship in Ship.ships:
		var file = ShipSaveFile.new()
		file.id = ship.id
		file.path = ship.path
		file.position = ship.global_position
		file.rotation = ship.rotation
		files.append(file)

	return files

func load(_npcs = [], _items = []):

	var _item_preset = []
	var _npc_preset = []

	for item in _items: if id == item.ship_id: _item_preset.append([item.id, item.type])
	for npc in _npcs: if id == npc.ship_id: _npc_preset.append([npc.id, npc.nickname])


	var custom_object_spawn = CustomObjectSpawn.create(_item_preset, _npc_preset)

	var ship = ShipManager.spawn_ship(position, path, custom_object_spawn)
	ship.rotation = rotation
	ship.linear_velocity = velocity

	# spawn_ship(_position : Vector2, path : String = "station", custom_object_spawn : CustomObjectSpawn = null) -> void:
