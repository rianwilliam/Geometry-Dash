extends Node2D
class_name PlayerVisualBase

@export var anim_player: AnimationPlayer
@export var body_sprites: AnimatedSprite2D
@export var details_sprites: AnimatedSprite2D
@export var particles: CPUParticles2D

#TODO Colocar verificação das variaveis de export

@onready var normal_gravity_particles: Marker2D = $NormalGravityParticles
@onready var inverted_gravity_particles: Marker2D = $InvertedGravityParticles

const ACTION_ANIM: String = "action"
const NOT_ACTION_ANIM: String = "not_action"

func _ready() -> void:
	Events.connect("player_gravity_dir", _on_player_send_gravity_dir)
	if particles: 
		particles.modulate = body_sprites.modulate.to_html()

func turn_on_particles() -> void:
	particles.emitting = true

func turn_off_particles() -> void:
	particles.emitting = false

func _has_anim(anim_name: String) -> bool:
	if anim_player == null: return false
	return anim_player.has_animation(anim_name)

func play_action_anim() -> void:
	if not _has_anim(ACTION_ANIM): return
	anim_player.play(ACTION_ANIM)

func play_not_action_anim() -> void:
	if not _has_anim(NOT_ACTION_ANIM): return
	anim_player.play(NOT_ACTION_ANIM)

func _on_player_send_gravity_dir(direction: Enums.GRAVITY_DIR) -> void:
	if direction == Enums.GRAVITY_DIR.INVERTED:
		if not particles: return
		particles.position = inverted_gravity_particles.position
	else:
		if not particles: return
		particles.position = normal_gravity_particles.position
