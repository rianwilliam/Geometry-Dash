extends Button

@export var tab: Control

func _ready() -> void:
	connect("pressed", _on_back_btn_pressed)

func _on_back_btn_pressed() -> void:
	tab.visible = false
