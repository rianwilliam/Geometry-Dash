extends Area2D
class_name PlayerModifier

var _effect: Dictionary[int, int]
var _type: Enums.MODIFIERS

func get_effect() -> Variant:
	assert(_effect)
	return _effect
	
func get_type() -> Enums.MODIFIERS:
	assert(_type)
	return _type
