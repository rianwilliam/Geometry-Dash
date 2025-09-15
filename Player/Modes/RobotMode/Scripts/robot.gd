extends Node
class_name Robot

@onready var fly_timer: Timer = $FlyTimer

func start_fly_timer() -> void:
	if fly_timer.is_stopped(): 
		fly_timer.start()

func reset_fly_timer() -> void:
	fly_timer.stop()
