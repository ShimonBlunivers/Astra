class_name QuestSaveFile extends Resource

@export var npc_ID : int
@export var id : int
@export var status : int

static func save():
    var files = []

    for quest in QuestManager.quests:
        var file = QuestSaveFile.new()

        file.id = quest.id
        file.npc_ID = quest.npc.id
        file.status = quest.goal.status

        files.append(file)

    return files

func load():
    var quest : Quest= load("res://Quests/Missions/" + str(id) + ".tres")
    quest.init(NPC.get_npc(npc_ID))
    print(NPC.get_npc(npc_ID).nickname)
    quest.goal.status = status


