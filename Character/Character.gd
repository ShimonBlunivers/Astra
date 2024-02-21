class_name Character extends CharacterBody2D


@onready var speed = Vector2.ZERO;

@onready var legs = $LegHitbox

const SPEED = 400.0
const RUN_SPEED_MODIFIER = 100.0
const TURN_SPEED = 1.0

var legs_offset = Vector2.ZERO;

var max_health : float = 100
var health : = max_health
signal health_updated_signal
signal died_signal
var alive : bool = false;
var spawned : bool = false;

var spawn_point : Vector2 = Vector2.ZERO;

var nickname = ""

var max_impact_velocity : float = 25

signal _animation_time_offset

func _ready() -> void:
	legs_offset = legs.position;


func _process(_delta: float) -> void:
	queue_redraw()

func _physics_process(delta: float) -> void:
	_in_physics(delta)
	
func _in_physics(_delta: float) -> void:
	pass


func damage(amount : float):
	health = max(health - amount, 0)
	if health == 0: kill()
	else: health_updated_signal.emit()


func kill():
	if !alive: return
	health = 0
	alive = false

	health_updated_signal.emit()
	died_signal.emit()
	
	
func spawn():
	alive = true
	spawned = true;
	health = max_health
	position = spawn_point
	health_updated_signal.emit()

func _draw() -> void:
	if (!Options.DEBUG_MODE): return;
	
	var rect = legs.shape.get_rect()

	rect.position += Vector2(legs.position.x, legs.position.y)

	draw_rect(rect, Color.RED)
