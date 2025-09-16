extends ModeBase
class_name WaveMode

func _process(_delta: float) -> void:
	print(is_player_in_ceiling)
	if is_player_in_floor or is_player_in_ceiling:
		rotation_degrees = 0
	elif is_player_action:
		rotation_degrees = -45
	else:
		rotation_degrees = 45
