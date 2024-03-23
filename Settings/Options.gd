extends Node

@export var DEBUG_MODE : bool = true
@export var FULLSCREEN : bool = false


func _unhandled_input(event: InputEvent):
    if event.is_action_pressed("toggle_fullscreen"):
        FULLSCREEN = !FULLSCREEN
        if FULLSCREEN:
            DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
        else:
            DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)