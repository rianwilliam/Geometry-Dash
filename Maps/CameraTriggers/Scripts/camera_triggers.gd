extends Node2D
class_name CameraTriggers
## Responsible for storing the camera start and stop triggers
##
## The camera will follow the player once its [code]x[/code] position is greater than or equal to 
## [member start], and will stop following when the same happens with [member stop].

@onready var start: Node2D = $Start
@onready var stop: Node2D = $Stop

func start_position() -> Vector2:
	return start.position

func stop_position() -> Vector2:
	return stop.position
