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
		5 : [
            "Ahoj.",
            "Ztratil jsem svoji elektrickou cigaretu.",
			"Víc dní to bez ní nedám.",
			"Byl bys tak ochotnej a přinesl bys mi ji?",
      		5,
			"Díkec!",
		],




		
		# id : [
		#	"text",
		# ],
	},
	
	"mission_finished" : {
		-1 : [ # Výchozí odpověď
			"Děkuji!",
		],
		4 : [ # Index mise, na kterou má odpovídat
			"Ahoj. Ty budeš ten, který nám má pomoct s nalezením disku.
			Brácha mi o tobě říkal. Doufám že se nebojíš, nebude to lehké.",
			4001, # Index navazující mise, která se má spustit
		],
		4001 : [
			"Díky moc!",
			"Ani nevíš, co pro nás tohle znamená.",
			"Jsme ti navždy zavázáni.",
		],
		5 : [
			"Jsi můj zachránce!",
			". . .",
			"Ty tu ještě jseš?",
			"No.. ztratil jsem ještě něco..",
			"Přinesl bys mi ještě žvýkačky, co jsem zapomněl na lodi vedle?",
			5001,
			"Díkec znovu!",
		],
		5001 : [ 
			"Ty jsi je fakt našel!",
			"Dík zas! Jsi můj dvojnásobný zachránce.",
		]

	},
}

static func random_phrase(dialog_type: String) -> String:
	if (!conversations.has(dialog_type)): return ""
	var random := RandomNumberGenerator.new()
	return conversations[dialog_type][random.randi_range(0, conversations[dialog_type].size() - 1)]

static func random_mission_id(roles := [], can_return_empty_quest := false) -> int:
	var random := RandomNumberGenerator.new()
	if can_return_empty_quest && random.randi_range(0, 3) == 0: return -1
	var usable_missions = []
	for key in Quest.missions.keys():
		if Quest.missions[key].role in roles:
			if (Quest.missions[key].times_activated < Quest.missions[key].world_limit || Quest.missions[key].world_limit < 0):
				if !Quest.missions[key].id in NPC.blocked_missions:
					usable_missions.append(Quest.missions[key])

	if usable_missions.size() == 0: return -2

	return usable_missions.pick_random().id
