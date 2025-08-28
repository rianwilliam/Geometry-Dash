extends Pad
class_name GreenPad

func _ready() -> void:
	_effect = {
		Enums.MODIFIERS.GRAVITY: Enums.GRAVITY_DIR.FLIP
	}
