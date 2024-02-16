class_name UIManager extends CanvasLayer


@onready var player = $"../Player" 

@onready var health_label = $HUD/HealthBar/Value

@onready var death_screen = $HUD/DeathScreen

@onready var _quest_label = $HUD/QuestLog/RichTextLabel

static var quest_label;
# DEBUG

@onready var floating = $Debug/Floating
@onready var player_position = $Debug/PlayerPosition


func _ready():
	health_label.text = str(player.health)
	quest_label = _quest_label;
	UIManager.set_quest_text("XD")

func _on_player_health_updated_signal() -> void:
	health_label.text = str(player.health)
	death_screen.visible = !player.alive

static func set_quest_text(_text : String):
	quest_label.text = _text
	
# DEBUG

func _process(_delta):
	floating.visible = player.floating()
	player_position.text = "X: " + str(round(player.global_position.x)) + ", Y: " + str(round(player.global_position.y))

