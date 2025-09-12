extends Node2D
class_name PlayerVisuals

@onready var player_animations: AnimationPlayer = $PlayerAnimations
@onready var body_sprites: AnimatedSprite2D = $BodySprites
@onready var details_sprites: AnimatedSprite2D = $DetailsSprites

const JUMP_ANIM: String = "jump"

func _ready() -> void:
	set_skin()

func play_jump_anim() -> void:
	player_animations.play(JUMP_ANIM)

func set_skin(skin_id: Enums.SKIN_IDS = Enums.SKIN_IDS.ID_0) -> void:
	body_sprites.animation = str(skin_id)
	details_sprites.animation = str(skin_id)
