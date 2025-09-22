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
	Events.connect("player_gravity_dir", _on_player_send_gravity)
	Events.connect("player_died", _on_player_die)

func get_collision_shape() -> CollisionShape2D:
	return collision

func _on_player_action(action: bool) -> void:
	is_player_action = action

func _on_player_in_floor(on_floor: bool) -> void:
	is_player_in_floor = on_floor

func _on_player_in_ceiling(on_ceiling: bool) -> void:
	is_player_in_ceiling = on_ceiling

func _on_player_send_gravity(direction: Enums.GRAVITY_DIR) -> void:
	if direction == Enums.GRAVITY_DIR.INVERTED: scale.y = -1
	else: scale.y = 1

func _on_player_die() -> void:
	scale.y = 1
