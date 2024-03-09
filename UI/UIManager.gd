class_name UIManager extends CanvasLayer


@onready var player = $"../Player" 

@onready var health_label = $HUD/HealthBar/Value

@onready var death_screen = $HUD/DeathScreen

@onready var _quest_label = $HUD/Inventory/QuestLog/RichTextLabel	

@onready var inventory = $HUD/Inventory

static var quest_label

var inventory_open = true
var inventory_positions = Vector2(0, -500) # open, closed
# DEBUG

@onready var floating = $Debug/Floating
@onready var player_position = $Debug/PlayerPosition


func _ready():
	health_label.text = str(player.health)
	quest_label = _quest_label

func _on_player_health_updated_signal() -> void:
	health_label.text = str(player.health)
	death_screen.visible = !player.alive

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("game_toggle_inventory"):
		inventory_open = !inventory_open
		var tween = create_tween()
		var duration = 0.5
		if inventory_open: tween.tween_property(inventory, "position", Vector2(inventory_positions.x, 0), duration).set_ease(Tween.EASE_OUT) # FIX VECTORS PLS
		else: tween.tween_property(inventory, "position", Vector2(inventory_positions.y, 0), duration).set_ease(Tween.EASE_IN)

func _on_quest_meta_clicked(meta:Variant) -> void:
		
	if QuestManager.active_quest == int(meta):
		QuestManager.active_quest = -1
	else:
		QuestManager.active_quest = int(meta)
		
	QuestManager.update_quest_log()

# DEBUG

func _process(_delta):
	floating.visible = player.floating()
	player_position.text = "X: " + str(round(player.global_position.x)) + ", Y: " + str(round(player.global_position.y))

