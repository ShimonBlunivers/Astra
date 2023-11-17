extends CharacterBody2D


@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var walk_sound : AudioStreamPlayer2D = $Sounds/Walk
const SPEED = 400.0
const RUN_SPEED_MODIFIER = 100.0

var _sprite_dir := 69

var ship_controlled = null

var normal_zoom : float = 1
var ship_zoom : float = 0.1

var use_range : float = 1000

func _physics_process(delta: float) -> void:
	if ship_controlled == null: _move(delta)

func control_ship(ship):
	if ship != null:
		
		walk_sound.stop()
		_sprite_dir = 0
		animated_sprite.flip_h = false
		animated_sprite.play("Idle")
		
		ship.control(self)
		change_view(0)
	else:
		change_view(1)
		if ship_controlled != null: ship_controlled.stop_controlling(self)
	ship_controlled = ship


func _move(_delta: float) -> void:
	
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var running := Input.get_action_strength("ui_run")
	var _sound_pitch_range := [0.9, 1.1]

	velocity = direction * (SPEED + RUN_SPEED_MODIFIER * running)
	
	if velocity.x < 0:
		if !walk_sound.playing: 
			walk_sound.pitch_scale = randf_range(_sound_pitch_range[0], _sound_pitch_range[1])
			walk_sound.play()
		if _sprite_dir != 1:
			_sprite_dir = 1
			animated_sprite.flip_h = true
			animated_sprite.play("WalkToSide")
		
	elif velocity.x > 0:
		if !walk_sound.playing: 
			walk_sound.pitch_scale = randf_range(_sound_pitch_range[0], _sound_pitch_range[1])
			walk_sound.play()
		if _sprite_dir != 2:
			_sprite_dir = 2
			animated_sprite.flip_h = false
			animated_sprite.play("WalkToSide")
		
	elif velocity.y > 0: 
		if !walk_sound.playing: 
			walk_sound.pitch_scale = randf_range(_sound_pitch_range[0], _sound_pitch_range[1])
			walk_sound.play()
		if _sprite_dir != 3:
			_sprite_dir = 3
			animated_sprite.flip_h = false
			animated_sprite.play("WalkDown")
			
	elif velocity.y < 0: 
		if !walk_sound.playing: 
			walk_sound.pitch_scale = randf_range(_sound_pitch_range[0], _sound_pitch_range[1])
			walk_sound.play()
		if _sprite_dir != 4:
			_sprite_dir = 4
			animated_sprite.flip_h = false
			animated_sprite.play("WalkUp")
		
	else:
		if _sprite_dir != 0:
			_sprite_dir = 0
			animated_sprite.flip_h = false
			animated_sprite.play("Idle")

	move_and_slide()

func change_view(view: int) -> void:
	var tween = create_tween()
	match view:
		0: tween.tween_property($Camera2D, "zoom", Vector2(ship_zoom, ship_zoom), 1)
		1: tween.tween_property($Camera2D, "zoom", Vector2(normal_zoom, normal_zoom), 1)
			
