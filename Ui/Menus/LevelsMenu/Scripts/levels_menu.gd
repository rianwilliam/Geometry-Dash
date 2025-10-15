extends Control
class_name LevelsMenu

## Tab responsible for level selection
##
##

@onready var lvl_1_btn: Button = %Lvl1Btn ## Button responsible for switching to the level 1 scene
@onready var lvl_2_btn: Button = %Lvl2Btn ## Button responsible for switching to the level 2 scene
@onready var lvl_3_btn: Button = %Lvl3Btn ## Button responsible for switching to the level 3 scene
@onready var back_to_menu_btn: Button = %BackToMenuBtn ## Button responsible for returning to the main menu

func _ready() -> void:
	get_tree().paused = false
	_connect_events()

## Connects the button click events
func _connect_events() -> void:
	lvl_1_btn.connect("pressed", _on_lvl_1_btn_pressed)
	lvl_2_btn.connect("pressed", _on_lvl_2_btn_pressed)
	lvl_3_btn.connect("pressed", _on_lvl_3_btn_pressed)
	back_to_menu_btn.connect("pressed", _on_back_to_menu_btn_pressed)

func _on_back_to_menu_btn_pressed() -> void:
	SceneChanger.change_scene(Enums.SCENES.MAIN_MENU)

func _on_lvl_1_btn_pressed() -> void:
	SceneChanger.change_scene(Enums.SCENES.LEVEL_ONE)

func _on_lvl_2_btn_pressed() -> void:
	SceneChanger.change_scene(Enums.SCENES.LEVEL_TWO)

func _on_lvl_3_btn_pressed() -> void:
	SceneChanger.change_scene(Enums.SCENES.LEVEL_THREE)
