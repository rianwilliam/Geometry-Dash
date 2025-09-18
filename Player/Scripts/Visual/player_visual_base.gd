extends Node2D
class_name PlayerVisualBase

@export var anim_player: AnimationPlayer
@export var body_sprites: AnimatedSprite2D
@export var details_sprites: Array[AnimatedSprite2D]
@export var particles: CPUParticles2D

@onready var normal_gravity_particles_position: Marker2D = $NormalGravityParticles
@onready var inverted_gravity_particles_position: Marker2D = $InvertedGravityParticles

const ACTION_ANIM: String = "action"
const NOT_ACTION_ANIM: String = "not_action"

func _ready() -> void:
	_validate_required_nodes()
	_set_particles_color()

func _validate_required_nodes() -> void:
	assert(anim_player)
	assert(body_sprites)
	assert(details_sprites)
	assert(particles)

func _set_particles_color() -> void:
	particles.modulate = body_sprites.modulate.to_html()

func set_particles_active(state: bool) -> void:
	particles.emitting = state

func _has_anim(anim_name: String) -> bool:
	return anim_player.has_animation(anim_name)

# This functions are used by ModeBase
#region Animations
func play_action_anim() -> void:
	if not _has_anim(ACTION_ANIM): return
	anim_player.play(ACTION_ANIM)

func play_not_action_anim() -> void:
	if not _has_anim(NOT_ACTION_ANIM): return
	anim_player.play(NOT_ACTION_ANIM)
#endregion
