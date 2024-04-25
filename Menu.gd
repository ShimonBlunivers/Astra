class_name Menu extends Control


const settings_scene = preload("res://Scenes/Settings.tscn")
const credits_scene = preload("res://Scenes/Credits.tscn")

static var instance

@onready var playbutton = $MarginContainer/VBoxContainer/Play

func _ready():
	instance = self
	$Camera2D.make_current()
	$AudioStreamPlayer.playing = !ObjectList.started_game

	if ObjectList.started_game:
		playbutton.text = "Zpět do hry"

	elif !DirAccess.dir_exists_absolute("user://saves/worlds/last_save"):
		playbutton.queue_free()



func _on_new_game_pressed() -> void:
	if ObjectList.started_game:
		Player.main_player.camera.make_current()
		get_tree().paused = false
		World.instance.visible = true
		World.instance.ui_node.visible = true
		self.queue_free()
		if FileAccess.file_exists(SaveFile.get_save_path()):
			DirAccess.remove_absolute(SaveFile.get_save_path())
		World.instance.new_world()
	else:
		if FileAccess.file_exists(SaveFile.get_save_path()):
			DirAccess.remove_absolute(SaveFile.get_save_path())
		get_tree().change_scene_to_file("res://Scenes/Game.tscn")


func _on_play_pressed() -> void:
	if ObjectList.started_game:
		Player.main_player.camera.make_current()
		get_tree().paused = false
		World.instance.visible = true
		World.instance.ui_node.visible = true

		self.queue_free()
	else:
		get_tree().change_scene_to_file("res://Scenes/Game.tscn")

func _on_settings_pressed() -> void:
	
	visible = false
	
	var root = get_tree().root
	var settings_object = settings_scene.instantiate()
	root.call_deferred("add_child", settings_object)

func _on_credits_pressed() -> void:
	
	visible = false
	
	var root = get_tree().root
	var credits_object = credits_scene.instantiate()
	root.call_deferred("add_child", credits_object)
	

func _on_quit_pressed() -> void:
	get_tree().quit()

