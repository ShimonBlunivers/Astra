class_name NPCSaveFile extends Resource


@export var nickname : String
@export var position : Vector2
@export var id : int
@export var skin = []
@export var blocked_missions = []
@export var ship_id : int

static func save():
    var files = []

    for npc in NPC.npcs:
        var file = NPCSaveFile.new()
        file.nickname = npc.nickname
        file.position = npc.position
        file.id = npc.id
        file.skin = npc.sprites.skin
        file.blocked_missions = npc.blocked_missions
        file.ship_id = npc.ship.id

        files.append(file)

    return files

func load():
    pass