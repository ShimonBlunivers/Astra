extends Node2D

@onready var floating = $Floating
@onready var player = $"../Player" 

func _process(_delta):
	floating.visible = player.floating()
