extends GravityOrb
class_name BlueOrb

func _ready() -> void:
	super._ready()
	_effect = [Enums.GRAVITY_DIR.FLIP]
