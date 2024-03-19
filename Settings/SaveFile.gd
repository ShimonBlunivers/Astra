class_name SaveFile extends Resource

const SAVE_GAME_PATH := "user://saves/worlds/"

@export var player_save_file : PlayerSaveFile
@export var NPC_save_files = []
@export var item_save_files = []
@export var quest_save_files = []

var save_name : String = "default"

func _init():
    save_name = "test"
    
func get_save_path() -> String:
    var extension := ".tres" if OS.is_debug_build() else ".res"
    return SAVE_GAME_PATH + save_name + "/save_file" + extension

func save_world():
    player_save_file = PlayerSaveFile.save() #
    NPC_save_files = NPCSaveFile.save() #
    item_save_files = ItemSaveFile.save() #
    quest_save_files = QuestSaveFile.save()
    
    DirAccess.make_dir_absolute("user://saves/")
    DirAccess.make_dir_absolute("user://saves/worlds/")
    DirAccess.make_dir_absolute("user://saves/worlds/" + save_name + "/")

    return ResourceSaver.save(self, get_save_path())

func load_world():
    pass