extends Control

@onready var apply_btn: Button = %ApplyBtn

func _ready() -> void:
	apply_btn.connect("pressed", _on_apply_btn_pressed)

func _on_apply_btn_pressed() -> void:
	Events.emit_signal("send_custom_colors")
