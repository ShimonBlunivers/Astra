extends CanvasLayer


@onready var player = $"../Player" 

@onready var health_label = $HUD/HealthBar/Value

@onready var death_screen = $HUD/DeathScreen

# DEBUG

@onready var floating = $Debug/Floating
@onready var player_position = $Debug/PlayerPosition



func _ready():
	health_label.text = str(player.health)

func _on_player_health_updated_signal() -> void:
	health_label.text = str(player.health)
	death_screen.visible = !player.alive
	

# DEBUG

func _process(_delta):
	floating.visible = player.floating()
	player_position.text = "X: " + str(round(player.position.x)) + ", Y: " + str(round(player.position.y))

