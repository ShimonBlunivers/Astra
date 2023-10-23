extends Control



func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")

func _on_editor_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Editor.tscn")

func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Settings.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
