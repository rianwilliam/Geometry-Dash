extends ModeBase
class_name WaveMode

const IN_SURFACE_ROTATE_DEG: int = 0
const NOT_ACTION_ROTATE_DEG: int = 45
const ACTION_ROTATE_DEG: int = -45

signal rotation_requested(requested_degress: int)

func _process(_delta: float) -> void:
	if is_player_in_floor or is_player_in_ceiling: rotation_requested.emit(IN_SURFACE_ROTATE_DEG)
	elif is_player_action: rotation_requested.emit(ACTION_ROTATE_DEG)
	else: rotation_requested.emit(NOT_ACTION_ROTATE_DEG)
