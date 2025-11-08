extends Node

@onready var start: Node2D = $Start
@onready var stop: Node2D = $Stop

func start_position() -> Vector2:
	return start.position

func stop_position() -> Vector2:
	return stop.position
