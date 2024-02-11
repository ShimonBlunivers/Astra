class_name Player extends Character

@onready var walk_sound : AudioStreamPlayer2D = $Sounds/Walk
@onready var camera : Camera2D = $Camera2D
@onready var vision : PointLight2D = $Vision/Light

@onready var interact_area = $InteractArea

var _sprite_dir := 69

var ship_controlled = null

var normal_zoom : float = 1
var ship_zoom : float = 0.2

var normal_vision : float = 14
var driving_vision : float = 1

var suit = true;

var use_range : float = 1000

var acceleration = Vector2(0, 0)
var _old_position = Vector2(0, 0)

var hovering_interactables := []
var hovering_controllables := []

var controllables_in_use := []

var _fix_position = Vector2(0, 0);

var passenger_on := []

# TODO: ✅ Make player controling zoom out so it's in the center of ship and is scalable with the ship size

# TODO: ✅ Add floating velocity

# TODO: ✅ Edit player vision so object that are in the dark cannot be seen (Using lights as mask)

# TODO: ✅ Add Damage & Death

# TODO: ✅  Fix wrong hitbox while ship moving

# TODO: Add load/save

# TODO: Fix Michael Jackson walking
	
# TODO: Make walking up & down animations
	
# TODO: Change sounds according to walking terrain

func floating():
	return passenger_on.size() == 0

var changing_ship_to = null;

func get_in(ship): # call_deferred
	if (ship in passenger_on): return
	passenger_on.append(ship)
	reparent(ship.passengers_node)
	_fix_position += ship.difference_in_position;

func get_off(ship): # call_deferred
	passenger_on.erase(ship)
	reparent(get_tree().root.get_node("World"))

	_old_position -= ship.difference_in_position;	

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("debug_die"):
		damage(100)

	if event.is_action_pressed("debug_spawn"):
		spawn()

	if alive:
		if event.is_action_pressed("game_mb_left"):
			for interactable in hovering_interactables:
				interactable.interact()

		if event.is_action_pressed("game_control"):
			for controllable in hovering_controllables:
				controllable.interact()
			for controllable in controllables_in_use:
				if controllable in hovering_controllables: continue;
				controllable.player_in_range = self;
				controllable.interactable = true;
				controllable.interact()
				controllable.player_in_range = null;
				controllable.interactable = false;


func spawn():
	animated_sprite.play("Idle")
	alive = true
	spawned = true;
	health = max_health
	position = spawn_point
	_old_position = global_position
	health_updated_signal.emit()
	

func _ready():
	super();
	spawn_point = Vector2(280, 580)

	nickname = "Player_Samuel"
	await get_tree().process_frame # WAIT FOR THE WORLD TO LOAD AND THE POSITION TO UPDATE // WAIT FOR NEXT FRAME
	spawn()

func kill():
	if !alive: return
	health = 0
	alive = false

	if ship_controlled != null: control_ship(ship_controlled)

	animated_sprite.play("Death")
	health_updated_signal.emit()
	died_signal.emit()


func _in_physics(delta: float) -> void:
	# print("Player position: ", position)
	if ship_controlled == null: 
		_move(delta)


func control_ship(ship):
	if ship != null:
		ship_controlled = ship
		walk_sound.stop()
		_sprite_dir = 0
		animated_sprite.flip_h = false
		animated_sprite.play("Idle")
		
		ship.start_controlling(self)
		change_view(0)
	else:
		change_view(1)
		if ship_controlled != null: ship_controlled.stop_controlling()
		ship_controlled = null


