extends Node

var quest_resources = []
var active_quests = []
var active_quest_id = -1

static var active_objectives = {
	Goal.Type.pick_up_item : [],
	Goal.Type.talk_to_npc : [],
	Goal.Type.go_to_place : [],
}

# func _ready():
# 	var dir = DirAccess.open("res://Quests/Missions")
# 	if dir:
# 		dir.list_dir_begin()
# 		var file_name = dir.get_next()
# 		while file_name != "":
# 			if !dir.current_is_dir():
# 				var quest_resource : Quest = load("res://Quests/Missions/" + file_name)
# 				if quest_resource: 
# 					quest_resources.call_deferred("init", quest_resource)
# 					quest_resources.append(quest_resource)
# 				else: printerr("Error: Failed to load quest resource " + file_name)
# 			file_name = dir.get_next()
# 		dir.list_dir_end()

func _process(_delta):
	if UIManager.instance:
		UIManager.instance.quest_arrow.visible = active_quests.size() > 0 && active_quest_id >= 0 || active_quest_id == -2
		UIManager.instance.quest_arrow_distance_label.visible = active_quests.size() > 0 && active_quest_id >= 0 || active_quest_id == -2
		if active_quests.size() > 0 && active_quest_id >= 0 || active_quest_id == -2:
			var distance
			if active_quest_id == -2: distance = (ShipManager.main_station.global_position - Player.main_player.global_position).length()
			else: distance = (get_quest_by_id(active_quest_id).goal.get_position() - Player.main_player.global_position).length()
			var minimal_range = 150
			var maximal_range = 250

			if distance < 999999 && distance > maximal_range:
				UIManager.instance.quest_arrow_distance_label.rotation = -UIManager.instance.quest_arrow.rotation
				UIManager.instance.quest_arrow_distance_label.text = str(round(distance/100)) + "units"
			else:
				UIManager.instance.quest_arrow_distance_label.text = ""

			if distance < minimal_range:
				UIManager.instance.quest_arrow.visible = false
				UIManager.instance.quest_arrow.modulate.a = 0.75
			else:
				UIManager.instance.quest_arrow.visible = true
				var normalized_distance = clamp((distance - minimal_range) / (maximal_range - minimal_range), 0, 0.75)
				UIManager.instance.quest_arrow.modulate.a = normalized_distance
			if active_quest_id == -2: UIManager.instance.quest_arrow.rotation = (ShipManager.main_station.global_position - Player.main_player.global_position).angle() - Player.main_player.global_rotation
			else: UIManager.instance.quest_arrow.rotation = (get_quest_by_id(active_quest_id).goal.get_position() - Player.main_player.global_position).angle() - Player.main_player.global_rotation
			
func update_quest_log():
	var string_to_add = ""
	for quest in active_quests:
		if quest.id == active_quest_id: string_to_add += "[u]"
		string_to_add += "\n[url=" + str(quest.id) + "][b]" + quest.title
		if quest.goal.status > 0: string_to_add += " [" + str(quest.goal.status) + "/" + str(quest.goal.finish_status) + "]"
		string_to_add += "[/b][/url]"
		if quest.id == active_quest_id: 
			string_to_add += "[/u] [url=cancel" + str(quest.id) + "](X)[/url]"
			string_to_add += "\n" + quest.description
	UIManager.quest_label.text = string_to_add

	string_to_add = "[center][b]"
	if active_quest_id == -2: string_to_add += "[u]"
	string_to_add += "[url=-2]Hlavní stanice"
	UIManager.main_station_label.text = string_to_add

func finished_quest_objective(quest: Quest):
	quest.progress()
	QuestManager.update_quest_log()

func get_quest(target : Node2D) -> Quest:
	for quest in active_quests: if quest.goal.target == target: return quest
	print_debug("Warning: No quest found for target " + str(target))
	return null

func get_quest_by_id(id : int) -> Quest:
	for quest in active_quests: if quest.id == id: return quest
	print_debug("Warning: No quest found for id " + str(id))
	return null



