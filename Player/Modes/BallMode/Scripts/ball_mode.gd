extends ModeBase
class_name BallMode

func _process(_delta: float) -> void:
	if is_player_in_floor or is_player_in_ceiling:
		player_visual_base.set_particles_active(true)
	else:
		player_visual_base.set_particles_active(false)
