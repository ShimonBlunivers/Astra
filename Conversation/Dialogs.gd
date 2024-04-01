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
	## The mission ID needs to correspond with the index in list
	"mission" : [
		[
		"Ahoj, něco bych potřeboval přinést..",
		"Někde mi vypadnul čip, na kterým jsem měl recept na povidlový čaj..",
		"Přinesl bys mi ho?",
		0,
		"Děkuji! Už se těším až si budu moct opět uvařit svůj čaj.",
		],

		[
		"Ahoj!",
		"Vypadáš jako cestovatel.. něco bych potřeboval..",
		"Ztratil jsem čip, na kterém jsem měl rodinné fotky několika mých generací.",
		"Nezodpovědné, že? .. Každopádně, mohl bys mi ho přinést? Odměna tě nemine!",
		1,
		"Děkuji ti!",
		],

		# [
		# "Nazdárek!",
		# "Potřebuji tvou pomoc. Naše stanice zachytila signál z neznámého zdroje..",
		# "Mohl bys prosím zjistit kdo, nebo co, vysílá tento signál?",
		# "Pokud potkáš někoho poblíž, prověř ho, ať už je to mimozemšťan, průzkumník nebo dokonce ztracená družice.",
		# "Jakmile najdeš zdroj signálu, vrať se. Samozřejmě ti nezapomenu dát nějakou tu odměnu!",
		# 2,
		# "Budu očekávat tvůj návrat!",
		# ], 
		
		# [

		# ],

		# [

		# ],
		
		# [

		# ],
	],
	# "mission_finished" : [
	# 	"Děkuji!",
	# ]
	"mission_finished" : {
		-1 : [
			"Děkuji!",
			],
	},
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
