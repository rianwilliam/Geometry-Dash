extends Control
class_name CustomizeMenu

## Menu where the player customizes the color of each mode
##
##

@onready var apply_btn: Button = %ApplyBtn ## Button responsible for applying the selected colors

func _ready() -> void:
	apply_btn.connect("pressed", _on_apply_btn_pressed)

## Emits the [signal Events.send_custom_colors] signal to the [ModeColorManager]
func _on_apply_btn_pressed() -> void:
	Events.emit_signal("send_custom_colors")
