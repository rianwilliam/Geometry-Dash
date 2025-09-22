extends ModeBase
class_name SpaceshipMode

const ROTATION_LIMIT: int = 35
const ROTATION_INCREMENT: int = 2



func _process(_delta: float) -> void:
	if not is_player_action and (is_player_in_floor or is_player_in_ceiling):
		rotation_degrees = 0
	if is_player_action and not is_player_in_ceiling:
		if rotation_degrees > ROTATION_LIMIT * -1:
			rotation_degrees += ROTATION_INCREMENT * -1
