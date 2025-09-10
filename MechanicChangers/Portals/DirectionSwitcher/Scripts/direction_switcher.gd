extends PortalBase
class_name DirectionSwitcher

@export var switch_to: Enums.PLAYER_DIRECTION = Enums.PLAYER_DIRECTION.RIGHT

func _on_body_entered(body: Node2D) -> void:
	if body is not Player: return
	var player: Player = body as Player
	player.set_direction(switch_to)
