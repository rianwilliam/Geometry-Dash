extends Area2D
class_name ModeSwitcher

@export var transform_to: Enums.PLAYER_MODE

func _on_body_entered(body: Node2D) -> void:
	if not body is Player: return
	body.change_mode(transform_to)
