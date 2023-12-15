class_name Character extends CharacterBody2D


@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

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


func move(by: Vector2):
	position += by;

func spawn():
	alive = true
	health = max_health
	position = spawn_point
	health_updated_signal.emit()