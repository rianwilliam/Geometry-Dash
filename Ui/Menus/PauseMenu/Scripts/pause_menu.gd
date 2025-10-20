extends Control
class_name PauseMenu

## Menu displayed when the player presses the pause button
##
## Contains options to either resume the game or quit back to the [LevelsMenu].

@onready var resume_btn: Button = %ResumeBtn ## When pressed, resumes the game
@onready var quit_btn: Button = %QuitBtn ## When pressed, returns to the [LevelsMenu]
@onready var options_btn: Button = %OptionsBtn ## When pressed, show the [OptionsMenu]
@onready var options_menu: OptionsMenus = $OptionsMenu

func _ready() -> void:
	resume_btn.connect("pressed", _on_resume_btn_pressed)
	quit_btn.connect("pressed", _on_quit_btn_pressed)
	options_btn.connect("pressed", _on_options_btn_pressed)

## Adjusts the menu size to match the current viewport size
func _resize_menu_to_viewport() -> void:
	size = get_viewport().get_visible_rect().size

## Emits a signal indicating that the resume button was pressed
func _on_resume_btn_pressed() -> void:
	Events.emit_signal("resume_btn_pressed")

## Emits a signal indicating that the quit button was pressed
func _on_quit_btn_pressed() -> void:
	Events.emit_signal("quit_btn_pressed")

func _on_options_btn_pressed() -> void:
	options_menu.visible = true

## Makes the pause menu visible
func show_pause() -> void:
	visible = true

## Hides the pause menu
func hide_pause() -> void:
	visible = false
