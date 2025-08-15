extends Area2D
class_name Orb

func _on_body_entered(body: Node2D) -> void:
	if not body is Player: return
	body.is_on_orb = true

func _on_body_exited(body: Node2D) -> void:
	if not body is Player: return
	body.is_on_orb = false
