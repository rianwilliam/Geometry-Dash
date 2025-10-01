extends Pad
class_name GreenPad

func _ready() -> void:
	effect = {
		Enums.MODIFIERS.GRAVITY: Enums.GRAVITY_DIR.FLIP
	}
