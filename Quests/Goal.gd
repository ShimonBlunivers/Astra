class_name Goal

enum Type {
	go_to_place,
	talk_to_npc,
	pick_up_item,
}


var type : Type

var target

func _init(_type : Type, _target):
	type = _type
	target = _target
	QuestManager.active_quest_objects[type].append(target)

func get_position() -> Vector2:
	return target.global_position
