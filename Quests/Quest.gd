class_name Quest extends Resource

static var number_of_quests = 0

var active := false
@export var id : int
@export var title : String
@export_multiline var description : String

@export var reward : int
@export var goal : Goal
var npc : NPC


func init(_npc : NPC):
    number_of_quests += 1
    npc = _npc
    QuestManager.quests.append(self)
    QuestManager.update_quest_log()

    goal.create(id)

    npc.blocked_missions.append(id)
    QuestManager.active_quest = id


func finish():
    Player.main_player.add_currency(reward)
    QuestManager.quests.erase(self)

func delete():
    QuestManager.quests.erase(self)
    QuestManager.update_quest_log()