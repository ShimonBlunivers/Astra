class_name Dialogs

static var conversations = {
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
	],

	"mission" : [
		[
		"Ahoj, něco bych potřeboval přinést..",
		# "Někde mi vypadnul čip, na kterým jsem měl recept na povidlový čaj..",
		# "Přinesl bys mi ho?",
		0,
		"Děkuji! Už se těším až si budu moct opět uvařit svůj čaj.",
		],
	],

	"mission_finished" : [
		"dyck"
	],
}

static func random_phrase(dialog_type: String) -> String:
	if (!conversations.has(dialog_type)): return ""
	var random := RandomNumberGenerator.new()
	return conversations[dialog_type][random.randi_range(0, conversations[dialog_type].size() - 1)]

static func random_mission_id(blocked_missions := []) -> int:
	if conversations["mission"].size() == blocked_missions.size(): return -1
	while 1:
		var random := RandomNumberGenerator.new()
		var id = random.randi_range(0, conversations["mission"].size() - 1)
		if !id in blocked_missions:
			return id
	return -2
