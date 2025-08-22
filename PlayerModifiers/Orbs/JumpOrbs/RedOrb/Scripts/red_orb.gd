extends JumpOrb
class_name RedOrb

func _ready() -> void:
	_effect = {
		Enums.MODIFIERS.JUMP: Enums.JUMPS.HIGH
	}
