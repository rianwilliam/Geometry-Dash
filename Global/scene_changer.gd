extends Node

## Responsible for storing the paths of the scenes and switching between them
##
##

const MAIN_MENU: String = "res://Ui/Menus/MainMenu/Scenes/main_menu.tscn" ## Stores the path of [MainMenu]
const LEVELS_MENU: String = "res://Ui/Menus/LevelsMenu/Scenes/levels_menu.tscn" ## Stores the path of [LevelsMenu]
const LEVEL_ONE: String = "res://Maps/Levels/LevelOne/Scenes/level_one.tscn" ## Stores the path of Level 1
const LEVEL_TWO: String = "res://Maps/Levels/LevelTwo/Scenes/level_two.tscn" ## Stores the path of Level 2
const LEVEL_THREE: String = "res://Maps/Levels/LevelThree/Scenes/level_three.tscn" ## Stores the path of Level 3

## Unpauses the game through [method _unpause_game_process] and changes the current scene
## based on the value of [param scene], which is an [enum Enums.SCENES]
func change_scene(scene: Enums.SCENES) -> void:
	_unpause_game_process()
	match scene:
		Enums.SCENES.MAIN_MENU:
			_open_scene(MAIN_MENU)
		Enums.SCENES.LEVELS_MENU:
			_open_scene(LEVELS_MENU)
		Enums.SCENES.LEVEL_ONE:
			_open_scene(LEVEL_ONE)
		Enums.SCENES.LEVEL_TWO:
			_open_scene(LEVEL_TWO)
		Enums.SCENES.LEVEL_THREE:
			_open_scene(LEVEL_THREE)

func _open_scene(path: String) -> void:
	get_tree().change_scene_to_file(path)

func _unpause_game_process() -> void:
	get_tree().paused = false
