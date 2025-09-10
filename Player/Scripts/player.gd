extends CharacterBody2D
class_name Player

#TODO Recortar o sprite do player, fazer uma animação dele despedaçando e saindo partículas
# Fazer uma função que recebe os nós dos sprites, assim funcionando para qualquer elemento
#TODO Portal que inverte a direção do jogador
#TODO Portal que teleporta o jogador
#TODO Criar função para logica de pulo
#TODO Criar função que verifica se o jogador está parado

@onready var hurt_box: Area2D = %HurtBox
@onready var spawn: Marker2D = %PlayerSpawn
@onready var animation_player: AnimationPlayer = $AnimPlayer
@onready var player_elements: Node2D = %PlayerElements
@onready var robot_nodes: Robot = $RobotNodes

@export var _gravity_dir: Enums.GRAVITY_DIR = Enums.GRAVITY_DIR.NORMAL

#TODO Usando o preload, os valores nao eram atualizados quando mudava na base
#var _square_rsc: SquareResource = preload("res://Player/Resources/Square/square_rsc.tres")
#var _wave_rsc: WaveResource = preload("res://Player/Resources/Wave/wave_rsc.tres")
#var _ufo_rsc: UfoResource = preload("res://Player/Resources/Ufo/ufo_rsc.tres")
#var _ball_rsc: BallResource = preload("res://Player/Resources/Ball/ball_rsc.tres")
#var _spaceship_rsc: SpaceshipResource = preload("res://Player/Resources/SpaceShip/spaceship_rsc.tres")
#var _robot_rsc: RobotResource = preload("res://Player/Resources/Robot/robot_rsc.tres")
var _square_rsc: SquareResource = SquareResource.new()
var _wave_rsc: WaveResource = WaveResource.new()
var _ufo_rsc: UfoResource = UfoResource.new()
var _ball_rsc: BallResource = BallResource.new()
var _spaceship_rsc: SpaceshipResource = SpaceshipResource.new()
var _robot_rsc: RobotResource = RobotResource.new()

var _is_on_orb: bool = false
var _is_on_pad: bool = false
var _modifier_used: bool = false
var _modifier_effect: Variant
var _old_x_position: float
var _position_verified: bool = false
var _gravity_force_multiplier: Enums.GRAVITY_FORCE = Enums.GRAVITY_FORCE.NORMAL

var _can_action: bool = true
var _action_pressed: bool
var _action_clicked: bool
var _action_released: bool
var _active_rsc: PlayerBaseResource
var _wave_trial: WaveTrial
var _mode: Enums.PLAYER_MODE = Enums.PLAYER_MODE.SQUARE
var _player_resources: Dictionary[Enums.PLAYER_MODE, PlayerBaseResource]

const _WAVE_TRIAL_SCENE_PATH: String = "res://Player/Scenes/wave_trial.tscn"
const _WAVE_TRIAL_SCENE = preload(_WAVE_TRIAL_SCENE_PATH)

func _ready() -> void:
	_player_resources = {
		Enums.PLAYER_MODE.SQUARE: _square_rsc,
		Enums.PLAYER_MODE.WAVE: _wave_rsc,
		Enums.PLAYER_MODE.UFO: _ufo_rsc,
		Enums.PLAYER_MODE.BALL: _ball_rsc,
		Enums.PLAYER_MODE.SPACESHIP: _spaceship_rsc,
		Enums.PLAYER_MODE.ROBOT: _robot_rsc
	}
	global_position = spawn.global_position
	_set_active_resource()

func _physics_process(delta: float) -> void:
	_action_pressed = Input.is_action_pressed("Action")
	_action_clicked = Input.is_action_just_pressed("Action")
	_action_released = Input.is_action_just_released("Action")
	Events.emit_signal("player_pos", global_position)
	
	_reset_gravity_force_if_on_surface()
	_is_inside_player_modifier()
	_kill_on_idle()

	match _mode:
		Enums.PLAYER_MODE.SQUARE: _square_mode(delta)
		Enums.PLAYER_MODE.WAVE: _wave_mode(delta)
		Enums.PLAYER_MODE.BALL: _ball_mode(delta)
		Enums.PLAYER_MODE.UFO: _ufo_mode(delta)
		Enums.PLAYER_MODE.SPACESHIP: _spaceship_mode(delta)
		Enums.PLAYER_MODE.ROBOT: _robot_mode(delta)
	
	velocity.x = _active_rsc.speed
	move_and_slide()

func _is_inside_player_modifier() -> void:
	if (_orb_jump() or _pad_jump()) and not _modifier_used:
		if not _modifier_effect: return

		var _jump_effect = _modifier_effect.get(Enums.MODIFIERS.JUMP)
		var _gravity_effect = _modifier_effect.get(Enums.MODIFIERS.GRAVITY)
		var _gravity_force_effect = _modifier_effect.get(Enums.MODIFIERS.G_FORCE)
		var _dash_effect = _modifier_effect.get(Enums.MODIFIERS.DASH)

		if _jump_effect != null: _jump_modifiers_actions(_jump_effect)
		if _gravity_effect != null: _gravity_modifiers_actions(_gravity_effect)
		if _gravity_force_effect != null: _gravity_force_modifiers_actions(_gravity_force_effect)
		if _dash_effect != null: pass

		_modifier_used = true
		
		if _orb_jump():
			Events.emit_signal("player_use_orb")

