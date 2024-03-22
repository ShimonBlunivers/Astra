class_name Editor extends Node2D


@onready var console : Console = $HUD/ConsoleLog
@onready var ship_editor := $Ship
@onready var savemenu := $Savemenu

@onready var camera := $Camera2D

@onready var ship_name_label : LineEdit = $Savemenu/ShipName

@onready var ship_list := $Savemenu/Control/ShipList

@onready var inventory = $HUD/Inventory

@onready var direction_label = $HUD/DirectionLabel


var ships = []

static var instance

var inventory_open = false
var inventory_positions = Vector2(160, -165) # open, closed
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("editor_toggle_toolmenu"):
		inventory_open = !inventory_open
		var tween = create_tween()
		var duration = 0.5
		if inventory_open: tween.tween_property(inventory, "position", Vector2(inventory_positions.x, 0), duration).set_ease(Tween.EASE_OUT)
		else: tween.tween_property(inventory, "position", Vector2(inventory_positions.y, 0), duration).set_ease(Tween.EASE_IN)
	
	if event.is_action_pressed("debug_die"):
		_exit()


func _exit():
	self.queue_free()
	Player.main_player.camera.make_current()
	get_tree().paused = false
	
	World.instance.visible = true
	World.instance.ui_node.visible = true


func _ready():
	Editor.instance = self
	DirAccess.make_dir_absolute("user://saves/")
	DirAccess.make_dir_absolute("user://saves/ships")

	_update_ship_list()

	ship_editor.inventory = inventory
	inventory.load_grid()

	camera.make_current()

func _on_save_pressed() -> void:
	if !ShipValidator.check_validity(ship_editor.wall_tile_map): 
		ship_editor.console.print_out("[color=red]Loď nesplňuje podmínky pro uložení![/color]\nZkontrolujte, zda máte v lodi jádro.\nTaké zkontrolujte zda jsou všechny bloky spojeny.")
		return 
	if (ship_name_label.text == ""): 
		ship_editor.save_ship()
		_update_ship_list()
		return
	ship_editor.save_ship(ship_name_label.text)
	_update_ship_list()

		
func _update_ship_list():
	ships = []

	var dir = DirAccess.open("user://saves/ships")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				ships.append(file_name)
			file_name = dir.get_next()

	ship_list.text = ""
	for ship in ships: ship_list.text += "[url]" + ship + "[/url]\n"


func _on_load_pressed() -> void:
	var success
	if (ship_name_label.text == ""): success = ship_editor.load_ship()
	else: success = ship_editor.load_ship(ship_name_label.text)
	if !success: console.print_out("Loď s názvem '" + ship_name_label.text + "' nebyla nalezena!")

func _on_open_savemenu_pressed() -> void:
	ShipValidator.autofill_floor(ShipEditor.instance.wall_tile_map)
	savemenu.visible = true
	$HUD/Savemenu.visible = false
	camera.locked = true

func _on_exit_pressed() -> void:
	savemenu.visible = false
	$HUD/Savemenu.visible = true
	camera.locked = false


func _on_ship_list_meta_clicked(meta:Variant) -> void:
	ship_name_label.text = meta


func _on_autofloor_pressed():
	ShipValidator.autofill_floor(ShipEditor.instance.wall_tile_map)


func _on_autofloor_button_toggled(toggled_on:bool):
	ShipEditor.autoflooring = toggled_on
	if toggled_on: ShipValidator.autofill_floor(ShipEditor.instance.wall_tile_map)
