class_name Item extends Node2D

@onready var area = $Area2D

var ship : Ship

var can_pickup = false

static var existing_items = []

static var item_scenes = [
	preload("res://Items/Chip/Chip.tscn"),
	preload("res://Items/Coin/Coin.tscn"),
]

enum Code {
	chip,
	coin,
}

static func get_item(id : int) -> Item:
	return existing_items[id]

static func random_item() -> Code: # IMPLEMENT
	return Code.chip

static func spawn(item : Code, global_coords : Vector2) -> Item: # Returns ID of the item
	var new_item = item_scenes[item].instantiate()
	var closest_ship = ObjectList.get_closest_ship(global_coords)
	closest_ship.items.add_child(new_item)
	new_item.global_position = global_coords
	new_item.ship = closest_ship
	existing_items.append(new_item)
	return new_item

func _physics_process(_delta: float) -> void:
	area.position = (- ship.difference_in_position).rotated(-global_rotation)

func _on_area_2d_input_event(_viewport:Node, event:InputEvent, _shape_idx:int) -> void:
	if event is InputEventMouseButton && event.button_mask == 1 && can_pickup:
		pick_up()

func _on_area_2d_mouse_entered() -> void:
	$Itemtag.visible = true


func _on_area_2d_mouse_exited() -> void:
	$Itemtag.visible = false

func pick_up():
	var tween = create_tween()
	tween.tween_property(self, "global_position", Player.main_player.global_position - Player.main_player.acceleration, (global_position - Player.main_player.global_position).length() / 1200).set_ease(Tween.EASE_OUT)

	await tween.finished

	if self in QuestManager.active_quest_objects[Goal.Type.pick_up_item]:
		QuestManager.finished_quest_objective(QuestManager.get_quest(self))


	queue_free()
