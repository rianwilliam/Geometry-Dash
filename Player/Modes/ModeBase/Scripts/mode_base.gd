extends Node2D
class_name ModeBase

@onready var collision: CollisionShape2D = $Collision

func get_collision_shape() -> CollisionShape2D:
	return collision
