class_name Thruster extends ShipPart


@onready var sprite : Sprite2D = $Sprite2D
@onready var jet_particles : GPUParticles2D = $JetParticles
@onready var left_sidejet_particles : GPUParticles2D = $LeftSideJetParticles
@onready var right_sidejet_particles : GPUParticles2D = $RightSideJetParticles

@onready var jet_sound : AudioStreamPlayer2D = $Sounds/Jet

var layer : int = 0

var power : float

var direction : int

var running : bool = false

var blocked_sides = [false, false] # LEFT RIGHT


func init(_ship, _coords : Vector2i, _durability : float = 150, _mass : float = 5, _direction = 0, _power = 1000):
	super(_ship, _coords, _durability, _mass)
	direction = _direction
	power = _power
	ship.thrusters[direction].append(self)

	call_deferred("get_blocked_sides")

func set_status(status : bool):
	running = status
	jet_particles.emitting = running
	jet_sound.playing = status

func side_thrusters(dir : float):
	if !blocked_sides[0]: left_sidejet_particles.emitting = dir < 0
	if !blocked_sides[1]: right_sidejet_particles.emitting = dir > 0

func get_blocked_sides():
	var _blocked_sides = [false, false, false, false] # LEFT UP RIGHT DOWN

	_blocked_sides[1] = ship.get_tile(tilemap_coords + Vector2i(-1, 0)) != null
	_blocked_sides[2] = ship.get_tile(tilemap_coords + Vector2i(0, -1)) != null
	_blocked_sides[3] = ship.get_tile(tilemap_coords + Vector2i(1, 0)) != null
	_blocked_sides[0] = ship.get_tile(tilemap_coords + Vector2i(0, 1)) != null

	if direction == 0:
		blocked_sides = [_blocked_sides[0], _blocked_sides[2]]
	elif direction == 1:
		blocked_sides = [_blocked_sides[1], _blocked_sides[3]]
	elif direction == 2:
		blocked_sides = [_blocked_sides[2], _blocked_sides[0]]
	elif direction == 3:
		blocked_sides = [_blocked_sides[3], _blocked_sides[1]]
		
