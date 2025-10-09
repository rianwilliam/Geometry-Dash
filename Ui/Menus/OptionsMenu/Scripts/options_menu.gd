extends Control
class_name OptionsMenus

@onready var volume_value: HSlider = %VolumeValue

func _ready() -> void:
	volume_value.connect("value_changed", _on_volume_value_change)
	volume_value.value = AudioController.get_main_volume()
	
func _on_volume_value_change(value: float) -> void:
	AudioController.set_main_volume(value)
