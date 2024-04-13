extends Node

var quests = []

static var active_quest_objects = {
	Goal.Type.pick_up_item : [],
	Goal.Type.talk_to_npc : [],
	Goal.Type.go_to_place : [],
}

var active_quest = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Player.main_player == null: return
	UIManager.instance.quest_arrow.visible = quests.size() > 0 && active_quest >= 0 || active_quest == -2
	UIManager.instance.quest_arrow_distance_label.visible = quests.size() > 0 && active_quest >= 0 || active_quest == -2
	if quests.size() > 0 && active_quest >= 0 || active_quest == -2:
		var distance
		if active_quest == -2: distance = (ShipManager.main_station.global_position - Player.main_player.global_position).length()
		else: distance = (get_quest_by_id(active_quest).goal.get_position() - Player.main_player.global_position).length()
		var minimal_range = 150
		var maximal_range = 250

		if distance < 999999 && distance > maximal_range:
			UIManager.instance.quest_arrow_distance_label.rotation = -UIManager.instance.quest_arrow.rotation
			UIManager.instance.quest_arrow_distance_label.text = str(round(distance/100)) + "m"
		else:
			UIManager.instance.quest_arrow_distance_label.text = ""


		if distance < minimal_range:
			UIManager.instance.quest_arrow.visible = false
			UIManager.instance.quest_arrow.modulate.a = 0.75
		else:
			UIManager.instance.quest_arrow.visible = true
			var normalized_distance = clamp((distance - minimal_range) / (maximal_range - minimal_range), 0, 0.75)
			UIManager.instance.quest_arrow.modulate.a = normalized_distance
		if active_quest == -2: UIManager.instance.quest_arrow.rotation = (ShipManager.main_station.global_position - Player.main_player.global_position).angle() - Player.main_player.global_rotation
		else: UIManager.instance.quest_arrow.rotation = (get_quest_by_id(active_quest).goal.get_position() - Player.main_player.global_position).angle() - Player.main_player.global_rotation
		
func update_quest_log():
	var string_to_add = ""
	for quest in quests:
		if quest.id == active_quest: string_to_add += "[u]"
		string_to_add += "\n[url=" + str(quest.id) + "][b]" + quest.title
		if quest.goal.status > 0: string_to_add += " [" + str(quest.goal.status) + "/" + str(quest.goal.finish_status) + "]"
		string_to_add += "[/b][/url]"
		if quest.id == active_quest: 
			string_to_add += "[/u]   [url=cancel" + str(quest.id) + "](X)[/url]"
			string_to_add += "\n" + quest.description
	UIManager.quest_label.text = string_to_add

	string_to_add = "[center][b]"
	if active_quest == -2: string_to_add += "[u]"
	string_to_add += "[url=-2]Hlavní stanice"
	UIManager.main_station_label.text = string_to_add

		

func finished_quest_objective(quest: Quest):
	quest.progress()
	QuestManager.update_quest_log()

func get_quest(target : Node2D) -> Quest:
	for quest in quests: if quest.goal.target == target: return quest
	return null

func get_quest_by_id(id : int) -> Quest:
	for quest in quests: if quest.id == id: return quest
	return null



