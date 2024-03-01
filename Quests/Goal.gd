class_name Goal extends Resource

enum Type {
	go_to_place,
	talk_to_npc,
	pick_up_item,
}

@export var type : Type
@export var target_ID : int
var target : Node2D

func create():
	match type:
		Type.go_to_place:
			pass
		Type.talk_to_npc:
			target = NPC.get_npc(target_ID)
		Type.pick_up_item:
			target = Item.get_item(target_ID)

	update_quest_objects()

func update_quest_objects():
	QuestManager.active_quest_objects[type].append(target)

func get_position() -> Vector2:
	return target.global_position
