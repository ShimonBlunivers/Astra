class_name PlayerSaveFile extends Resource

@export var position : Vector2
@export var currency : int
@export var suit : bool
@export var health : int

static func save() -> PlayerSaveFile:
    var file = PlayerSaveFile.new()

    file.position = Player.main_player.position
    file.health = Player.main_player.health
    file.currency = Player.main_player.currency
    file.suit = Player.main_player.suit

    return file