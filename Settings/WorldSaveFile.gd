class_name WorldSaveFile extends Resource

@export var position : Vector2
@export var center_of_universe : Vector2

static func save() -> WorldSaveFile:
    var file = WorldSaveFile.new()

    file.position = World.instance.transform.origin
    file.center_of_universe = World.instance._center_of_universe

    return file


func load():
    return
    World.instance.transform.origin = position
    World.instance._center_of_universe = center_of_universe