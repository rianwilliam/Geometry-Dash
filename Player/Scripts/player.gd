extends CharacterBody2D
class_name Player

#TODO Fazer o trial ser criado quando o jogador entrar no wave mode
#TODO Provavelmente colocar um evento que determine que vai criar / destruir o trial

@onready var hurt_box: Area2D = %HurtBox
@onready var wave_trial: Line2D = %WaveTrial
@onready var spawn: Marker2D = %PlayerSpawn
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var _gravity_dir: Enums.GRAVITY_DIR = Enums.GRAVITY_DIR.NORMAL

var _action_pressed: bool
var _action_clicked: bool
var _mode: Enums.PLAYER_MODE = Enums.PLAYER_MODE.SQUARE
var _spaceship_vertical_vel: float = -15.0
var is_on_orb: bool = false
var _player_base_rsc: PlayerBaseResource = preload("res://Player/Resources/player_base_rsc.tres")
var _square_rsc: SquareResource = preload("res://Player/Resources/Square/square_rsc.tres")
var _wave_rsc: WaveResource = preload("res://Player/Resources/Wave/wave_rsc.tres")
var _ufo_rsc: UfoResource = preload("res://Player/Resources/Ufo/ufo_rsc.tres")
var _ball_rsc: BallResource = preload("res://Player/Resources/Ball/ball_rsc.tres")
var _spaceship_rsc: SpaceshipResource = preload("res://Player/Resources/SpaceShip/spaceship_rsc.tres")

func _ready() -> void:
	global_position = spawn.global_position

func _physics_process(_delta: float) -> void:
	_action_pressed = Input.is_action_pressed("Action")
	_action_clicked = Input.is_action_just_pressed("Action")
	velocity.x = _player_base_rsc.speed
	
	match _mode:
		Enums.PLAYER_MODE.SQUARE: _square_mode()
		Enums.PLAYER_MODE.WAVE: _wave_mode()
		Enums.PLAYER_MODE.BALL: _ball_mode()
		Enums.PLAYER_MODE.UFO: _ufo_mode()
		Enums.PLAYER_MODE.SPACESHIP: _spaceship_mode()

	move_and_slide()

func _square_mode() -> void:
	if not is_on_floor() or not is_on_ceiling():
		_apply_gravity(_square_rsc)

	if (_action_pressed and is_on_floor()) or \
		(_action_pressed and is_on_ceiling()) or \
		(_action_clicked and is_on_orb):
		jump()

func jump() -> void:
	velocity.y = _square_rsc.jump_height * _gravity_dir
	animation_player.play("rotate")

func change_mode(new_mode: Enums.PLAYER_MODE) -> void:
	_mode = new_mode

func _apply_gravity(rsc: PlayerBaseResource) -> void:
	velocity.y += rsc.gravity * _gravity_dir

func invert_gravity() -> void:
	if _gravity_dir == Enums.GRAVITY_DIR.NORMAL:
		_gravity_dir = Enums.GRAVITY_DIR.INVERTED
	else:
		_gravity_dir = Enums.GRAVITY_DIR.NORMAL

func set_gravity(new_dir: Enums.GRAVITY_DIR) -> void:
	_gravity_dir = new_dir

func _on_hurt_box_body_entered(body: Node2D) -> void:
	Events.emit_signal("player_died")
	_reset_player()

#region Wave
func _wave_mode() -> void:
	velocity.y = _wave_rsc.vertical_speed * _wave_rsc.direction * _gravity_dir
	if _action_pressed:
		_change_wave_direction(Enums.WAVE_DIR.UP)
		_add_trial_point()
	else:
		_change_wave_direction(Enums.WAVE_DIR.DOWN)
		_add_trial_point()

func _add_trial_point() -> void:
	wave_trial.add_point(global_position)

func _change_wave_direction(new_dir: Enums.WAVE_DIR) -> void:
	_wave_rsc.direction = new_dir
#endregion

#region Ball
func _ball_mode() -> void:
	if _action_pressed and is_on_ceiling(): invert_gravity()
	elif _action_pressed and is_on_floor(): invert_gravity()
	_apply_gravity(_ball_rsc)
#endregion

#region Ufo
func _ufo_mode() -> void:
	_apply_gravity(_ufo_rsc)
	if Input.is_action_just_pressed("Action"):
		velocity.y = _ufo_rsc.jump_height * _gravity_dir
#endregion

#region Reset
func _reset_player() -> void:
	global_position = spawn.global_position
	_mode = Enums.PLAYER_MODE.SQUARE
#endregion

#region Spaceship
func _spaceship_mode() -> void:
	if not _action_pressed:
		_apply_gravity(_spaceship_rsc)
	else:
		velocity.y += _spaceship_vertical_vel * _gravity_dir
#endregion
