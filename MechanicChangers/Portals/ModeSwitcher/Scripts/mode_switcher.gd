extends Area2D
class_name ModeSwitcher

## Changes the player's current mode
##
## The player's mode will change based on the value defined in
## [member transform_to], which is of type [enum Enums.PLAYER_MODE].

@export var transform_to: Enums.PLAYER_MODE ## Determines the mode the player will switch to

## Applies a vertical offset correction to the player, since some modes
## have different sizes compared to others
const _PLAYER_VERTICAL_CORRECTION: float = 16.0

## First, checks if [param body] is a [Player]; if true,
## applies the vertical correction using [method _apply_vertical_correction]
func _on_body_entered(body: Node2D) -> void:
	if not body is Player: return
	_apply_vertical_correction(body)
	body.change_mode(transform_to)

## Applies vertical correction to the [Player] based on 
## [member _PLAYER_VERTICAL_CORRECTION]
func _apply_vertical_correction(player: Player) -> void:
	player.global_position.y = global_position.y - _PLAYER_VERTICAL_CORRECTION
