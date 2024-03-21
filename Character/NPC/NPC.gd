class_name NPC extends Character

var difference = Vector2.ZERO

@onready var dialog_manager = $DialogManager
@onready var sprites = $Sprite

var ship

static var names = [
	"Kevin",
	"Lukáš",
	"Tomáš",
	"Jan",
	"Pavel",
	"Martin",
	"Jakub",
	"Michal",
	"Jiří",
	"Adam",
	"David",
	"Marek",
	"Petr",
	"Ondřej",
	"Filip",
	"Richard",
	"Robert",
	"Václav",
	"Matěj",
	"Aleš",
	"Daniel",
	"Josef",
	"Karel",
	"Vojtěch",
	"František",
	"Eduard",
	"Viktor",
	"Igor",
	"Radim",
	"Radek",
	"Lukas",
	"Dominik",
	"Jakob",
	"Rudolf",
	"Lukáš",
	"Emanuel",
	"Štěpán",
	"Jaroslav",
	"Michael",
	"Zdeněk",
	"Aleš",
	"Patrik",
	"Tom",
	"Albert",
	"Viktor",
	"Jiří",
	"Denis",
	"Pavel",
	"Igor",
	"Eduard",
	"Jan",
	"Luboš",
	"Šimon",
	"Teo",
	"Honza",
	"Vašek",
]

static var npcs = []

var interactable = false

var blocked_missions = []

var active_quest = -1 # RANDOMLY GENERATE QUEST

var id : int

# TODO: ✅ Add dialog

# TODO: ✅ Add missions

var dialogs = Dialogs.new()

static func get_uid() -> int:
	var _id = 0
	while true:
		if NPC.get_npc(_id) == null:
			return _id
		_id += 1
	return 0

static func get_npc(_id: int) -> NPC:
	for npc in npcs: if npc.id == _id: return npc
	return null

func init(_id : int = -1, _nickname : String = names.pick_random()):
	load("res://Items/Chip/Chip.tres")
	nickname = _nickname
	$Nametag.text = nickname
	name = "NPC_" + nickname + "_" + str(npcs.size())

	if _id != -1 && NPC.get_npc(_id) == null:
		id = _id
	else:
		_id = 0
		while true:
			if NPC.get_npc(_id) == null:
				id = _id
				break
			_id += 1

	npcs.append(self)
	# print(nickname, " SPAWNED on: " , position)


func _ready() -> void:
	legs_offset = legs.position

func _in_physics(_delta):
	$Area.position = Vector2(0, -42.5) + (-ship.difference_in_position).rotated(-global_rotation)


func _on_interaction_area_area_entered(area:Area2D) -> void:
	if area.is_in_group("PlayerInteractArea"):
		interactable = true
		var dialog_position = Vector2(0, -105)
		if self in QuestManager.active_quest_objects[Goal.Type.talk_to_npc]:
			dialog_manager.start_dialog(dialog_position, dialogs.conversations["mission_finished"])
			QuestManager.finished_quest_objective(QuestManager.get_quest(self))

		elif self == NPC.get_npc(1):
			active_quest = 0;
			if !active_quest in blocked_missions:
				dialog_manager.start_dialog(dialog_position, dialogs.conversations["mission"][active_quest])
		else:
			dialogs.conversations["greeting"].shuffle()
			dialog_manager.start_dialog(dialog_position, dialogs.conversations["greeting"])
		QuestManager.update_quest_log()

func _on_interaction_area_area_exited(area:Area2D):
	if area.is_in_group("PlayerInteractArea"):
		interactable = false
		dialog_manager.end_dialog()

func _on_area_mouse_entered() -> void:
	$Nametag.visible = true

func _on_area_mouse_exited() -> void:
	$Nametag.visible = false

func _on_area_input_event(_viewport:Node, event:InputEvent, _shape_idx:int) -> void:
	if event is InputEventMouseButton && event.button_mask == 1:
		dialog_manager.advance()

func delete():
	npcs.erase(self)
	queue_free()
