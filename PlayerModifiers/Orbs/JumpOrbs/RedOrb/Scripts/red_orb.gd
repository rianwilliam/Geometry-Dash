extends JumpOrb
class_name RedOrb

func _ready() -> void:
	super._ready()
	effect = {
		Enums.MODIFIERS.JUMP: Enums.JUMPS.HIGH
	}