func _set_active_resource() -> void:
	_active_rsc = _player_resources.get(_mode)

#region DieFunctions
func _kill_on_idle() -> void:
	if not _position_verified:
		_old_x_position = position.x
		_position_verified = true
	else:
		if position.x == _old_x_position:
			_died()
		else:
			_old_x_position = 0
		_position_verified = false

func _died() -> void:
	Events.emit_signal("player_died")
	_reset_player()
#endregion

#region JumpActions
func _jump_modifiers_actions(effect: Enums.JUMPS) -> void:
	match effect:
		Enums.JUMPS.MEDIUM: _jump()
		Enums.JUMPS.SMALL: _jump(Enums.JUMPS.SMALL)
		Enums.JUMPS.HIGH: _jump(Enums.JUMPS.HIGH)

func _orb_jump() -> bool:
	return _action_clicked and _is_on_orb

func _pad_jump() -> bool:
	return _is_on_pad

func _jump(jump_size: Enums.JUMPS = Enums.JUMPS.MEDIUM) -> void:
	match jump_size:
		Enums.JUMPS.SMALL: velocity.y = (_active_rsc.jump_height * _gravity_dir) / 1.5
		Enums.JUMPS.MEDIUM: velocity.y = _active_rsc.jump_height * _gravity_dir
		Enums.JUMPS.HIGH: velocity.y = _active_rsc.jump_height * _gravity_dir * 2
#endregion

#region ModeControl
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
#endregion

#region Gravity
func _apply_gravity(delta: float) -> void:
	velocity.y += _active_rsc.gravity * _gravity_dir * delta * _gravity_force_multiplier

func _invert_gravity() -> void:
	_gravity_dir *= -1

func _set_gravity_dir(new_dir: Enums.GRAVITY_DIR) -> void:
	_gravity_dir = new_dir

func _reset_gravity_force_if_on_surface() -> void:
	if is_on_floor() or is_on_ceiling(): _set_gravity_force()
	
func _set_gravity_force(force: Enums.GRAVITY_FORCE = Enums.GRAVITY_FORCE.NORMAL) -> void:
	_gravity_force_multiplier = force

func _gravity_modifiers_actions(effect: Enums.GRAVITY_DIR) -> void:
	match effect:
		Enums.GRAVITY_DIR.FLIP: _invert_gravity()
		Enums.GRAVITY_DIR.INVERTED: _set_gravity_dir(Enums.GRAVITY_DIR.INVERTED)
		Enums.GRAVITY_DIR.NORMAL: _set_gravity_dir(Enums.GRAVITY_DIR.NORMAL)

func _gravity_force_modifiers_actions(effect: Enums.GRAVITY_FORCE) -> void:
	match effect:
		Enums.GRAVITY_FORCE.NORMAL: _set_gravity_force()
		Enums.GRAVITY_FORCE.STRONG: _set_gravity_force(Enums.GRAVITY_FORCE.STRONG)
#endregion

#region GameplayModes

#region Square
func _square_mode(delta: float) -> void:
	if not is_on_floor() or not is_on_ceiling():
		_apply_gravity(delta)

	if (
	_action_pressed and is_on_floor() or \
	_action_pressed and is_on_ceiling()
	):
		_jump()
		_play_jump_anim()
	
	if _orb_jump():
		_play_jump_anim()

func _play_jump_anim() -> void:
	animation_player.play("rotate")

#endregion

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
	var _local_pos = _wave_trial.to_local(global_position)
	_wave_trial.add_point(_local_pos)

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

#region Spaceship
func _spaceship_mode(delta: float) -> void:
	if _action_pressed and _can_action:
		velocity.y += _active_rsc.vertical_vel * _gravity_dir
	else:
		_apply_gravity(delta)
#endregion

#region Robot
func _robot_mode(delta: float) -> void:
	if is_on_floor() or is_on_ceiling():
		_active_rsc.can_fly = true
	if not is_on_floor() and _action_released:
		_active_rsc.can_fly = false

	if _action_pressed and _active_rsc.can_fly:
		velocity.y += _active_rsc.boost_force
		robot_nodes.start_fly_timer()
	else:
		_apply_gravity(delta)

func _on_robot_fly_timer_timeout() -> void:
	_active_rsc.can_fly = false

func _on_enter_robot_mode() -> void:
	pass

#endregion
#endregion

#region Reset
func _reset_player() -> void:
	# Position
	global_position = spawn.global_position

	# Gravity
	_gravity_dir = Enums.GRAVITY_DIR.NORMAL
	
	# Modes
	change_mode(Enums.PLAYER_MODE.SQUARE)
	velocity = Vector2.ZERO
	robot_nodes.reset_fly_timer()
	if player_elements.has_node(_WAVE_TRIAL_SCENE_PATH): 
		player_elements.remove_child(_wave_trial)
#endregion

#region Interations
func _on_hurt_box_body_entered(_body: Node2D) -> void:
	_died()

func _on_modifier_sensor_area_entered(area: Area2D) -> void:
	if not area is PlayerModifier: return
	if area is Orb: _is_on_orb = true
	if area is Pad: _is_on_pad = true
	_can_action = false
	_modifier_effect = area.get_effect()

func _on_modifier_sensor_area_exited(area: Area2D) -> void:
	if not area is PlayerModifier: return
	_is_on_orb = false
	_is_on_pad = false
	_can_action = true
	_modifier_used = false
#endregion
