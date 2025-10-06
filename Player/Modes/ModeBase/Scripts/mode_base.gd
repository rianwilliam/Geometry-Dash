extends Node2D
class_name ModeBase

## Base class for all player modes
##
## Holds the mode collision and certain player states, 
## which are used to play animations.

@onready var collision: CollisionShape2D = $Collision
@onready var player_visual_base: PlayerVisualBase = $PlayerVisualBase

var is_player_action: bool
var is_player_in_floor: bool
var is_player_in_ceiling: bool
var mode_type: Enums.PLAYER_MODE

func _ready() -> void:
	_connect_events()

func set_custom_color(colors: PlayerColorData) -> void:
	player_visual_base.set_body_color(colors.get_body_color())
	player_visual_base.set_details_color(colors.get_details_color())
	player_visual_base.set_particles_color(colors.get_body_color())

## Connects the events emitted by the player to obtain required information
func _connect_events() -> void:
	Events.connect("player_is_in_action", _on_player_action)
	Events.connect("player_in_floor", _on_player_in_floor)
	Events.connect("player_in_ceiling", _on_player_in_ceiling)

## Returns the mode collision
func get_collision_shape() -> CollisionShape2D:
	return collision

func _on_player_action(action: bool) -> void:
	is_player_action = action

func _on_player_in_floor(on_floor: bool) -> void:
	is_player_in_floor = on_floor

func _on_player_in_ceiling(on_ceiling: bool) -> void:
	is_player_in_ceiling = on_ceiling

func change_body_color(color: Color) -> void:
	player_visual_base.set_body_color(color)
	
func change_details_color(color: Color) -> void:
	player_visual_base.set_details_color(color)
