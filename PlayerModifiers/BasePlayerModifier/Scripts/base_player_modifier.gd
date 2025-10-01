extends Area2D
class_name PlayerModifier

## Base class for gameplay modifiers of the player
##
## The modifier receives one or more effects of type [enum MODIFIERS] and applies them to 
## the player when they interact with it. Whenever a class that inherits from it is
## instantiated, it must set the value of the [member effect] variable.

var effect: Dictionary[Enums.MODIFIERS, Variant]
var _type: Enums.MODIFIERS
var player_in_area: bool = false

func get_effect() -> Variant:
	assert(effect)
	return effect
	
func get_type() -> Enums.MODIFIERS:
	assert(_type)
	return _type

func _on_body_entered(body: Node2D) -> void:
	if body is not Player: return
	player_in_area = true

func _on_body_exited(body: Node2D) -> void:
	if body is not Player: return
	player_in_area = false
