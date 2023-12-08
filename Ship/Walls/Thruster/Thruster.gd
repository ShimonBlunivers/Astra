class_name Thruster extends ShipPart


@onready var sprite : Sprite2D = $Sprite2D
@onready var particles : GPUParticles2D = $Jet/JetParticles
@onready var jet : Node2D = $Jet
@onready var jet_sound : AudioStreamPlayer2D = $Sounds/Jet

var layer : int = 0;

var power : float;

var direction : int;

var running : bool = false;

func set_texture(texture) -> void:
	sprite.texture = texture


func init(_ship, _direction = 0, _power = 10000, _durability : float = 150, _mass : float = 5):
	super(_ship, _durability, _mass);
	direction = _direction;
	power = _power;
	ship.thrusters[direction].append(self)
	


func set_status(status : bool):
	running = status;
	particles.emitting = running

	jet_sound.playing = status
