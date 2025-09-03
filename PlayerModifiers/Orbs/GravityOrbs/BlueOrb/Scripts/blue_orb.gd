extends GravityOrb
class_name BlueOrb

func _ready() -> void:
	super._ready()
	_effect = {
		Enums.MODIFIERS.JUMP: Enums.JUMPS.SMALL,
		Enums.MODIFIERS.GRAVITY: Enums.GRAVITY_DIR.FLIP
	}
