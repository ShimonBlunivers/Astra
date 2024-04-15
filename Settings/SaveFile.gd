class_name SaveFile extends Resource

const SAVE_GAME_PATH := "user://saves/worlds/"
const FIRST_SAVE_GAME_PATH := "res://DefaultSave/worlds/"

@export var player_save_file : PlayerSaveFile
@export var main_station_id : int
@export var quest_status_file = {}
@export var NPC_save_files = []
@export var item_save_files = []
@export var quest_save_files = []
@export var ship_save_files = []

static var save_name : String = "last_save"

func initialize_files():
	DirAccess.make_dir_recursive_absolute("user://saves/ships")
	DirAccess.make_dir_recursive_absolute("user://saves/worlds")

static func get_save_path(path := SAVE_GAME_PATH + save_name) -> String:
	return path + "/save_file.tres"

func save_world(dev := false):
	UIManager.instance.saving_screen()

	player_save_file = PlayerSaveFile.save()
	main_station_id = ShipManager.main_station.id
	ship_save_files = ShipSaveFile.save()
	NPC_save_files = NPCSaveFile.save()
	item_save_files = ItemSaveFile.save()
	quest_save_files = QuestSaveFile.save()
	quest_status_file = Quest.missions
	
	if DirAccess.dir_exists_absolute("user://saves/ships/%player_ship_new"):
		if DirAccess.dir_exists_absolute("user://saves/ships/%player_ship_old"): delete_directory("user://saves/ships/%player_ship_old")
		DirAccess.rename_absolute("user://saves/ships/%player_ship_new", "user://saves/ships/%player_ship_old")

	if !dev:
		DirAccess.make_dir_recursive_absolute("user://saves/worlds/" + save_name + "/")
		return ResourceSaver.save(self, SaveFile.get_save_path())
	else:
		return ResourceSaver.save(self, SaveFile.get_save_path(FIRST_SAVE_GAME_PATH))

func load_world():
	if FileAccess.file_exists(SaveFile.get_save_path()):
		World.save_file = ResourceLoader.load(SaveFile.get_save_path())
		World.save_file.call_deferred("_load")
	
	else:
		World.instance.new_world()
		# World.save_file = ResourceLoader.load(get_save_path(FIRST_SAVE_GAME_PATH))
		# World.save_file.call_deferred("_load")

	
func _load(): # deferred
	UIManager.instance.loading_screen()
	while Ship.ships.size() != 0: Ship.ships[0].delete()
	while NPC.npcs.size() != 0: NPC.npcs[0].delete()
	while Item.items.size() != 0: Item.items[0].delete()
	while QuestManager.quests.size() != 0: QuestManager.quests[0].delete()
	QuestManager.active_quest = -1
	QuestManager.active_quest_objects = {
		Goal.Type.pick_up_item : [],
		Goal.Type.talk_to_npc : [],
		Goal.Type.go_to_place : [],
	}
	# var tree := World.instance.get_tree().get_root()
	# World.instance.free()
	# tree.add_child(load("res://Scenes/Game.tscn").instantiate())

	World.instance._center_of_universe = Vector2.ZERO
	World.instance.transform.origin = Vector2.ZERO

	for ship in ship_save_files: ship.load(NPC_save_files, item_save_files) 
	ShipManager.main_station = Ship.get_ship(main_station_id)
	ShipManager.main_station.freeze = true

	player_save_file.load()
	Player.main_player.owned_ship.linear_damp = 0

	# for npc in NPC_save_files: npc.load() 
	# for item in item_save_files: item.load() 
	for quest in quest_save_files: quest.load() 

	for key in Quest.missions.keys() + quest_status_file.keys():
		if key in quest_status_file.keys(): Quest.missions[key] = quest_status_file[key]



func delete_directory(path: String) -> bool:
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				if !delete_directory(path + "/" + file_name): return false
			else:
				dir.remove(path + "/" + file_name)
			file_name = dir.get_next()
		dir.remove(path)
		return true
	else: return false