class_name Editor extends Node2D


@onready var console : Console = $HUD/Console/ConsoleLog
@onready var ship_editor : ShipEditor = $Ship
@onready var savemenu := $HUD/SavemenuUI

@onready var camera := $Camera2D

@onready var ship_name_label : LineEdit = $HUD/SavemenuUI/ShipName

@onready var ship_list := $HUD/SavemenuUI/Control/ShipList

@onready var inventory : Inventory = $HUD/Inventory

@onready var direction_label = $HUD/DirectionLabel
@onready var limit_rect = $LimitRect


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

func _process(_delta):
	limit_rect.position.x = camera.position.x - limit_rect.size.x / 2

func center_camera():
	camera.position = Vector2(ShipEditor.starting_block_coords.x, 0)
	camera.zoom = Vector2(1, 1)


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

	center_camera()

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
	ship_editor.evide_tiles()
	var ship_text = "[center][table=3]"
	var dir = DirAccess.open("user://saves/ships")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				if !(!Options.DEBUG_MODE && file_name.begins_with('_')): 
					ship_text += "[cell=1][left][url=" + file_name + "]" + file_name + "[/url][/left][/cell]"
					if !file_name.begins_with('_') && FileAccess.file_exists("user://saves/ships/" + file_name + "/details.dat"):
						var details = FileAccess.open("user://saves/ships/" + file_name + "/details.dat", FileAccess.READ)
						var price = details.get_16()
						ship_text += "[cell=1]      ->      [/cell][cell=1][right]" 
						if price > ship_editor.current_ship_price + inventory.currency: ship_text += "[color=red]"
						ship_text += str(price) 
						if price > ship_editor.current_ship_price + inventory.currency: ship_text += "[/color]"
						ship_text += " [img]res://UI/currency.png[/img]" + "[/right][/cell]"
						details.close()
					else:
						ship_text += "[cell=1][/cell][cell=1][/cell]"

					# ship_text += "[/url]"
			file_name = dir.get_next()
	ship_text += "[/table][/center]"
	ship_list.text = ship_text


func _on_load_pressed() -> void:
	var success
	if !ship_name_label.text.begins_with('_') && FileAccess.file_exists("user://saves/ships/" + ship_name_label.text + "/details.dat"):
		var details = FileAccess.open("user://saves/ships/" + ship_name_label.text + "/details.dat", FileAccess.READ)
		var price = details.get_16()
		if price > ship_editor.current_ship_price + inventory.currency: 
			console.print_out("[color=red]Na tuto loď nemáš dostatek prostředků![/color]")
			return
	if (ship_name_label.text == ""): success = ship_editor.load_ship()
	else: success = ship_editor.load_ship(ship_name_label.text)
	if !success: console.print_out("[color=red]Loď s názvem '" + ship_name_label.text + "' nebyla nalezena![/color]")
	else: 
		_on_exit_pressed()
		center_camera()

func _on_open_savemenu_pressed() -> void:
	ShipValidator.autofill_floor(ShipEditor.instance.wall_tile_map)
	savemenu.visible = true
	$HUD/Savemenu.visible = false
	camera.locked = true
	_update_ship_list()

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


func _on_deploy_pressed() -> void:
	if !ShipValidator.check_validity(ship_editor.wall_tile_map): 
		ship_editor.console.print_out("[color=red]Loď nesplňuje podmínky pro uložení![/color]\nZkontrolujte, zda máte v lodi jádro.\nTaké zkontrolujte zda jsou všechny bloky spojeny.")
		return 
	ship_editor.save_ship("_player_ship")
	