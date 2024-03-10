class_name UIManager extends CanvasLayer


@onready var health_label = $HUD/HealthBar/Value
@onready var currency_label = $HUD/Currency/Value

@onready var death_screen = $HUD/DeathScreen

@onready var _quest_label = $HUD/Inventory/QuestLog/RichTextLabel	

@onready var inventory = $HUD/Inventory

static var quest_label
static var add_currency_label
static var remove_currency_label
static var currency_node

var inventory_open = false
var inventory_positions = Vector2(0, -500) # open, closed
# DEBUG

@onready var floating = $Debug/Floating
@onready var player_position = $Debug/PlayerPosition

static func currency_change_effect(amount : int):
	var label
	if amount > 0:
		label = add_currency_label.duplicate()
		label.text = "+" + str(amount)	
	elif amount < 0:
		label = remove_currency_label.duplicate()
		label.text = str(amount)	
	else: return
	label.visible = true
	currency_node.add_child(label)
	var _start_position = label.position
	var tween = label.create_tween()
	var duration = 1
	label.modulate = Color.WHITE
	tween.parallel().tween_property(label, "position", _start_position + Vector2(0, -50), duration)
	tween.parallel().tween_property(label, "modulate", Color(1, 1, 1, 0), duration).set_ease(Tween.EASE_IN)

	await tween.finished
	
	label.queue_free()

	
func _ready():
	health_label.text = str(Player.main_player.health)
	currency_label.text = str(Player.main_player.currency)
	quest_label = _quest_label
	currency_node = $HUD/Currency
	add_currency_label = $HUD/Currency/AddCurrencyLabel
	remove_currency_label = $HUD/Currency/RemoveCurrencyLabel

func _on_player_health_updated_signal() -> void:
	health_label.text = str(Player.main_player.health)
	death_screen.visible = !Player.main_player.alive 

func _on_player_currency_updated_signal() -> void:
	currency_label.text = str(Player.main_player.currency)

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
	floating.visible = Player.main_player.floating()
	player_position.text = "X: " + str(round(Player.main_player.global_position.x)) + ", Y: " + str(round(Player.main_player.global_position.y))

