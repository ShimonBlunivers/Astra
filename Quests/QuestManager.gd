extends Node

var quests = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	Player.main_player.quest_arrow.visible = quests.size() > 0
	if quests.size() > 0:
		Player.main_player.quest_arrow.rotation = (quests[0].goal.get_position() - Player.main_player.global_position).angle() - Player.main_player.global_rotation
		
func update_quest_log():
	if quests.size() > 0:
		UIManager.set_quest_text("")
		for quest in quests:
			UIManager.set_quest_text(UIManager.get_quest_text() + "\n" + quest.title)