# class_name QuestIntance

# var active := false
# @export var title : String
# @export_multiline var description : String

# @export var reward : int
# @export var goal : Goal

# @export var world_limit : int = -1
# ## Required roles for NPC to give this mission
# @export var role : NPC.Roles
# ## Roles that will be added to the NPC, if he gives this mission
# @export var add_role_on_accept : NPC.Roles

# var npc : NPC

# var times_activated : int = 0

# static var missions = {}

# func create():
# 	missions[id] = self

# func init(_npc : NPC, _target_ID : int = -1):
	
# 	# print("#############")
# 	# print("Quest title: " + title)
# 	# print("Target ID: " + str(_target_ID))
	
# 	if world_limit > 0: missions[id].times_activated += 1
# 	npc = _npc
# 	QuestManager.active_quests.append(self)

# 	if _target_ID != -1: goal.target_ID = _target_ID

# 	goal.create(id)

# 	if !add_role_on_accept in npc.roles: npc.roles.append(add_role_on_accept)

# 	NPC.blocked_missions.append(id)
# 	npc.selected_quest = -1
# 	npc.active_quest = id
# 	QuestManager.active_quest_id = id
# 	QuestManager.update_quest_log()

# func finish():
# 	NPC.blocked_missions.erase(id)
# 	npc.quest_finished()
# 	Player.main_player.add_currency(reward)
# 	QuestManager.active_objectives[goal.type].erase(goal.target)
# 	QuestManager.active_quest_id = -1
# 	QuestManager.active_quests.erase(self)
# 	World.difficulty_multiplier += 0.2

# func delete():
# 	NPC.blocked_missions.erase(id)
# 	if world_limit > 0: missions[id].times_activated -= 1
# 	npc.selected_quest = -1
# 	npc.active_quest = -1
# 	number_of_quests -= 1
# 	QuestManager.active_quests.erase(self)
# 	QuestManager.active_objectives[goal.type].erase(goal.target)
# 	QuestManager.update_quest_log()

# func progress():
# 	# print("!!!!!!!!!!!!!!!!!!!!!!!")
# 	# print_debug("Progressing quest: " + title)
# 	goal.status += 1
# 	update_goal()

# func update_goal():
# 	QuestManager.active_objectives[goal.type].erase(goal.target)
# 	match goal.type:
# 		Goal.Type.pick_up_item: 
# 			goal.type = Goal.Type.talk_to_npc
# 			goal.target = npc
# 			goal.target_ID = npc.id
# 			goal.update_quest_objects()

# 	if goal.status >= goal.finish_status: finish()

