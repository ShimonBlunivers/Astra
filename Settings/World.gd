class_name World extends Node2D

static var instance : World

var _center_of_universe = Vector2.ZERO

static var save_file : SaveFile

static var used_builder : Builder = null

static var difficulty_multiplier : float = 0

@onready var canvas_modulate = $CanvasModulate
@onready var ui_node = $UI

const editor_scene = preload("res://Scenes/Editor.tscn")
const menu_scene = preload("res://Scenes/Menu.tscn")


func load_missions():
	var path = "res://Quests/Missions"
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				if '.tres.remap' in file_name: # <---- NEW
					file_name = file_name.trim_suffix('.remap') # <---- NEW
				if ".tres" in file_name:
					load(path + "/" + file_name).create()
			file_name = dir.get_next()


func _ready():
	World.instance = self
	DisplayServer.window_set_max_size(Vector2i(3840, 2160))
	ObjectList.started_game = true
	load_missions()

	save_file = SaveFile.new()
	save_file.initialize_files()
	
static func reset_values():
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
	
	Item.items = []
	Item.item_id_history = []
	NPC.npcs = []
	QuestManager.quests = []


	Player.main_player.health = Player.main_player.max_health
	Player.main_player.currency = 0
	Player.main_player.currency_updated_signal.emit()

	World.instance._center_of_universe = Vector2.ZERO
	World.instance.transform.origin = Vector2.ZERO
	

func new_world():

	# var tree := World.instance.get_tree().get_root()
	# World.instance.free()
	# tree.add_child(load("res://Scenes/Game.tscn").instantiate())

	save_file = SaveFile.new()
	save_file.initialize_files()
	
	World.reset_values()
	ShipManager.randomly_generate_ships()
	
	Player.main_player.spawn()

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("game_toggle_menu"):
		open_menu()

func shift_origin(by:Vector2):
	global_position += by
	_center_of_universe += by

func get_distance_from_center(pos : Vector2) -> Vector2:
	return pos
	# return pos - _center_of_universe

func _process(_delta):
	if !Options.DEVELOPMENT_MODE: return
	queue_redraw()

func _draw():
	if !Options.DEVELOPMENT_MODE: return
	draw_circle(-_center_of_universe , 25 , Color.LIGHT_BLUE)

func open_editor(_builder : Builder = null):
	used_builder = _builder
	
	visible = false
	ui_node.visible = false
	var root = get_tree().root
	# root.remove_child(self)
	get_tree().paused = true
	var editor_object = editor_scene.instantiate()
	root.call_deferred("add_child", editor_object)

# func _unhandled_input(event: InputEvent):
# 	if Options.DEVELOPMENT_MODE:
# 		if event.is_action_pressed("game_toggle_menu"):
# 			open_editor()


func open_menu():
	#visible = false
	#ui_node.visible = false
	var root = get_tree().root
	# root.remove_child(self)
	get_tree().paused = true
	var menu_object = menu_scene.instantiate()
	root.call_deferred("add_child", menu_object)




func _on_audio_stream_player_finished() -> void:
	$AudioStreamPlayer.play()
