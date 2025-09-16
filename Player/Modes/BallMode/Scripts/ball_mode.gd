extends ModeBase
class_name BallMode

func _process(_delta: float) -> void:
	if is_player_in_floor or is_player_in_ceiling:
		enable_particles(true)
	else:
		enable_particles(false)
