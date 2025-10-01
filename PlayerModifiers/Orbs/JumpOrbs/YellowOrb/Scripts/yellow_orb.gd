extends JumpOrb
class_name YellowOrb

func _ready() -> void:
	super._ready()
	effect = {
		Enums.MODIFIERS.JUMP: Enums.JUMPS.MEDIUM
	}
