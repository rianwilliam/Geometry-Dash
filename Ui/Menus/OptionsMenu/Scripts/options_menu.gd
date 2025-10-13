extends Control
class_name OptionsMenus

## Menu that contains the game's configuration options
##
## Handles settings such as volume and other global preferences.

@onready var volume_value: HSlider = %VolumeValue ## Determines the value of the global volume

## Connects the value change event of the slider and retrieves the last saved
## volume value set by the player
func _ready() -> void:
	volume_value.connect("value_changed", _on_volume_value_change)
	volume_value.value = AudioController.get_main_volume()

## Changes the global volume value through the [AudioController]
func _on_volume_value_change(value: float) -> void:
	AudioController.set_main_volume(value)