func _move(_delta: float) -> void:

	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var running := Input.get_action_strength("game_run")
	var _sound_pitch_range := [0.9, 1.1]
	
	if !alive: direction = Vector2.ZERO

	acceleration = global_position - _old_position
	var _before_move = _old_position
	_old_position = global_position

	if abs(acceleration.x) > Limits.VELOCITY_MAX or abs(acceleration.y) > Limits.VELOCITY_MAX:
		var new_speed = acceleration.normalized()
		new_speed *= Limits.VELOCITY_MAX
		acceleration = new_speed

	velocity = direction * (SPEED + RUN_SPEED_MODIFIER * running) + _fix_position;
	_fix_position = Vector2.ZERO;

	if floating(): 	
		legs.position = legs_offset - acceleration;
		if suit == false: 
			velocity = Vector2(0, 0)
		else: 
			velocity *= .01
		velocity += acceleration / _delta
	else:
		legs.position = legs_offset - passenger_on[0].difference_in_position;

	move_and_slide()


	# elif _fix_position == position && passenger_on[0].linear_velocity != Vector2.ZERO:
	# 	position += acceleration

	if direction.x < 0:
		if !walk_sound.playing && !floating(): 
			walk_sound.pitch_scale = randf_range(_sound_pitch_range[0], _sound_pitch_range[1])
			walk_sound.play()
		if _sprite_dir != 1:
			_sprite_dir = 1
			animated_sprite.flip_h = true
			animated_sprite.play("WalkToSide")
		
	elif direction.x > 0:
		if !walk_sound.playing && !floating(): 
			walk_sound.pitch_scale = randf_range(_sound_pitch_range[0], _sound_pitch_range[1])
			walk_sound.play()
		if _sprite_dir != 2:
			_sprite_dir = 2
			animated_sprite.flip_h = false
			animated_sprite.play("WalkToSide")
		
	elif direction.y > 0: 
		if !walk_sound.playing && !floating(): 
			walk_sound.pitch_scale = randf_range(_sound_pitch_range[0], _sound_pitch_range[1])
			walk_sound.play()
		if _sprite_dir != 3:
			_sprite_dir = 3
			animated_sprite.flip_h = false
			animated_sprite.play("WalkDown")
			
	elif direction.y < 0: 
		if !walk_sound.playing && !floating(): 
			walk_sound.pitch_scale = randf_range(_sound_pitch_range[0], _sound_pitch_range[1])
			walk_sound.play()
		if _sprite_dir != 4:
			_sprite_dir = 4
			animated_sprite.flip_h = false
			animated_sprite.play("WalkUp")
		
	else:
		if alive && _sprite_dir != 0:
			_sprite_dir = 0
			animated_sprite.flip_h = false
			animated_sprite.play("Idle")
			

var collisionpos = Vector2.ZERO


func _draw() -> void:
	if (!Options.DEBUG_MODE): return;
	var rect;

	rect = interact_area.get_child(0).shape.get_rect();
	rect.position += legs_offset + interact_area.position;
	draw_rect(rect, Color.ORANGE);

	rect = legs.shape.get_rect();

	rect.position += legs_offset;
	draw_rect(rect, Color.RED);

	# print(collisionpos)
	draw_circle(to_local(collisionpos), 25, Color.WHITE)
	

func change_view(view: int) -> void:
	var tween = create_tween()

	var difference_between_ship_center = position
	var ship_offset : Vector2 = (Vector2(ship_controlled.get_rect().position) * Vector2(ship_controlled.get_tile_size())) + (Vector2(ship_controlled.get_rect().size) * ship_controlled.get_tile_size()/2)
	var duration = 1
	
	match view:
		0: 
			tween.parallel().tween_property(camera, "zoom", Vector2(ship_zoom, ship_zoom), duration).set_ease(Tween.EASE_OUT)
			tween.parallel().tween_property(camera, "offset", -difference_between_ship_center + ship_offset, duration).set_ease(Tween.EASE_OUT)
			tween.parallel().tween_property(vision, "texture_scale", driving_vision, duration).set_ease(Tween.EASE_OUT)
		1: 
			tween.parallel().tween_property(camera, "zoom", Vector2(normal_zoom, normal_zoom), duration).set_ease(Tween.EASE_OUT)
			tween.parallel().tween_property(camera, "offset", Vector2.ZERO, duration).set_ease(Tween.EASE_OUT)
			tween.parallel().tween_property(vision, "texture_scale", normal_vision, duration).set_ease(Tween.EASE_OUT)
