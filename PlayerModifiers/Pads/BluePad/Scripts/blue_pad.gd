extends Pad
class_name BluePad

func _ready() -> void:
	_effect = {
		Enums.MODIFIERS.GRAVITY: Enums.GRAVITY_DIR.FLIP,
		Enums.MODIFIERS.JUMP: Enums.JUMPS.MEDIUM
	}
