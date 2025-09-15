extends CollisionShape2D
class_name PlayerCollision

func _ready() -> void:
	Events.connect("set_player_collision_shape", _on_set_player_collision_shape)

func _on_set_player_collision_shape(new_collision: CollisionShape2D) -> void:
	call_deferred("set_shape", new_collision.shape)
