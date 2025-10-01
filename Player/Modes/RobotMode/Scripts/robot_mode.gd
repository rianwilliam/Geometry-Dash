extends ModeBase
class_name RobotMode

@onready var fly_timer: Timer = $FlyTimer
var _robot_rsc: RobotResource = RobotResource.new()
signal robot_fly_timeout

func _process(_delta: float) -> void:
	if is_player_action:
		player_visual_base.play_action_anim()
	if not is_player_action and (is_player_in_ceiling or is_player_in_floor):
		player_visual_base.play_not_action_anim()

func start_fly_timer() -> void:
	if fly_timer.is_stopped(): 
		fly_timer.start(_robot_rsc.fly_time)

func reset_fly_timer() -> void:
	fly_timer.stop()

func _on_fly_timer_timeout() -> void:
	robot_fly_timeout.emit()
