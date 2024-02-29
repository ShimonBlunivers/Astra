extends Node

var quests = []

var active_quest_objects = {
	Goal.Type.pick_up_item : [],
	Goal.Type.talk_to_npc : [],
	Goal.Type.go_to_place : [],
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Player.main_player == null: return
	Player.main_player.quest_arrow.visible = quests.size() > 0
	if quests.size() > 0:
		Player.main_player.quest_arrow.rotation = (quests[0].goal.get_position() - Player.main_player.global_position).angle() - Player.main_player.global_rotation
		
func update_quest_log():
	if quests.size() > 0:
		UIManager.set_quest_text("")
		for quest in quests:
			UIManager.set_quest_text(UIManager.get_quest_text() + "\n" + quest.title)

func picked_quest_item(item: Item):
	active_quest_objects[Goal.Type.pick_up_item].erase(item)
	print(quests)
	for quest in quests:
		print(quest.goal.target)
		if quest.goal.type == Goal.Type.pick_up_item:
			print(quest.goal.target)
			quest.goal = Goal.new(Goal.Type.talk_to_npc, quest.npc)
	

