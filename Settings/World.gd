class_name World extends Node2D

static var instance : World

var _center_of_universe = Vector2.ZERO

func _ready():
    World.instance = self
    DisplayServer.window_set_max_size(Vector2i(3840, 2160))

func shift_origin(by:Vector2):
    transform.origin += by
    _center_of_universe += by

func get_distance_from_center(pos : Vector2) -> Vector2:
    return pos - _center_of_universe


func _process(_delta):
    queue_redraw()

func _draw():
    draw_circle(-_center_of_universe , 25 , Color.LIGHT_BLUE)