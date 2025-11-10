extends Area2D
class_name LevelCompleteTrigger

@export var level_number: Enums.LEVELSNUMBER

func _ready() -> void:
	assert(level_number, "Level Number not Setted")
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not body is Player: return
	SceneChanger.change_scene(Enums.SCENES.LEVELS_MENU)
