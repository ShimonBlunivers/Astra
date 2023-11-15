class_name Wall extends ShipPart

@onready var sprite : Sprite2D = $Sprite2D

func _init() -> void:
	super(100)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func set_texture(texture) -> void:
	sprite.texture = texture