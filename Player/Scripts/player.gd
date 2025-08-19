extends CharacterBody2D
class_name Player

#TODO Criar as variavéis de rsc para usar o @export
#TODO Colocar uma opção have_gravity: bool no player base resource e aplicar ela no menu lateral para cada modo 

@onready var hurt_box: Area2D = %HurtBox
@onready var spawn: Marker2D = %PlayerSpawn
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player_elements: Node2D = %PlayerElements
@export var _gravity_dir: Enums.GRAVITY_DIR = Enums.GRAVITY_DIR.NORMAL

var is_on_orb: bool = false
var _action_pressed: bool
var _action_clicked: bool
var _can_action: bool = true
var _mode: Enums.PLAYER_MODE = Enums.PLAYER_MODE.SQUARE
var _active_rsc: PlayerBaseResource
var _wave_trial: WaveTrial
const WAVE_TRIAL_SCENE = preload("res://Player/Scenes/wave_trial.tscn")

var player_resources: Dictionary[Enums.PLAYER_MODE, PlayerBaseResource] = {
	Enums.PLAYER_MODE.SQUARE: preload("res://Player/Resources/Square/square_rsc.tres"),
	Enums.PLAYER_MODE.WAVE: preload("res://Player/Resources/Wave/wave_rsc.tres"),
	Enums.PLAYER_MODE.UFO: preload("res://Player/Resources/Ufo/ufo_rsc.tres"),
	Enums.PLAYER_MODE.BALL: preload("res://Player/Resources/Ball/ball_rsc.tres"),
	Enums.PLAYER_MODE.SPACESHIP: preload("res://Player/Resources/SpaceShip/spaceship_rsc.tres")
}

func _ready() -> void:
	global_position = spawn.global_position
	_set_active_resource()

func _physics_process(_delta: float) -> void:
	_action_pressed = Input.is_action_pressed("Action")
	_action_clicked = Input.is_action_just_pressed("Action")
	velocity.x = _active_rsc.speed
	
	match _mode:
		Enums.PLAYER_MODE.SQUARE: _square_mode()
		Enums.PLAYER_MODE.WAVE: _wave_mode()
		Enums.PLAYER_MODE.BALL: _ball_mode()
		Enums.PLAYER_MODE.UFO: _ufo_mode()
		Enums.PLAYER_MODE.SPACESHIP: _spaceship_mode()
	
	if _action_clicked and is_on_orb:
		jump()
	
	move_and_slide()

func _set_active_resource() -> void:
	_active_rsc = player_resources.get(_mode)

#region Square
func _square_mode() -> void:
	if not is_on_floor() or not is_on_ceiling():
		_apply_gravity(_active_rsc)

	if _can_action:
		if (
		_action_pressed and is_on_floor() or \
		_action_pressed and is_on_ceiling()
		):
			jump()
			animation_player.play("rotate")
#endregion

func jump() -> void:
	velocity.y = _active_rsc.jump_height * _gravity_dir

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
func _apply_gravity(rsc: PlayerBaseResource) -> void:
	velocity.y += rsc.gravity * _gravity_dir

func invert_gravity() -> void:
	if _gravity_dir == Enums.GRAVITY_DIR.NORMAL:
		_gravity_dir = Enums.GRAVITY_DIR.INVERTED
	else:
		_gravity_dir = Enums.GRAVITY_DIR.NORMAL

func set_gravity(new_dir: Enums.GRAVITY_DIR) -> void:
	_gravity_dir = new_dir
#endregion

func _on_hurt_box_body_entered(body: Node2D) -> void:
	Events.emit_signal("player_died")
	_reset_player()

#region Wave
func _on_enter_wave_mode() -> void:
	_wave_trial = WAVE_TRIAL_SCENE.instantiate()
	_wave_trial.global_position = Vector2.ZERO
	player_elements.add_child(_wave_trial)
	_add_trial_point()

func _wave_mode() -> void:
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
func _ball_mode() -> void:
	if _can_action:
		if _action_pressed and is_on_ceiling() : invert_gravity()
		elif _action_pressed and is_on_floor(): invert_gravity()
	_apply_gravity(_active_rsc)
#endregion

#region Ufo
func _ufo_mode() -> void:
	if _action_clicked and _can_action:
		velocity.y = _active_rsc.impulse_height * _gravity_dir
	_apply_gravity(_active_rsc)
#endregion

#region Reset
func _reset_player() -> void:
	global_position = spawn.global_position
	change_mode(Enums.PLAYER_MODE.SQUARE)
#endregion

#region Spaceship
func _spaceship_mode() -> void:
	if not _action_pressed:
		_apply_gravity(_active_rsc)
	elif _can_action:
		velocity.y += _active_rsc.vertical_vel * _gravity_dir
#endregion
