class_name Quest extends Resource

static var number_of_quests = 0

var active := false
@export var id : int
@export var title : String
@export_multiline var description : String

@export var reward : int
@export var goal : Goal
var npc : NPC


func init(_npc : NPC, _target_ID : int = -1):
    number_of_quests += 1
    npc = _npc
    QuestManager.quests.append(self)

    if _target_ID != -1: goal.target_ID = _target_ID

    goal.create(id)

    npc.blocked_missions.append(id)
    QuestManager.active_quest = id
    QuestManager.update_quest_log()


func finish():
    Player.main_player.add_currency(reward)
    QuestManager.quests.erase(self)

func delete():
    number_of_quests -= 1
    QuestManager.quests.erase(self)
    QuestManager.update_quest_log()

func progress():
    goal.status += 1
    update_goal()

func force_status(status : int):
    goal.status = status
    update_goal()

func update_goal():
    QuestManager.active_quest_objects[goal.type].erase(goal.target)
    match goal.type:
        Goal.Type.pick_up_item: 
            goal.type = Goal.Type.talk_to_npc
            goal.target = npc
            goal.update_quest_objects()

    if goal.status >= goal.finish_status: finish()