extends Node2D

func _process(_delta):
	for child in get_children():
		child.material.set_shader_parameter("background_position", global_position)
	global_rotation = 0.0



