extends Area2D

@export var transform_to: Enums.PLAYER_MODE

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.change_mode(transform_to)
