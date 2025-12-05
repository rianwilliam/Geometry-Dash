extends Area2D
class_name LevelCompleteTrigger

## Point that defines the end of a level
##
## When the player comes into contact with this element, the level is completed
## and the function that switches the scene back to the level selection menu is executed

@export var level_number: Enums.LEVELSNUMBER ## Represents the current level number

func _ready() -> void:
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not body is Player: return
	LevelStateHandler.level_completed(level_number)
	SceneChanger.change_scene(Enums.SCENES.LEVELS_MENU)
