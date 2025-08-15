extends CharacterBody2D
class_name Player

@onready var hurt_box: Area2D = %HurtBox
@onready var wave_trial: Line2D = %WaveTrial
@onready var spawn: Marker2D = %PlayerSpawn
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var _action_pressed: bool
var _mode: Enums.PLAYER_MODE = Enums.PLAYER_MODE.SQUARE
var _spaceship_vertical_vel: float = -15.0
var _player_base_rsc: PlayerBaseResource = preload("res://Player/Resources/player_base_rsc.tres")
var _square_rsc: SquareResource = preload("res://Player/Resources/square_rsc.tres")
var wave_rsc: WaveResource = preload("res://Player/Resources/wave_rsc.tres")
var ufo_rsc: UfoResource = preload("res://Player/Resources/ufo_rsc.tres")

func _ready() -> void:
	global_position = spawn.global_position

func _physics_process(_delta: float) -> void:
	_action_pressed = Input.is_action_pressed("Action")
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
		_apply_gravity()

	if _action_pressed and is_on_floor() or _action_pressed and is_on_ceiling():
		_jump()
		animation_player.play("rotate")

func _jump() -> void:
	velocity.y = _square_rsc.jump_height * _player_base_rsc.gravity_dir

func change_mode(new_mode: Enums.PLAYER_MODE) -> void:
	_mode = new_mode

func _apply_gravity() -> void:
	velocity.y += _player_base_rsc.gravity * _player_base_rsc.gravity_dir

func invert_gravity() -> void:
	if _player_base_rsc.gravity_dir == Enums.GRAVITY_DIR.NORMAL:
		_player_base_rsc.gravity_dir = Enums.GRAVITY_DIR.INVERTED
	else:
		_player_base_rsc.gravity_dir = Enums.GRAVITY_DIR.NORMAL

func _on_hurt_box_body_entered(body: Node2D) -> void:
	Events.emit_signal("player_died")
	_reset_player()

#region Wave
func _wave_mode() -> void:
	velocity.y = wave_rsc.vertical_speed * wave_rsc.direction
	if _action_pressed:
		_change_wave_direction(Enums.WAVE_DIR.UP)
		_add_trial_point()
	else:
		_change_wave_direction(Enums.WAVE_DIR.DOWN)
		_add_trial_point()

func _add_trial_point() -> void:
	wave_trial.add_point(global_position)

func _change_wave_direction(new_dir: Enums.WAVE_DIR) -> void:
	wave_rsc.direction = new_dir
#endregion

#region Ball
func _ball_mode() -> void:
	if _action_pressed and is_on_ceiling(): invert_gravity()
	elif _action_pressed and is_on_floor(): invert_gravity()
	_apply_gravity()
#endregion

#region Ufo
func _ufo_mode() -> void:
	_apply_gravity()
	if Input.is_action_just_pressed("Action"):
		velocity.y = ufo_rsc.jump_height
#endregion

#region Reset
func _reset_player() -> void:
	global_position = spawn.global_position
	_mode = Enums.PLAYER_MODE.SQUARE
#endregion

#region Spaceship
func _spaceship_mode() -> void:
	if not _action_pressed:
		_apply_gravity()
	else:
		velocity.y += _spaceship_vertical_vel
#endregion
