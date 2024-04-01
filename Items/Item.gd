class_name Item extends Node2D

@onready var area = $Area2D
@onready var sprite = $Sprite2D
@onready var collision_shape = $Area2D/CollisionShape2D
@onready var itemtag : Label = $Itemtag

var ship : Ship = null

var ship_slot_id : int

var can_pickup = false

var id : int

var type : ItemType

static var items = []

static var item_id_history = []

static var item_scene = preload("res://Items/Item.tscn")

static var types = {}

static func get_uid() -> int:
	var _id = 0
	while true:
		if Item.get_item(_id) == null && !(_id in item_id_history):
			return _id
		_id += 1
	return 0
static func load_items():
	var path = "res://Items/ItemTypes"
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if ".tres" in file_name:
				load(path + "/" + file_name).create()
			file_name = dir.get_next()

static func get_item(_id : int) -> Item:
	for item in items: if item.id == _id: return item
	return null

static func random_item() -> ItemType: # IMPLEMENT
	return types[types.keys().pick_random()]

static func spawn(_type : ItemType, global_coords : Vector2, _id : int = -1, _ship = null, _ship_slot_id : int = -1) -> Item:
	var new_item = item_scene.instantiate()
	new_item.type = _type

	if _ship != null:
		new_item.ship = _ship
		new_item.ship.items.add_child(new_item)
	else:
		var closest_ship = ObjectList.get_closest_ship(global_coords)
		closest_ship.items.add_child(new_item)
		new_item.ship = closest_ship

	new_item.ship_slot_id = _ship_slot_id
	new_item.ship.used_item_slots += 1

	new_item.global_position = global_coords

	if _id != -1 && Item.get_item(_id) == null:
		new_item.id = _id
	else:
		_id = 0
		while true:
			if Item.get_item(_id) == null:
				new_item.id = _id
				break
			_id += 1

	items.append(new_item)
	item_id_history.append(new_item.id)
	return new_item

func _ready() -> void:
	sprite.texture = type.texture
	collision_shape.shape = type.shape

	sprite.scale =  Vector2(collision_shape.shape.get_size().x / sprite.texture.get_size().x, collision_shape.shape.get_size().x / sprite.texture.get_size().x)
	
	itemtag.position.y -= (collision_shape.shape.get_size().y / 2) + 12

	itemtag.text = type.nickname

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
	$PickedUpSound.play()
	var tween = create_tween()
	tween.tween_property(self, "global_position", Player.main_player.global_position - Player.main_player.acceleration, (global_position - Player.main_player.global_position).length() / 1200).set_ease(Tween.EASE_OUT)

	await tween.finished

	if self in QuestManager.active_quest_objects[Goal.Type.pick_up_item]:
		QuestManager.finished_quest_objective(QuestManager.get_quest(self))

	visible = false


func delete():
	ship.used_item_slots -= 1
	items.erase(self)
	ship.pickedup_items.append(id)
	queue_free()


func _on_picked_up_sound_finished() -> void:
	delete()
