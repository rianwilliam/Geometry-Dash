extends Area2D
class_name PlayerModifier

var effect: Array[Variant]

func get_effect() -> Variant:
	assert(effect)
	return effect
