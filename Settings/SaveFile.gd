class_name SaveFile extends Resource

const SAVE_GAME_PATH := "user://saves/worlds/"
const FIRST_SAVE_GAME_PATH := "res://DefaultSave/worlds/"

@export var player_save_file : PlayerSaveFile
@export var quest_status_file = {}
@export var NPC_save_files = []
@export var item_save_files = []
@export var quest_save_files = []
@export var ship_save_files = []

var save_name : String = "last_save"

func initialize_files():
	DirAccess.make_dir_recursive_absolute("user://saves/ships")
	DirAccess.make_dir_recursive_absolute("user://saves/worlds")


func get_save_path(path := SAVE_GAME_PATH + save_name) -> String:
	var extension := ".tres" if OS.is_debug_build() else ".res"
	return path + "/save_file" + extension

func save_world(dev := false):
	UIManager.instance.saving_screen()

	player_save_file = PlayerSaveFile.save()
	ship_save_files = ShipSaveFile.save()
	NPC_save_files = NPCSaveFile.save()
	item_save_files = ItemSaveFile.save()
	quest_save_files = QuestSaveFile.save()
	quest_status_file = Quest.missions
	

	if !dev:
		DirAccess.make_dir_recursive_absolute("user://saves/worlds/" + save_name + "/")
		return ResourceSaver.save(self, get_save_path())
	
	else:
		return ResourceSaver.save(self, get_save_path(FIRST_SAVE_GAME_PATH))

func load_world():
	if FileAccess.file_exists(get_save_path()):
		World.save_file = ResourceLoader.load(get_save_path())
	else:
		World.save_file = ResourceLoader.load(get_save_path(FIRST_SAVE_GAME_PATH))

	World.save_file.call_deferred("_load")
	
	
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
	
	player_save_file.load() #
	# for npc in NPC_save_files: npc.load() 
	# for item in item_save_files: item.load() 
	for quest in quest_save_files: quest.load() 

	for key in Quest.missions.keys() + quest_status_file.keys():
		if key in quest_status_file.keys(): Quest.missions[key] = quest_status_file[key]



