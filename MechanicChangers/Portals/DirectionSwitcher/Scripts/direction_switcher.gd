extends PortalBase
class_name DirectionSwitcher

## Changes the horizontal direction in which the player moves
##
## When the player enters this area, their movement direction is switched
## based on the value of [member switch_to], whose default value is 
## [enum Enums.PLAYER_DIRECTION.RIGHT].

## Determines the direction the player should move after contact
@export var switch_to: Enums.PLAYER_DIRECTION = Enums.PLAYER_DIRECTION.RIGHT

## Checks if [param body] is a [Player]; if so, calls [method player.set_direction]
## to change the player's movement direction
func _on_body_entered(body: Node2D) -> void:
	if body is not Player: return
	var player: Player = body as Player
	player.set_direction(switch_to)
