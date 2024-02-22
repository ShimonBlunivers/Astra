class_name Item extends Node2D

static var item_scenes = [
    preload("res://Items/Chip/Chip.tscn"),
    preload("res://Items/Coin/Coin.tscn"),
]

enum ID {
    chip,
    coin,
}

var ship : Ship;

static func spawn(item : ID, global_coords : Vector2):
    var new_item = item_scenes[item].instantiate()
    var closest_ship = ObjectList.get_closest_ship(global_coords);
    closest_ship.items.add_child(new_item)
    new_item.global_position = global_coords;
    await new_item.ready
    new_item.ship = closest_ship;