extends Control
class_name MainMenu

func _ready() -> void:
	$PlayBtn.connect("pressed", _on_play_btn_pressed)

func _on_play_btn_pressed() -> void:
	get_tree().change_scene_to_file(ScenePaths.LEVEL_1)
