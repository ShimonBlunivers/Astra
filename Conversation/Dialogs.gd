class_name Dialogs

static var conversations = {
	"greeting": [
		"Ahoj!",
		"Zdravíčko!",
		"Zdar!",
		"Ahoy!",
		"Nazdar!",
		"Zdravím!",
		"Čauves.",
		"Ahojda.",
		"Ahojky!",
		"Pěkný den přeji.",
		"Jak se máš?",
		"Jak to jde?",
		"Vítej zpátky!",
		"Nazdar, kosmonaute!",
		"Saluton, spaciano!",
		"Přeji příjemný pobyt!",
		"Co potřebuješ?",
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
			"Díkec.",
		],
		6 : [
			"Ahoj zachránče! To jsem já!",
			"Nikdy ti nezapomenu, co jsi pro mě udělal..",
			"Zase jsem něco ztratil..",
			"Tentokrát jsem ztratil balíček bonbónů, zachránil bys mě zase?",
			6,
			"Díkec!",
		],
		7 : [
			"Ahoj, potřebuji tvou pomoc!",
			"Naše navigační systémy byly narušeny magnetickou bouří a nemůžeme určit naši polohu.",
			"Mohl bys najít náhradní kompas nebo zařízení schopné nám pomoct zorientovat se?",
			"Je to naléhavé. Bez něj jsme ve vesmíru jako slepí.",
			7,
			"Vrať se s ním co nejdříve, čeká tě tu odměna!",
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
		],
		6 : [
			"Super!",
			"Věděl jsem, že se na tebe mohu spolehnout!",
		]
	},
}

## [param dialog_type]: key from [member conversations]. [br]
## [return]: random phrase from the given dialog type. [br]
static func random_phrase(dialog_type: String) -> String:
	if (!conversations.has(dialog_type)): return ""
	var random := RandomNumberGenerator.new()
	return conversations[dialog_type][random.randi_range(0, conversations[dialog_type].size() - 1)]


## [param roles]: array of [member NPC.Roles] that the task should have. [br]
## [param can_return_empty_task]: whether the function has chance to return -1. [br]
## [return]: random task ID that is not blocked in [member QuestManager.active_quests]. [br]
## Returns -2 if no task is available. [br]
static func random_task_id(roles := [], can_return_empty_task := false) -> int:
	var random := RandomNumberGenerator.new()
	if can_return_empty_task && random.randi_range(0, 3) == 0: return -1
	
	var usable_tasks = []
	for task_key in QuestManager.tasks.keys():
		var task = QuestManager.tasks[task_key]
		if !task.is_followup_task && (task.required_role in roles || task.required_role == NPC.Roles.NONE):
			if (task.times_activated < task.world_limit || task.world_limit < 0):
				if !(task.id in QuestManager.active_quests):
					usable_tasks.append(task)
	
	if usable_tasks.size() == 0: 
		if (!can_return_empty_task): print_debug("Warning: No tasks available for roles: " + str(roles))
		return -2

	return usable_tasks.pick_random().id