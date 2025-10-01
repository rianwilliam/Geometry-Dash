extends JumpOrb
class_name PinkOrb

func _ready() -> void:
	super._ready()
	effect = {
		Enums.MODIFIERS.JUMP: Enums.JUMPS.SMALL
	}
