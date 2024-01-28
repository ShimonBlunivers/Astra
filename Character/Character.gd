class_name Character extends CharacterBody2D


@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

@onready var speed = Vector2.ZERO;

@onready var legs = $LegHitbox

const SPEED = 400.0
const RUN_SPEED_MODIFIER = 100.0

var passenger_on := []

var max_health : float = 100
var health : = max_health
signal health_updated_signal
signal died_signal
var alive : bool = false


var spawn_point : Vector2 = Vector2(0, 0)

var nickname = ""

var max_impact_velocity : float = 25


func _physics_process(delta: float) -> void:
	_in_physics(delta)
	if !floating():
		move_and_collide(passenger_on[0].difference_in_position);
	
func _in_physics(_delta: float) -> void:
	pass

func floating():
	return passenger_on.size() == 0

func damage(amount : float):
	health = max(health - amount, 0)
	if health == 0: kill()
	else: health_updated_signal.emit()

func get_in(ship):
	passenger_on.append(ship)

func get_off(ship):
	passenger_on.erase(ship)

func kill():
	if !alive: return
	health = 0
	alive = false

	health_updated_signal.emit()
	died_signal.emit()

func spawn():
	alive = true
	health = max_health
	position = spawn_point
	health_updated_signal.emit()

# func update_position():
# 	speed = Vector2.ZERO;

func _draw() -> void:
	var rect = legs.shape.get_rect()

	rect.position += Vector2(legs.position.x, legs.position.y)

	draw_rect(rect, Color.RED)
