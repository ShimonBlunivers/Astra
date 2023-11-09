extends CharacterBody2D


@onready var _animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 400.0
const RUN_SPEED_MODIFIER = 100.0

var _sprite_dir := 69

var ship_controlled = null

var normal_zoom = 1
var ship_zoom = 0.1

func _physics_process(delta: float) -> void:
	_move(delta)

func _move(delta: float) -> void:
	
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var running := Input.get_action_strength("ui_run")

	if ship_controlled != null:
		ship_controlled.move(delta, direction)
		return

	velocity.x = direction.x * (SPEED + RUN_SPEED_MODIFIER * running)
	velocity.y = direction.y * (SPEED + RUN_SPEED_MODIFIER * running)
	
	if velocity.x < 0:
		if _sprite_dir != 1:
			_sprite_dir = 1
			_animated_sprite.flip_h = true
			_animated_sprite.play("WalkToSide")
		
	elif velocity.x > 0:
		if _sprite_dir != 2:
			_sprite_dir = 2
			_animated_sprite.flip_h = false
			_animated_sprite.play("WalkToSide")
		
	elif velocity.y > 0: 
		if _sprite_dir != 3:
			_sprite_dir = 3
			_animated_sprite.flip_h = false
			_animated_sprite.play("WalkDown")
		
	elif velocity.y < 0: 
		if _sprite_dir != 4:
			_sprite_dir = 4
			_animated_sprite.flip_h = false
			_animated_sprite.play("WalkUp")
		
	else:
		if _sprite_dir != 0:
			_sprite_dir = 0
			_animated_sprite.flip_h = false
			_animated_sprite.play("Idle")

	move_and_slide()

func change_view(view: int) -> void:
	var tween = create_tween()
	match view:
		0:
			tween.tween_property($Camera2D, "zoom", Vector2(normal_zoom, normal_zoom), 1)
			tween.tween_property($Camera2D, "zoom", Vector2(ship_zoom, ship_zoom), 1)
			print(0)
		1:
			tween.tween_property($Camera2D, "zoom", Vector2(ship_zoom, ship_zoom), 1)
			tween.tween_property($Camera2D, "zoom", Vector2(normal_zoom, normal_zoom), 1)
			print(1)
			
