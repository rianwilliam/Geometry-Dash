extends Control
class_name MainMenu

## Main game menu
##
## Contains the [OptionsMenu] and [CustomizeMenu]

@onready var quit_btn: Button = %QuitBtn
@onready var customize_btn: Button = %CustomizeBtn
@onready var options_btn: Button = %OptionsBtn
@onready var play_btn: Button = %PlayBtn
@onready var options_menu: Control = $OptionsMenu
@onready var customize_menu: Control = $CustomizeMenu
@onready var levels_menu: LevelsMenu = $LevelsMenu

## Performs the connection of required events through [method _connect_events]
func _ready() -> void:
	_connect_events()

## Connects the necessary events for the menu to work properly
func _connect_events() -> void:
	options_btn.connect("pressed", _on_options_btn_pressed)
	customize_btn.connect("pressed", _on_customize_btn_pressed)
	play_btn.connect("pressed", _on_play_btn_pressed)
	quit_btn.connect("pressed", _on_quit_btn_pressed)

## Makes the [CustomizeMenu] visible when the [member customize_btn] button is pressed
func _on_customize_btn_pressed() -> void:
	customize_menu.visible = true

## Quits the game when the [member quit_btn] button is pressed
func _on_quit_btn_pressed() -> void:
	get_tree().quit()

## Makes the [OptionsMenu] visible when the [member options_btn] button is pressed
func _on_options_btn_pressed() -> void:
	options_menu.visible = true

## Makes the [LevelsMenu] visible when the [member play_btn] button is pressed
func _on_play_btn_pressed() -> void:
	SceneChanger.change_scene(Enums.SCENES.LEVELS_MENU)
