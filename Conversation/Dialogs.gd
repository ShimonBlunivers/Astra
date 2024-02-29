class_name Dialogs

var conversations = {
	"greeting": [
		"Ahoj!",
		"Zdravíčko!",
		"Jak se máš?",
		"Ahojky!",
		"Vítej zpátky!",
		"Nazdar, kosmonaute!",
		"Saluton, spaciano!",
		"Přeji příjemný pobyt!",
		"Co potřebuješ?",
		"Jak to jde?",
		"Můžu ti nějak pomoct?",
		"Viděl jsi něco podezřelého?",
		"Viděl jsi něco neobvyklýho?",
		"Co si myslíš o vesmírné politice?",
		"Co je podle tebe nejlepší část vesmíru?",
		"Tvoje máma.",
		"Smrdis.",
	],
	
	"mission" : [
		[
		"Ahoj, něco bych potřeboval přinést..",
		"Někde mi vypadnul čip, na kterým jsem měl celkem velkou kolekci dětského po..",
		"..povidlového čaje.. respektive receptu na něj.",
		"Přinesl bys mi ho?",
		["Dětský čaj", "Přines mi prosím recept na čaj. pls", 0],
		"Děkuji! Už se těším až si budu moct opět uvařit svůj čaj."
		]
	],

	"mission_finished" : [
		"Děkuji ti!",
	],
}

func random_phrase(dialog_type: String) -> String:
	if (!conversations.has(dialog_type)): return ""
	var random := RandomNumberGenerator.new()
	return conversations[dialog_type][random.randi_range(0, conversations[dialog_type].size() - 1)]
