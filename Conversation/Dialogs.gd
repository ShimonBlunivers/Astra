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

	"mission" : { # Kategorie misí
		0 : [ # Index mise a její obsah
			"Ahoj, něco bych potřeboval přinést..",
			"Někde mi vypadnul čip, na kterým jsem měl recept na povidlový čaj..",
			"Přinesl bys mi ho?",
			0, # Index mise, která se má spustit
			"Děkuji! Už se těším až si budu moct opět uvařit svůj čaj.",
		],
		1 : [
			"Ahoj!",
			"Vypadáš jako cestovatel.. něco bych potřeboval..",
			"Ztratil jsem čip, na kterém jsem měl rodinné fotky několika mých generací.",
			"Nezodpovědné, že? .. Každopádně, mohl bys mi ho přinést? Odměna tě nemine!",
			1,
			"Děkuji ti!",
		],
		2 : [
			"Nazdárek!",
			"Potřebuji tvou pomoc. Naše stanice zachytila signál z neznámého zdroje..",
			"Mohl bys prosím zjistit kdo, nebo co, vysílá tento signál?",
			"Pokud potkáš někoho poblíž, prověř ho, ať už je to mimozemšťan, průzkumník nebo dokonce ztracená družice.",
			"Jakmile najdeš zdroj signálu, vrať se. Samozřejmě ti nezapomenu dát nějakou tu odměnu!",
			2,
			"Budu očekávat tvůj návrat!",
		], 
		3 : [
			"Zdar, potřebuju s něčím pomoct..",
			"Vidím, že máš odvahu pomoci cizí posádce v nouzi.",
			"Situace není moc dobrá. Motory jsou mimo provoz a životně důležité systémy jsou vážně rozbity.",
			"Potřebuju KL94 velikosti 10, náhradní díly by mohly být v naší sesterské lodi, ale musím tě varovat, desítka se často ztrácí.",
			"Budeš potřebovat opatrné ruce. Až to budeš mít tak se vrať!",
			3,
		],

		4 : [
            "Zdar.",
            "Jsem ve velkým průšvihu, ukradli mi kódovanej disk s ultra-utajenejma datama.",
			"Ten disk patří bohatýmu důstojníkovi, kterej mě pověřil, abych ho našel.",
			"Pomohl bys mi?",
        	"Najdi mýho bráchu. On ti řekne, jak pokračovat, ale nikdo se o tom nesmí dozvědět.",
			"Jestli se o tom dozví špatní lidi, je s náma konec.",
			"A ohledně odměny? Máme dost energetickejch jednotek, abychom tě pořádně odměnili.",
			"Co ty na to?",
      		4,
			"Díky moc!",
		],
		
		# id : [
		#	"text",
		# ],
	},
	
	"mission_finished" : {
		-1 : [
			"Děkuji!",
		],
		4 : [
			"Ahoj. Ty budeš ten který nám má pomoct s nalezení disku. Brácha mi o tobě říkal. Doufám že se nebojíš, nebude to lehké.",
			4001,
		],

		4001 : [
			"Díky moc!",
			"Ani nevíš, co pro nás tohle znamená.",
			"Jsme ti navždy zavázáni.",
		]
	},
}

static func random_phrase(dialog_type: String) -> String:
	if (!conversations.has(dialog_type)): return ""
	var random := RandomNumberGenerator.new()
	return conversations[dialog_type][random.randi_range(0, conversations[dialog_type].size() - 1)]

static func random_mission_id(roles := [], can_return_empty_quest := false) -> int:
	var random := RandomNumberGenerator.new()
	if can_return_empty_quest && random.randi_range(0, 4) == 0: return -1
	var usable_missions = []
	for key in Quest.missions.keys():
		if Quest.missions[key].role in roles:
			if (Quest.missions[key].times_activated < Quest.missions[key].world_limit || Quest.missions[key].world_limit < 0):
				usable_missions.append(Quest.missions[key])

	if usable_missions.size() == NPC.blocked_missions.size(): return -2
	while 1:
		var id = usable_missions.pick_random().id
		if !id in NPC.blocked_missions:
			return id
	return -3
