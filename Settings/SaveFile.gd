class_name SaveFile extends Resource

const SAVE_GAME_PATH := "user://saves/worlds/"

@export var player_save_file : PlayerSaveFile
@export var NPC_save_files = []
@export var item_save_files = []
@export var quest_save_files = []
@export var ship_save_files = []

var save_name : String = "default"

func _init():
	save_name = "test"
	
func get_save_path() -> String:
	var extension := ".tres" if OS.is_debug_build() else ".res"
	return SAVE_GAME_PATH + save_name + "/save_file" + extension

func save_world():

	player_save_file = PlayerSaveFile.save() #
	ship_save_files = ShipSaveFile.save() #
	NPC_save_files = NPCSaveFile.save() #
	item_save_files = ItemSaveFile.save() #
	quest_save_files = QuestSaveFile.save() #
	
	DirAccess.make_dir_absolute("user://saves/")
	DirAccess.make_dir_absolute("user://saves/worlds/")
	DirAccess.make_dir_absolute("user://saves/worlds/" + save_name + "/")

	print("SAVED")
	return ResourceSaver.save(self, get_save_path())

func load_world():
	World.save_file = ResourceLoader.load(get_save_path())
	World.save_file.call_deferred("_load")
	
	
func _load(): # deferred
	for ship in ObjectList.SHIPS:
		print("deleted ", ship.name)
		ship.delete()
	for npc in NPC.npcs: npc.delete()
	for quest in QuestManager.quests: quest.delete()

	# var tree := World.instance.get_tree().get_root()
	# World.instance.free()
	# tree.add_child(load("res://Scenes/Game.tscn").instantiate())

	player_save_file.load() #
	for ship in ship_save_files: ship.load() 
	for npc in NPC_save_files: npc.load() 
	for item in item_save_files: item.load() 
	for quest in quest_save_files: quest.load() 