extends GravityOrb
class_name BlackOrb

func _ready() -> void:
	super._ready()
	effect = {
		Enums.MODIFIERS.G_FORCE: Enums.GRAVITY_FORCE.STRONG
	}
