extends Area2D
class_name PlayerModifier

var _effect: Dictionary[int, int]
var _type: Enums.MODIFIERS
var player_in_area: bool = false

func get_effect() -> Variant:
	assert(_effect)
	return _effect
	
func get_type() -> Enums.MODIFIERS:
	assert(_type)
	return _type

func _on_body_entered(body: Node2D) -> void:
	player_in_area = true

func _on_body_exited(body: Node2D) -> void:
	player_in_area = false
