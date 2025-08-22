extends JumpOrb
class_name PinkOrb

func _ready() -> void:
	_effect = {
		Enums.MODIFIERS.JUMP: Enums.JUMPS.SMALL
	}
