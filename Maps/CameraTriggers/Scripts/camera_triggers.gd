extends Node2D
class_name CameraTriggers
## Responsible for storing the camera start and stop triggers
##
## The camera will follow the player once its [code]x[/code] position is greater than or equal to 
## [member start], and will stop following when the same happens with [member stop].

@onready var start_area: Area2D = $StartArea
@onready var stop_area: Area2D = $StopArea

var can_follow: bool = false

func _ready() -> void:
	start_area.connect("body_entered", _on_start_area_body_entered)
	stop_area.connect("body_entered", _on_stop_area_body_entered)

func _on_start_area_body_entered(body: Node2D) -> void:
	if not body is Player: return
	can_follow = true

func _on_stop_area_body_entered(body: Node2D) -> void:
	if not body is Player: return
	can_follow = false
