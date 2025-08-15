extends CharacterBody2D
class_name Player

@onready var hurt_box: Area2D = %HurtBox
@onready var wave_trial: Line2D = %WaveTrial
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var spawn: Marker2D = %Spawn

const _SPEED: int = 170
const _VERTICAL_SPEED: float = 200.0
const _GRAVITY: float = 15.0
const _JUMP_HEIGHT: float = -250.0
var _action_pressed: bool
var _vertical_dir: int = 1
var _gravity_dir: int = 1
var _mode: Enums.PLAYER_MODE = Enums.PLAYER_MODE.SQUARE

func _ready() -> void:
	global_position = spawn.global_position

func change_mode(new_mode: Enums.PLAYER_MODE) -> void:
	_mode = new_mode

func _physics_process(delta: float) -> void:
	_action_pressed = Input.is_action_pressed("Action")
	velocity.x = _SPEED
	
	match _mode:
		Enums.PLAYER_MODE.SQUARE: square_mode()
		Enums.PLAYER_MODE.WAVE: wave_mode()
		Enums.PLAYER_MODE.BALL: ball_mode()
		Enums.PLAYER_MODE.UFO: ufo_mode()
		Enums.PLAYER_MODE.SPACESHIP: spaceship_mode()

	move_and_slide()

func square_mode() -> void:
	if not is_on_floor():
		_apply_gravity()

	if _action_pressed and is_on_floor():
		_jump()
		animation_player.play("rotate")

func _apply_gravity() -> void:
	velocity.y += _GRAVITY

func _jump() -> void:
	velocity.y = _JUMP_HEIGHT

func wave_mode() -> void:
	velocity.y = _VERTICAL_SPEED * _vertical_dir
	if _action_pressed:
		_vertical_dir = -1
		wave_trial.add_point(global_position)
	else:
		_vertical_dir = 1
		wave_trial.add_point(global_position)

func ball_mode() -> void:
	if _action_pressed and is_on_ceiling():
		_gravity_dir = 1
	if _action_pressed and is_on_floor():
		_gravity_dir = -1
	velocity.y += _GRAVITY * _gravity_dir

func ufo_mode() -> void:
	_apply_gravity()
	if Input.is_action_just_pressed("Action"):
		velocity.y = _JUMP_HEIGHT
		
func _reset_player() -> void:
	global_position = spawn.global_position
	_mode = Enums.PLAYER_MODE.SQUARE

func _on_hurt_box_body_entered(body: Node2D) -> void:
	print(body)
	Events.emit_signal("player_died")
	_reset_player()

func spaceship_mode() -> void:
	if not _action_pressed:
		_apply_gravity()
	else:
		velocity.y += -15
	
