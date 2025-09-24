extends Node2D
class_name ModeBase

@onready var collision: CollisionShape2D = $Collision
@onready var player_visual_base: PlayerVisualBase = $PlayerVisualBase

var is_player_action: bool
var is_player_in_floor: bool
var is_player_in_ceiling: bool

func _ready() -> void:
	_connect_events()

func _connect_events() -> void:
	Events.connect("player_is_in_action", _on_player_action)
	Events.connect("player_in_floor", _on_player_in_floor)
	Events.connect("player_in_ceiling", _on_player_in_ceiling)

func get_collision_shape() -> CollisionShape2D:
	return collision

func _on_player_action(action: bool) -> void:
	is_player_action = action

func _on_player_in_floor(on_floor: bool) -> void:
	is_player_in_floor = on_floor

func _on_player_in_ceiling(on_ceiling: bool) -> void:
	is_player_in_ceiling = on_ceiling
