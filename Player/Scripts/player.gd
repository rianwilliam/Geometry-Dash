extends CharacterBody2D
class_name Player

#TODO Colocar jump() como _jump()

@onready var hurt_box: Area2D = %HurtBox
@onready var spawn: Marker2D = %PlayerSpawn
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player_elements: Node2D = %PlayerElements

@export var _gravity_dir: Enums.GRAVITY_DIR = Enums.GRAVITY_DIR.NORMAL
@export var _square_rsc: SquareResource
@export var _wave_rsc: WaveResource
@export var _ufo_rsc: UfoResource
@export var _ball_rsc: BallResource
@export var _spaceship_rsc: SpaceshipResource

var _is_on_orb: bool = false
var _is_on_pad: bool = false
var _modifier_used: bool = false
var _modifier_effect: Variant
var _modifier_type: Enums.MODIFIERS

var _can_action: bool = true
var _action_pressed: bool
var _action_clicked: bool
var _mode: Enums.PLAYER_MODE = Enums.PLAYER_MODE.SQUARE
var _active_rsc: PlayerBaseResource
var _wave_trial: WaveTrial
var _player_resources: Dictionary[Enums.PLAYER_MODE, PlayerBaseResource]

const _WAVE_TRIAL_SCENE = preload("res://Player/Scenes/wave_trial.tscn")

func _ready() -> void:
	_player_resources = {
		Enums.PLAYER_MODE.SQUARE: _square_rsc,
		Enums.PLAYER_MODE.WAVE: _wave_rsc,
		Enums.PLAYER_MODE.UFO: _ufo_rsc,
		Enums.PLAYER_MODE.BALL: _ball_rsc,
		Enums.PLAYER_MODE.SPACESHIP: _spaceship_rsc
	}
	global_position = spawn.global_position
	_set_active_resource()

func _physics_process(delta: float) -> void:
	_action_pressed = Input.is_action_pressed("Action")
	_action_clicked = Input.is_action_just_pressed("Action")
	velocity.x = _active_rsc.speed
	
	match _mode:
		Enums.PLAYER_MODE.SQUARE: _square_mode(delta)
		Enums.PLAYER_MODE.WAVE: _wave_mode(delta)
		Enums.PLAYER_MODE.BALL: _ball_mode(delta)
		Enums.PLAYER_MODE.UFO: _ufo_mode(delta)
		Enums.PLAYER_MODE.SPACESHIP: _spaceship_mode(delta)
	
	if (_orb_jump() or _pad_jump()) and not _modifier_used:
		if not _modifier_effect or not _modifier_type: return
		match _modifier_type:
			Enums.MODIFIERS.JUMP: _jump_modifiers_actions()
			Enums.MODIFIERS.GRAVITY: _gravity_modifiers_actions()
			Enums.MODIFIERS.DASH: pass
		_modifier_used = true

	move_and_slide()

func _jump_modifiers_actions() -> void:
	for effect in _modifier_effect:
		match effect:
			Enums.JUMPS.MEDIUM: jump()
			Enums.JUMPS.SMALL: jump(Enums.JUMPS.SMALL)
			Enums.JUMPS.HIGH: jump(Enums.JUMPS.HIGH)

func _gravity_modifiers_actions() -> void:
	for effect in _modifier_effect:
		match effect:
			Enums.GRAVITY_DIR.FLIP: _invert_gravity()
			Enums.GRAVITY_DIR.INVERTED: _set_gravity(Enums.GRAVITY_DIR.INVERTED)
			Enums.GRAVITY_DIR.NORMAL: _set_gravity(Enums.GRAVITY_DIR.NORMAL)

func _set_active_resource() -> void:
	_active_rsc = _player_resources.get(_mode)

func _orb_jump() -> bool:
	return _action_clicked and _is_on_orb

func _pad_jump() -> bool:
	return _is_on_pad

