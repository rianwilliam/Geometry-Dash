extends Control
class_name LevelsMenu

## Tab responsible for level selection
##
##

@export var level_number: Enums.SCENES

@onready var lvl_1_btn: Button = %Lvl1Btn ## Button responsible for switching to the level 1 scene
@onready var lvl_2_btn: Button = %Lvl2Btn ## Button responsible for switching to the level 2 scene
@onready var lvl_3_btn: Button = %Lvl3Btn ## Button responsible for switching to the level 3 scene
@onready var back_to_menu_btn: Button = %BackToMenuBtn ## Button responsible for returning to the main menu

const COMPLETE_LVL_BTN: Theme = preload("uid://difkmoghwod51")

func _ready() -> void:
	get_tree().paused = false
	_connect_events()
	_verify_level_states()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

## Connects the button click events
func _connect_events() -> void:
	lvl_1_btn.connect("pressed", _on_lvl_1_btn_pressed)
	lvl_2_btn.connect("pressed", _on_lvl_2_btn_pressed)
	lvl_3_btn.connect("pressed", _on_lvl_3_btn_pressed)
	back_to_menu_btn.connect("pressed", _on_back_to_menu_btn_pressed)

func _verify_level_states() -> void:
	if LevelStateHandler.level_one_complete: lvl_1_btn.theme = COMPLETE_LVL_BTN
	if LevelStateHandler.level_two_complete: lvl_2_btn.theme = COMPLETE_LVL_BTN
	if LevelStateHandler.level_three_complete: lvl_3_btn.theme = COMPLETE_LVL_BTN

func _on_back_to_menu_btn_pressed() -> void:
	SceneChanger.change_scene(Enums.SCENES.MAIN_MENU)

func _on_lvl_1_btn_pressed() -> void:
	SceneChanger.change_scene(Enums.SCENES.LEVEL_ONE)

func _on_lvl_2_btn_pressed() -> void:
	SceneChanger.change_scene(Enums.SCENES.LEVEL_TWO)

func _on_lvl_3_btn_pressed() -> void:
	SceneChanger.change_scene(Enums.SCENES.LEVEL_THREE)
