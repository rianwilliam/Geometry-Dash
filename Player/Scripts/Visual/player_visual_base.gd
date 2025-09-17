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
	Events.connect("player_gravity_dir", _on_player_send_gravity_dir)
	Events.connect("player_died", _on_player_die)

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

func _flip_sprites_vertically(invert: bool) -> void:
	body_sprites.flip_v = invert
	for animated_sprite: AnimatedSprite2D in details_sprites:
		animated_sprite.flip_v = invert

func _change_particles_position_to(marker: Marker2D) -> void:
	particles.position = marker.position

func _on_player_send_gravity_dir(direction: Enums.GRAVITY_DIR) -> void:
	if direction == Enums.GRAVITY_DIR.INVERTED:
		_change_particles_position_to(inverted_gravity_particles_position)
		_flip_sprites_vertically(true)
	else:
		_change_particles_position_to(normal_gravity_particles_position)
		_flip_sprites_vertically(false)

func _on_player_die() -> void:
	_flip_sprites_vertically(false)
