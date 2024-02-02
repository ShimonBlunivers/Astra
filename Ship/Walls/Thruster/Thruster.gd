class_name Thruster extends ShipPart


@onready var sprite : Sprite2D = $Sprite2D
@onready var particles : GPUParticles2D = $JetParticles
@onready var jet_sound : AudioStreamPlayer2D = $Sounds/Jet

var layer : int = 0;

var power : float;

var direction : int;

var running : bool = false;


func init(_ship, _coords : Vector2i, _durability : float = 150, _mass : float = 5, _direction = 0, _power = 1000):
	super(_ship, _coords, _durability, _mass);
	direction = _direction;
	power = _power;
	ship.thrusters[direction].append(self);
	


func set_status(status : bool):
	running = status;
	particles.emitting = running

	jet_sound.playing = status
