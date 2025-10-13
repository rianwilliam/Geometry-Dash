extends Node

## Responsible for storing the paths of the scenes and switching between them
##
##

const MAIN_MENU: String = "res://Ui/Menus/MainMenu/Scenes/main_menu.tscn" ## Stores the path of [MainMenu]
const LEVEL_ONE: String = "res://Maps/Levels/LevelOne/Scenes/level_one.tscn" ## Stores the path of Level 1
const LEVEL_TWO: String = "res://Maps/Levels/LevelTwo/Scenes/level_two.tscn" ## Stores the path of Level 2
const LEVEL_THREE: String = "res://Maps/Levels/LevelThree/Scenes/level_three.tscn" ## Stores the path of Level 3

## Unpauses the game through [method _unpause_game_process] and changes the current scene
## based on the value of [param scene], which is an [enum Enums.SCENES]
func change_scene(scene: Enums.SCENES) -> void:
	_unpause_game_process()
	match scene:
		Enums.SCENES.MAIN_MENU:
			get_tree().change_scene_to_file(MAIN_MENU)
		Enums.SCENES.LEVEL_ONE:
			get_tree().change_scene_to_file(LEVEL_ONE)
		Enums.SCENES.LEVEL_TWO:
			get_tree().change_scene_to_file(LEVEL_TWO)
		Enums.SCENES.LEVEL_THREE:
			get_tree().change_scene_to_file(LEVEL_THREE)

func _unpause_game_process() -> void:
	get_tree().paused = false
