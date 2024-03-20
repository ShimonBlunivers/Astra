class_name ItemSaveFile extends Resource

@export var position : Vector2
@export var id : int
@export var type : ItemType

static func save():
    var files = []

    for item in Item.existing_items:
        var file = ItemSaveFile.new()

        file.id = item.id
        file.position = item.global_position
        file.type = item.type

        files.append(file)

    return files

func load():
    pass