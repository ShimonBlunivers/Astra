class_name World extends Node2D

static var instance : World

var _center_of_universe = Vector2.ZERO

static var save_file : SaveFile

static var used_builder : Builder = null

static var difficulty_multiplier : float = 1

@onready var canvas_modulate = $CanvasModulate
@onready var ui_node = $UI

const editor_scene = preload("res://Scenes/Editor.tscn")


func _ready():
	World.instance = self
	DisplayServer.window_set_max_size(Vector2i(3840, 2160))


	save_file = SaveFile.new()
	save_file.initialize_files()

func new_world():
	UIManager.instance.loading_screen()
	ShipManager.randomly_generate_ships()

func shift_origin(by:Vector2):
	transform.origin += by
	_center_of_universe += by

func get_distance_from_center(pos : Vector2) -> Vector2:
	return pos - _center_of_universe

func _process(_delta):
	if !Options.DEBUG_MODE: return
	queue_redraw()

func _draw():
	if !Options.DEBUG_MODE: return
	draw_circle(-_center_of_universe , 25 , Color.LIGHT_BLUE)

func open_editor(_builder : Builder = null):
	used_builder = _builder
	
	visible = false
	ui_node.visible = false
	var root = get_tree().root
	# root.remove_child(self)
	get_tree().paused = true
	var editor_object = editor_scene.instantiate()
	root.add_child(editor_object)

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("game_toggle_menu"):
		open_editor()
