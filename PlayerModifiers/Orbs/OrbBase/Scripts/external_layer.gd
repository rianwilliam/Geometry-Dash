extends Marker2D
class_name OrbExternalLayer

@onready var anim_player: AnimationPlayer = $AnimPlayer

const POP_ANIM: String = "pop"

func play_pop_anim() -> void:
	anim_player.play(POP_ANIM)
