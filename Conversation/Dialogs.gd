class_name Dialogs


var conversations = {
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
	
	"mission" : []
};

func random_phrase(dialog_type: String) -> String:
	if (!conversations.has(dialog_type)): return ""
	var random := RandomNumberGenerator.new();
	return conversations[dialog_type][random.randi_range(0, conversations[dialog_type].size() - 1)]
