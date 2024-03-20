class_name ShipSaveFile extends Resource

@export var path : String
@export var position : Vector2
@export var velocity : Vector2
@export var rotation : float

static func save():
    var files = []

    for ship in ObjectList.SHIPS:
        var file = ShipSaveFile.new()
        file.path = ship.path
        file.position = ship.global_position
        file.rotation = ship.rotation
        files.append(file)

    return files

func load():

    var ship = ShipManager.spawn_ship(position, path)
    ship.rotation = rotation
    ship.linear_velocity = velocity

    # spawn_ship(_position : Vector2, path : String = "station", custom_object_spawn : CustomObjectSpawn = null) -> void: