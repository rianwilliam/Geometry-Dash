extends Node

var _volume: float = 0.5
var main_bus_idx: int = AudioServer.get_bus_index("Master")

func set_main_volume(value: float) -> void:
	_volume = value
	AudioServer.set_bus_volume_db(main_bus_idx, linear_to_db(value))

func get_main_volume() -> float:
	return _volume
