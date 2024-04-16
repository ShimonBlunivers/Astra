extends Control

@onready var sound_slider = $MarginContainer/VBoxContainer/SoundSlider
@onready var soundtrack_slider = $MarginContainer/VBoxContainer/SoundtrackSlider

func _ready():

	sound_slider.value = (AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")) + 30) / 36 * 100 
	soundtrack_slider.value = (AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")) + 30) / 36 * 100

func save():
	var _value = -30 + 36 * sound_slider.value / 100
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), _value)

	if _value <= -29:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), true)


	_value = -30 + 36 * soundtrack_slider.value / 100
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), _value)

	if _value <= -29:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)
	

func _on_back_pressed():
	save()
	get_tree().change_scene_to_file("res://Scenes/Menu.tscn")


