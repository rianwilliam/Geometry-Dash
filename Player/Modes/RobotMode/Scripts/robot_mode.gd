extends ModeBase
class_name RobotMode

@onready var fly_timer: Timer = $FlyTimer
const _FLY_TIME_LIMIT: float = 0.3

signal robot_fly_timeout

func start_fly_timer() -> void:
	if fly_timer.is_stopped(): 
		fly_timer.start(_FLY_TIME_LIMIT)

func reset_fly_timer() -> void:
	fly_timer.stop()

func _on_fly_timer_timeout() -> void:
	robot_fly_timeout.emit()
