extends Node

var quests = []

var active_quest_objects = {
	Goal.Type.pick_up_item : [],
	Goal.Type.talk_to_npc : [],
	Goal.Type.go_to_place : [],
}

var active_quest = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Player.main_player == null: return
	Player.main_player.quest_arrow.visible = quests.size() > 0 && active_quest >= 0
	if quests.size() > 0 && active_quest >= 0:
		var distance = (get_quest_by_id(active_quest).goal.get_position() - Player.main_player.global_position).length()
		var minimal_range = 150
		var maximal_range = 250

		if distance < minimal_range:
			Player.main_player.quest_arrow.visible = false
			Player.main_player.quest_arrow.modulate.a = 0.75
		else:
			Player.main_player.quest_arrow.visible = true
			var normalized_distance = clamp((distance - minimal_range) / (maximal_range - minimal_range), 0, 0.75)
			Player.main_player.quest_arrow.modulate.a = normalized_distance
			
		Player.main_player.quest_arrow.rotation = (get_quest_by_id(active_quest).goal.get_position() - Player.main_player.global_position).angle() - Player.main_player.global_rotation
		
func update_quest_log():
	var string_to_add = ""
	for quest in quests:
		if quest.id == active_quest: string_to_add += "[u]"
		string_to_add += "\n[url=" + str(quest.id) + "][b]" + quest.title
		if quest.goal.status > 0: string_to_add += "[" + str(quest.goal.status) + "/" + str(quest.goal.finish_status) + "]"
		string_to_add += "[/b][/url]"
		if quest.id == active_quest: string_to_add += "[/u]"
		string_to_add += "\n" + quest.description
	UIManager.quest_label.text = string_to_add
		

func finished_quest_objective(quest: Quest):
	active_quest_objects[quest.goal.type].erase(quest.goal.target)

	quest.goal.status += 1
	match quest.goal.type:
		Goal.Type.pick_up_item:
			quest.goal.type = Goal.Type.talk_to_npc
			quest.goal.target = quest.npc
			quest.goal.update_quest_objects()

	if quest.goal.status == quest.goal.finish_status: quest.finish()

	QuestManager.update_quest_log()

func get_quest(target : Node2D) -> Quest:
	for quest in quests: if quest.goal.target == target: return quest
	return null

func get_quest_by_id(id : int) -> Quest:
	for quest in quests: if quest.id == id: return quest
	return null



