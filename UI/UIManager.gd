extends CanvasLayer

@onready var floating = $Floating
@onready var player_position = $PlayerPosition
@onready var player = $"../Player" 

func _process(_delta):
	floating.visible = player.floating()
	player_position.text = "X: " + str(round(player.position.x)) + ", Y: " + str(round(player.position.y))
