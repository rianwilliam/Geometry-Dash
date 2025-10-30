extends GravityOrb
class_name GreenOrb

func _ready() -> void:
	super._ready()
	effect = {
		Enums.MODIFIERS.GRAVITY: Enums.GRAVITY_DIR.FLIP
	}
