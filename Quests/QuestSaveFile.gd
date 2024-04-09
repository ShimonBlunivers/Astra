class_name QuestSaveFile extends Resource

@export var id : int
@export var npc_ID : int
@export var goal : Goal

static func save():
	var files = []

	for quest in QuestManager.quests:
		var file = QuestSaveFile.new()

		file.id = quest.id
		file.npc_ID = quest.npc.id
		file.goal = quest.goal

		files.append(file)

	return files

func load():
	var quest : Quest = load("res://Quests/Missions/" + str(id) + ".tres")
	quest.init(NPC.get_npc(npc_ID), goal.target_ID)
	quest.goal = goal
	quest.goal.load()


