extends Control
class_name PauseMenu

@onready var resume_btn: Button = %ResumeBtn
@onready var quit_btn: Button = %QuitBtn

func _ready() -> void:
	size = get_viewport().get_visible_rect().size
	resume_btn.connect("pressed", _on_resume_btn_pressed)
	quit_btn.connect("pressed", _on_quit_btn_pressed)

func _on_resume_btn_pressed() -> void:
	Events.emit_signal("resume_btn_pressed")

func _on_quit_btn_pressed() -> void:
	Events.emit_signal("quit_btn_pressed")

func show_pause() -> void:
	visible = true

func hide_pause() -> void:
	visible = false
