extends Control

func _on_new_game_pressed() -> void:
	if FileAccess.file_exists(SaveFile.get_save_path()):
		DirAccess.remove_absolute(SaveFile.get_save_path())
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")

func _on_editor_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Editor.tscn")

func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Settings.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

