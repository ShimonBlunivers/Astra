class_name Item extends Node2D

@onready var area = $Area2D
@onready var sprite = $Sprite2D
@onready var collision_shape = $Area2D/CollisionShape2D
@onready var itemtag = $Itemtag


var ship : Ship

var can_pickup = false

var id : int

static var existing_items = []

static var item_scene = preload("res://Items/Item.tscn")

static var types = {}

static func get_item(_id : int) -> Item:
	for item in existing_items: if item.id == _id: return item
	return null

static func random_item() -> ItemType: # IMPLEMENT
	return types["Chip"]

static func spawn(item_type : ItemType, global_coords : Vector2, _id : int = -1) -> Item:
	var new_item = item_scene.instantiate()
	var closest_ship = ObjectList.get_closest_ship(global_coords)
	closest_ship.items.add_child(new_item)
	new_item.global_position = global_coords
	new_item.ship = closest_ship
	new_item.sprite.texture = item_type.texture
	new_item.collision_shape.shape = item_type.shape
	new_item.itemtag.text = item_type.nickname

	if _id != -1 && Item.get_item(_id) == null:
		new_item.id = _id
	else:
		_id = existing_items.size()
		while true:
			if Item.get_item(_id) == null:
				new_item.id = _id
				break

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
