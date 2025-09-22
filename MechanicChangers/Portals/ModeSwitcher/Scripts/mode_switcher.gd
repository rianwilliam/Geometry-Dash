extends Area2D
class_name ModeSwitcher

@export var transform_to: Enums.PLAYER_MODE
const _PLAYER_VERTICAL_CORRECTION: int = 16

func _on_body_entered(body: Node2D) -> void:
	if not body is Player: return
	_apply_vertical_correction(body)
	body.change_mode(transform_to)

func _apply_vertical_correction(player: Player) -> void:
	player.global_position.y = global_position.y - _PLAYER_VERTICAL_CORRECTION
