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

	if target_ID < 0:
		spawn_quest_ship()

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


func spawn_quest_ship():

	var distances = Vector2(1000, 2500)

	var rng = RandomNumberGenerator.new()

	var _distance = rng.randf_range(distances.x, distances.y)
	var _angle = rng.randf_range(0, 2 * PI)

	var new_ship_pos = Vector2(Player.main_player.global_position.x + _distance * cos(_angle), Player.main_player.global_position.y + _distance * sin(_angle))
	
	var _custom_object_spawn : CustomObjectSpawn;
	
	match type:
		Type.go_to_place:
			pass
		Type.talk_to_npc:
			target_ID = NPC.get_uid()
			_custom_object_spawn = CustomObjectSpawn.create(null, [target_ID, "Questie"])
		Type.pick_up_item:
			target_ID = Item.get_uid()
			_custom_object_spawn = CustomObjectSpawn.create([target_ID, Item.types["Chip"]], null)

	ShipManager.spawn_ship(new_ship_pos, ShipManager.get_quest_ship_path(), _custom_object_spawn)