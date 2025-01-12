class_name QuestSaveFile extends Resource

@export var id : int
@export var npc_ID : int
@export var goal : Goal
@export var status : int
@export var finish_status : int

static func save():
	var files = []

	for quest in QuestManager.active_quests:
		var file = QuestSaveFile.new()

		file.id = quest.id
		file.npc_ID = quest.npc.id
		file.goal = quest.goal
		file.status = quest.goal.status
		file.finish_status = quest.goal.finish_status

		print("----------------------------")
		print("Quest " + str(file.id) + " saved")
		print("NPC ID: " + str(file.npc_ID))
		print("Goal Target ID: " + str(file.goal.target_ID))
		print("Goal Target Type: " + str(file.goal.Type.keys()[file.goal.type]))
		print_debug("----------------------------")
		
		files.append(file)

	return files

func load():
	var quest : Quest = load("res://Quests/Missions/" + str(id) + ".tres")
	quest.init(NPC.get_npc(npc_ID), goal.target_ID)
	quest.goal = goal
	quest.goal.load()
	quest.goal.status = status
	quest.goal.finish_status = finish_status
	
	QuestManager.update_quest_log()
	
	print("----------------------------")
	print("Quest: " + str(id) + " loaded")
	print("NPC ID: " + str(npc_ID))
	print("Goal Target ID: " + str(goal.target_ID))
	print("Goal Target Type: " + str(goal.Type.keys()[goal.type]))
	print_debug("----------------------------")




