extends Node

const MAIN_MENU: String = "res://Ui/Menus/MainMenu/Scenes/main_menu.tscn"
const LEVEL_MENU: String = ""

func change_scene(scene: Enums.SCENES) -> void:
	_unpause_game_process()
	match scene:
		Enums.SCENES.MAIN_MENU:
			get_tree().change_scene_to_file(MAIN_MENU)

func _unpause_game_process() -> void:
	get_tree().paused = false
