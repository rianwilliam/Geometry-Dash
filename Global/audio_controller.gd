extends Node

## Controls the global audio of the game
##
## The [AudioController] is responsible for storing and applying 
## the volume level defined by the player.

var _volume: float = 0.5 ## Stores the current volume
var main_bus_idx: int = AudioServer.get_bus_index("Master") ## Gets the index of the "Master" bus

## Changes the value of [member _volume] to the one passed through [param value]
func set_main_volume(value: float) -> void:
	_volume = value
	AudioServer.set_bus_volume_db(main_bus_idx, linear_to_db(_volume))

## Returns the [member _volume]
func get_main_volume() -> float:
	return _volume
