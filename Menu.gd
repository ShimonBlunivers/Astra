extends Control

func _ready():
	$Camera2D.make_current()

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

func _on_editor_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Editor.tscn")

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Credits.tscn")
	
func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Settings.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

