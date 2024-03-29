class_name Builder extends InteractableShipPart

@onready var connector_finder_hitbox = $ConnectorFinder/CollisionShape2D

var controlled : bool = false

var connector : Connector

func init(_ship, _coords : Vector2i, _durability : float = 10, _mass : float = 1):
	_coords = Vector2i(_coords.x / 4, _coords.y / 4)                                   # MAYBE DOESNT WORK!!
	super(_ship, _coords, _durability, _mass)

func _interact():
	if connector.connected_to == null:
		World.instance.open_editor(self)

func _process(_delta):
	if connector == null: connector_finder_hitbox.shape.radius += 5

func get_spawn_position() -> Vector2:
	return connector.global_position + Vector2(80, 240).rotated(deg_to_rad(connector.global_rotation_degrees - 90)) + ship.difference_in_position

func get_ship_rotation() -> float:
	return deg_to_rad(connector.global_rotation_degrees + 90)

func _on_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("PlayerArea"):
		player_in_range = area.get_owner()
		player_in_range.hovering_controllables.append(self)

func _on_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("PlayerArea"):
		player_in_range.hovering_controllables.erase(self)
		player_in_range = null


func _on_connector_finder_body_entered(body:Node2D) -> void:
	if connector == null:
		body = body.get_parent()
		if body.ship == ship && body is Connector:
			connector = body
			connector_finder_hitbox.set_deferred("disabled", true)
