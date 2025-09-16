extends ModeBase
class_name BallMode

func _process(delta: float) -> void:
	print(is_player_in_ceiling and is_player_in_floor)
	if is_player_in_floor or is_player_in_ceiling:
		enable_particles(true)
	else:
		enable_particles(false)