#region Square
func _square_mode(delta: float) -> void:
	if not is_on_floor() or not is_on_ceiling():
		_apply_gravity(delta)

	if (
	_action_pressed and is_on_floor() or \
	_action_pressed and is_on_ceiling()
	):
		jump()
		_play_jump_anim()
	
	if _orb_jump():
		_play_jump_anim()

func _play_jump_anim() -> void:
	animation_player.play("rotate")

#endregion

func jump(jump_size: Enums.JUMPS = Enums.JUMPS.MEDIUM) -> void:
	match jump_size:
		Enums.JUMPS.SMALL: velocity.y = (_active_rsc.jump_height * _gravity_dir) / 1.5
		Enums.JUMPS.MEDIUM: velocity.y = _active_rsc.jump_height * _gravity_dir
		Enums.JUMPS.HIGH: velocity.y = _active_rsc.jump_height * _gravity_dir * 2

func change_mode(new_mode: Enums.PLAYER_MODE) -> void:
	_mode = new_mode
	_on_mode_entered()

func _on_mode_entered() -> void:
	_set_active_resource()
	match _mode:
		#Enums.PLAYER_MODE.SQUARE: _square_mode()
		Enums.PLAYER_MODE.WAVE: _on_enter_wave_mode()
		#Enums.PLAYER_MODE.BALL: _ball_mode()
		#Enums.PLAYER_MODE.UFO: _ufo_mode()
		#Enums.PLAYER_MODE.SPACESHIP: _spaceship_mode()

#region Gravity
func _apply_gravity(delta: float) -> void:
	velocity.y += _active_rsc.gravity * _gravity_dir * delta

func _invert_gravity() -> void:
	_gravity_dir *= -1

func _set_gravity(new_dir: Enums.GRAVITY_DIR) -> void:
	_gravity_dir = new_dir
#endregion

func _on_hurt_box_body_entered(_body: Node2D) -> void:
	Events.emit_signal("player_died")
	_reset_player()

#region Wave
func _on_enter_wave_mode() -> void:
	_wave_trial = _WAVE_TRIAL_SCENE.instantiate()
	_wave_trial.global_position = Vector2.ZERO
	player_elements.add_child(_wave_trial)
	_add_trial_point()

func _wave_mode(_delta: float) -> void:
	velocity.y = _active_rsc.vertical_speed * _active_rsc.direction * _gravity_dir
	if _action_pressed:
		_change_wave_direction(Enums.WAVE_DIR.UP)
		_add_trial_point()
	else:
		_change_wave_direction(Enums.WAVE_DIR.DOWN)
		_add_trial_point()
	
func _add_trial_point() -> void:
	if not _wave_trial: return
	_wave_trial.add_point(global_position)

func _change_wave_direction(new_dir: Enums.WAVE_DIR) -> void:
	_active_rsc.direction = new_dir
#endregion

#region Ball
func _ball_mode(delta: float) -> void:
	_apply_gravity(delta)
	if not _can_action: return
	if _action_clicked and is_on_ceiling() : _invert_gravity()
	elif _action_clicked and is_on_floor(): _invert_gravity()
#endregion

#region Ufo
func _ufo_mode(delta: float) -> void:
	_apply_gravity(delta)
	if not _can_action: return
	if _action_clicked:
		velocity.y = _active_rsc.impulse_height * _gravity_dir
#endregion

#region Reset
func _reset_player() -> void:
	global_position = spawn.global_position
	change_mode(Enums.PLAYER_MODE.SQUARE)
#endregion

#region Spaceship
func _spaceship_mode(delta: float) -> void:
	if _action_pressed and _can_action:
		velocity.y += _active_rsc.vertical_vel * _gravity_dir
	else:
		_apply_gravity(delta)
#endregion

func _on_modifier_sensor_area_entered(area: Area2D) -> void:
	if not area is PlayerModifier: return
	if area is Orb:
		_is_on_orb = true
	_can_action = false
	_modifier_effect = area.get_effect()
	_modifier_type = area.get_type()

func _on_modifier_sensor_area_exited(area: Area2D) -> void:
	if not area is PlayerModifier: return
	_is_on_orb = false
	_can_action = true
	_modifier_used = false
