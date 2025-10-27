extends PortalBase
class_name InvertGravityPortal


func _ready() -> void:
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not body is Player: return
	body.invert_gravity() 
