class_name Goal extends Resource

enum Type {
	go_to_place,
	talk_to_npc,
	pick_up_item,
}

@export var type : Type
@export var target_ID : int
## Doesn't matter if the type isn't "pick_up_item".
@export var item_type : String = "Chip"
@export var difficulty_multiplier : int = 1

var mission_id : int

var target : Node2D

var status : int
var finish_status : int

func create(_mission_id : int):
	if target_ID < 0:
		spawn_quest_ship()
	match type:
		Type.go_to_place:
			finish_status = 1
		Type.talk_to_npc:
			target = NPC.get_npc(target_ID)
			finish_status = 1
		Type.pick_up_item:
			target = Item.get_item(target_ID)
			finish_status = 2
	
	status = 0
	update_quest_objects()

func update_quest_objects():
	QuestManager.active_quest_objects[type].append(target)

func load():
	
	match type:
		Type.go_to_place:
			finish_status = 1
		Type.talk_to_npc:
			target = NPC.get_npc(target_ID)
			finish_status = 1
		Type.pick_up_item:
			target = Item.get_item(target_ID)
			finish_status = 2
	update_quest_objects()

func get_position() -> Vector2:
	if target == null: return Vector2.ZERO
	return target.global_position

func spawn_quest_ship():

	var distances = Vector2(10000 + 5000 * World.difficulty_multiplier * difficulty_multiplier, 100000 + 5000 * World.difficulty_multiplier * (difficulty_multiplier + 1)) #Vector2(10000, 50000)

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
			_custom_object_spawn = CustomObjectSpawn.create(null, [[target_ID, NPC.names.pick_random(), [NPC.Roles.CIVILIAN], null, null, null]])
		Type.pick_up_item:
			target_ID = Item.get_uid()							# [id, 		type, 			ship_slot_id]
			_custom_object_spawn = CustomObjectSpawn.create([[target_ID, Item.types[item_type], 0]])

	var new_ship = ShipManager.spawn_ship(new_ship_pos, ShipManager.get_quest_ship_path(mission_id), _custom_object_spawn)

	new_ship.linear_velocity = Player.main_player.parent_ship.linear_velocity
