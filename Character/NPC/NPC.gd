class_name NPC extends Character

var difference = Vector2.ZERO

@onready var dialog_box = $DialogBox

static var number_of_npcs = 0;

# TODO: Add dialog

# TODO: Add missions

var conversation = {
	"greeting": [
		"Ahoj!",
		"Zdravíčko!",
		"Jak se máš?",
		"Ahojky!",
		"Vítej zpátky!",
		"Nazdar, kosmonaute!",
		"Ahoj od stanice!",
		"Ahoj, vesmírný poutníku!",
		"Jak se daří v gravitaci nula?",
		"Dobrý den ve vesmíru!",
		"Ahojte, cestovatelé hvězdami!",
		"Vesmírný den ti přeji!",
		"Saluton, spaciano!",
		"Vítej zpátky, dobrodruhu!",
		"Jak to vypadá na cestě?",
		"Jaká byla cesta?",
		"Jak se daří ve vesmíru?",
		"Jaké novinky?",
		"Jak probíhá kosmická expedice?",
		"Jaké máš plány dnes?",
		"Co nového ve vesmírném dobrodružství?",
		"Jaká je nálada v kosmické stanici?",
		"Přeji příjemný pobyt!",
		"Jak se daří tvému kosmickému plavidlu?",
		"Co nového ve vesmírném světě?",
		"Jak to jde v tvém koutě galaxie?",
		"Jaký je tvůj vesmírný plán?"
	],
	
	"quest_ask" : [
		
	],
}

func init():
	nickname = "NPC_Kevin_" + str(number_of_npcs);
	number_of_npcs += 1;
	print(nickname, " SPAWNED on: " , position)

func random_phrase(conversation_type: String) -> String:
	if (!conversation.has(conversation_type)): return ""
	var random := RandomNumberGenerator.new();
	return conversation[conversation_type][random.randi_range(0, conversation[conversation_type].size() - 1)]
	

func _ready() -> void:
	legs_offset = legs.position;

	var random := RandomNumberGenerator.new();

	dialog_box.display_text(random_phrase("greeting"))

	animated_sprite.stop()
	$Timer.set_wait_time(random.randf_range(0, 2))
	$Timer.start()
	await $Timer.timeout
	animated_sprite.play("Idle")