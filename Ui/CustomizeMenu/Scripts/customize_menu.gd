extends Control


@onready var button: Button = $Buttons/Button

func _ready() -> void:
	button.connect("pressed", _on_btn_press)

func _on_btn_press() -> void:
	visible = false
