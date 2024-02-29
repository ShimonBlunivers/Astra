class_name NPC extends Character

var difference = Vector2.ZERO

@onready var dialog_manager = $DialogManager

var ship

static var number_of_npcs = 0

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

var finished_missions = []

var active_quest = 0 # RANDOMLY GENERATE QUEST

# TODO: Add dialog

# TODO: Add missions

var dialogs = Dialogs.new()

static func get_npc(id: int) -> NPC:
	if id >= npcs.size(): return null
	return npcs[id]

func init():
	nickname = names.pick_random()
	$Nametag.text = nickname
	name = "NPC_" + nickname + "_" + str(number_of_npcs)
	number_of_npcs += 1
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

		elif self == NPC.get_npc(0):
			active_quest = 0;
			if !active_quest in finished_missions:
				dialog_manager.start_dialog(dialog_position, dialogs.conversations["mission"][0])
		else:
			dialogs.conversations["greeting"].shuffle()
			dialog_manager.start_dialog(dialog_position, dialogs.conversations["greeting"])
		QuestManager.update_quest_log()


func _on_area_mouse_entered() -> void:
	$Nametag.visible = true

func _on_area_mouse_exited() -> void:
	$Nametag.visible = false

func _on_interaction_area_area_exited(area:Area2D):
	if area.is_in_group("PlayerInteractArea"):
		interactable = false

func _on_area_input_event(_viewport:Node, event:InputEvent, _shape_idx:int) -> void:
	if event is InputEventMouseButton && event.button_mask == 1:
		dialog_manager.advance()
