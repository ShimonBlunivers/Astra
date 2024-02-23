class_name Item extends Node2D

@onready var area = $Area2D

var ship : Ship

var ID;

static var number_of_items = 0

static var item_scenes = [
	preload("res://Items/Chip/Chip.tscn"),
	preload("res://Items/Coin/Coin.tscn"),
]

enum Code {
	chip,
	coin,
}


static func spawn(item : Code, global_coords : Vector2) -> int: # Returns ID of the item
	var new_item = item_scenes[item].instantiate()
	var closest_ship = ObjectList.get_closest_ship(global_coords)
	closest_ship.items.add_child(new_item)
	new_item.global_position = global_coords
	new_item.ship = closest_ship
	new_item.ID = number_of_items
	number_of_items += 1
	return new_item.ID

func _physics_process(_delta: float) -> void:
	area.position = (- ship.difference_in_position).rotated(-global_rotation)

func _on_area_2d_input_event(_viewport:Node, event:InputEvent, _shape_idx:int) -> void:
	if event is InputEventMouseButton && event.button_mask == 1:
		print("clicked item")

func _on_area_2d_mouse_entered() -> void:
	$Itemtag.visible = true


func _on_area_2d_mouse_exited() -> void:
	$Itemtag.visible = false
