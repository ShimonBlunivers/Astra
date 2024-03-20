class_name NPCSaveFile extends Resource

@export var position : Vector2
@export var id : int
@export var skin = []
@export var blocked_missions = []

static func save():
    var files = []

    for npc in NPC.npcs:
        var file = NPCSaveFile.new()
        file.id = npc.id
        file.position = npc.position
        file.skin = npc.sprites.skin
        file.blocked_missions = npc.blocked_missions

        files.append(file)

    return files

func load():
    pass