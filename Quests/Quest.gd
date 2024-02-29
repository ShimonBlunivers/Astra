class_name Quest

static var number_of_quests = 0

var active := false
var title : String
var description : String
var goal : Goal
var npc : NPC

func _init(_npc : NPC, _title : String, _description : String, _goal : Goal):
    number_of_quests += 1
    npc = _npc
    title = _title
    description = _description
    goal = _goal
    QuestManager.quests.append(self)
    QuestManager.update_quest_log()

func finish():
    npc.finished_missions.append(npc.active_quest)
    QuestManager.quests.erase(self)
