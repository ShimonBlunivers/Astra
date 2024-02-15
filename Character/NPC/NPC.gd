class_name NPC extends Character

var difference = Vector2.ZERO

@onready var dialog_manager = $DialogManager

static var number_of_npcs = 0;

# TODO: Add dialog

# TODO: Add missions

var dialogs = Dialogs.new()

func init():
	nickname = "NPC_Kevin_" + str(number_of_npcs);
	number_of_npcs += 1;
	print(nickname, " SPAWNED on: " , position)


func _ready() -> void:
	legs_offset = legs.position;




func _on_interaction_area_area_entered(area:Area2D) -> void:
	if area.is_in_group("PlayerInteractArea"):
		dialog_manager.start_dialog(Vector2(0, -100), dialogs.conversations["greeting"])
