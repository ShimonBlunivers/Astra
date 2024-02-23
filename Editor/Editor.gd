extends Node2D


@onready var console : Console = $HUD/ConsoleLog
@onready var ship_editor := $Ship
@onready var savemenu := $Savemenu

@onready var camera := $Camera2D

@onready var ship_name_label : LineEdit = $Savemenu/ShipName

@onready var ship_list := $Savemenu/Control/ShipList

var ships = []

func _ready():
	DirAccess.make_dir_absolute("user://saves/")
	DirAccess.make_dir_absolute("user://saves/ships")

	_update_ship_list()

func _on_save_pressed() -> void:
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
	savemenu.visible = true
	$HUD/Savemenu.visible = false
	camera.locked = true

func _on_exit_pressed() -> void:
	savemenu.visible = false
	$HUD/Savemenu.visible = true
	camera.locked = false


func _on_ship_list_meta_clicked(meta:Variant) -> void:
	ship_name_label.text = meta
