extends CharacterBody2D
class_name Player

## Player
##
## Player

#TODO Adicionar a docstring de função pertencente a [ModeName] para melhor identificação da função
#TODO Colocar em cada emissão de evento quem o recebe

@onready var hurt_box: Area2D = %HurtBox
@onready var spawn: Marker2D = %PlayerSpawn
@onready var player_elements: Node2D = %PlayerElements
@onready var wave_lines: Node2D = %WaveLines
@onready var square_mode: SquareMode = $SquareMode
@onready var wave_mode: WaveMode = $WaveMode
@onready var ufo_mode: ModeBase = $UfoMode
@onready var ball_mode: BallMode = $BallMode
@onready var robot_mode: RobotMode = $RobotMode
@onready var spaceship_mode: SpaceshipMode = $SpaceshipMode

# Enums
@export var _gravity_dir: Enums.GRAVITY_DIR = Enums.GRAVITY_DIR.NORMAL
@export var _initial_mode: Enums.PLAYER_MODE
var _gravity_force_multiplier: Enums.GRAVITY_FORCE = Enums.GRAVITY_FORCE.NORMAL
var _player_direction: Enums.PLAYER_DIRECTION = Enums.PLAYER_DIRECTION.RIGHT

# Resources
var _square_rsc: SquareResource = SquareResource.new()
var _wave_rsc: WaveResource = WaveResource.new()
var _ufo_rsc: UfoResource = UfoResource.new()
var _ball_rsc: BallResource = BallResource.new()
var _spaceship_rsc: SpaceshipResource = SpaceshipResource.new()
var _robot_rsc: RobotResource = RobotResource.new()
var _player_resources: Dictionary[Enums.PLAYER_MODE, PlayerBaseResource]
var _active_rsc: PlayerBaseResource

# Modifiers
var _is_on_orb: bool = false
var _is_on_pad: bool = false
var _modifier_used: bool = false
var _modifier_effect: Variant # Can be ENUM.(JUMP/GRAVITY/DASH)

# Position Verifier
var _old_x_position: int
var _position_verified: bool = false

# Mode
var _mode: Enums.PLAYER_MODE
var _active_mode: ModeBase

# Action
var _can_action: bool = true ## Verifica se o jogador pode executar uma ação
var _action_pressed: bool
var _action_clicked: bool
var _action_released: bool

var _wave_trial: WaveTrial
const _WAVE_TRIAL_SCENE_PATH: String = "res://Player/Modes/WaveMode/Scenes/wave_trial.tscn"
const _WAVE_TRIAL_SCENE: PackedScene = preload(_WAVE_TRIAL_SCENE_PATH)

#region Ready Func
func _ready() -> void:
	_connect_signals()
	_setup_player_resources()
	change_mode(_initial_mode)
#endregion

func _physics_process(delta: float) -> void:
	_emit_player_regular_signals()
	_refresh_input_states()
	_reset_gravity_force_if_on_surface()
	_is_inside_player_modifier()
	_is_player_in_action()
	_kill_on_idle()

	match _mode:
		Enums.PLAYER_MODE.SQUARE: _square_mode(delta)
		Enums.PLAYER_MODE.WAVE: _wave_mode(delta)
		Enums.PLAYER_MODE.BALL: _ball_mode(delta)
		Enums.PLAYER_MODE.UFO: _ufo_mode(delta)
		Enums.PLAYER_MODE.SPACESHIP: _spaceship_mode(delta)
		Enums.PLAYER_MODE.ROBOT: _robot_mode(delta)

	velocity.x = _active_rsc.speed * _player_direction
	move_and_slide()

#region Actions

## Atualiza o estado do input do jogador a cada frame
func _refresh_input_states() -> void:
	_action_pressed = Input.is_action_pressed("Action")
	_action_clicked = Input.is_action_just_pressed("Action")
	_action_released = Input.is_action_just_released("Action")

## Verifica se o jogador está executando uma ação ou está dentro de um 
## [Orb] ou [Pad]
func _is_player_in_action() -> void:
	if _action_clicked or _action_pressed or _orb_jump() or _pad_jump():
		Events.emit_signal("player_is_in_action", true)
	else:
		Events.emit_signal("player_is_in_action", false)
#endregion

func _set_spawn_position() -> void:
	global_position = spawn.global_position

#region Signals
func _emit_player_regular_signals() -> void:
	Events.emit_signal("player_pos", global_position)
	Events.emit_signal("player_in_floor", is_on_floor())
	Events.emit_signal("player_in_ceiling", is_on_ceiling())

func _connect_signals() -> void:
	robot_mode.connect("robot_fly_timeout", _on_robot_fly_timeout)
#endregion

#region ModifiersActions

## Verifica se o jogador pode utilizar [PlayerModifier] [br]
## caso verdadeiro, executa [method _identify_effect]
func _is_inside_player_modifier() -> void:
	if _can_use_modifier():
		_identify_effect()
		_modifier_used = true
		if _orb_jump():
			Events.emit_signal("player_use_orb")
#endregion

## Executa as funções que verificam quais efeitos estão dentro de [member _modifier_effect]
func _identify_effect() -> void:
	_is_jump_effect()
	_is_gravity_effect()
	_is_gravity_force_effect()

## Verifica se o [member _modifier effect] possui o modificador [enum MODIFIERS.JUMP]
func _is_jump_effect() -> void:
	var _effect: Variant = _modifier_effect.get(Enums.MODIFIERS.JUMP)
	if _effect != null: _jump_modifiers_actions(_effect)

## Verifica se o [member _modifier_effect] possui o modificador [enum MODIFIERS.GRAVITY]
func _is_gravity_effect() -> void:
	var _effect: Variant = _modifier_effect.get(Enums.MODIFIERS.GRAVITY)
	if _effect != null: _gravity_modifiers_actions(_effect)

## Verifica se o [member _modifier effect] possui o modificador [enum MODIFIERS.G_FORCE]
func _is_gravity_force_effect() -> void:
	var _effect: Variant = _modifier_effect.get(Enums.MODIFIERS.G_FORCE)
	if _effect != null: _gravity_force_modifiers_actions(_effect)

## Verifica se o jogador está dentro das condições para utilizar um [PlayerModifier]
func _can_use_modifier() -> bool:
	return (_orb_jump() or _pad_jump()) and not _modifier_used

#region Resources

## Muda o [member _active_rsc] do jogador com base no [member _mode] [br]
## Essa função é executa no [method _on_mode_entered]
func _set_active_resource() -> void:
	_active_rsc = _player_resources.get(_mode)

## Atribui o recurso de cada modo do jogador [br]
## Cada chave é um elemento de [enum PLAYER_MODE]
func _setup_player_resources() -> void:
	_player_resources = {
		Enums.PLAYER_MODE.SQUARE: _square_rsc,
		Enums.PLAYER_MODE.WAVE: _wave_rsc,
		Enums.PLAYER_MODE.UFO: _ufo_rsc,
		Enums.PLAYER_MODE.BALL: _ball_rsc,
		Enums.PLAYER_MODE.SPACESHIP: _spaceship_rsc,
		Enums.PLAYER_MODE.ROBOT: _robot_rsc
	}
#endregion

#region DirectionSetter
func set_direction(new_dir: Enums.PLAYER_DIRECTION = Enums.PLAYER_DIRECTION.RIGHT) -> void:
	_player_direction = new_dir
#endregion

#region JumpActions

## Executa a função [method _jump] passando [param effect]
func _jump_modifiers_actions(effect: Enums.JUMPS) -> void:
	_jump(effect)

func _orb_jump() -> bool:
	return _action_clicked and _is_on_orb

func _pad_jump() -> bool:
	return _is_on_pad

## Executa o pulo conforme o valor passado em [param jump_size]
func _jump(jump_size: Enums.JUMPS = Enums.JUMPS.MEDIUM) -> void:
	match jump_size:
		Enums.JUMPS.SMALL: velocity.y = (_active_rsc.jump_height * _gravity_dir) / 1.8
		Enums.JUMPS.MEDIUM: velocity.y = _active_rsc.jump_height * _gravity_dir
		Enums.JUMPS.MEDIUM_HIGH: velocity.y = _active_rsc.jump_height * _gravity_dir * 1.5
		Enums.JUMPS.HIGH: velocity.y = _active_rsc.jump_height * _gravity_dir * 3
#endregion

#region ModeControl

## Altera o modo do jogador
## [br] - param: [param Enums.PLAYER_MODE] [br]
## [member Orbs] disparam essa função quando o jogador entra
func change_mode(new_mode: Enums.PLAYER_MODE) -> void:
	_mode = new_mode
	_on_mode_entered()

## Executa todas as funções necessárias ao ocorrer a troca do [member _mode]
func _on_mode_entered() -> void:
	_disconnect_modes_events()
	_reset_modes_visibility()
	_set_active_resource()
	_reset_transform()
	_set_active_mode()
	_set_mode_visual(_active_mode, true)
	_set_mode_collision(_active_mode)

## Verifica o valor de [member _mode] e determina o [member _active_mode] com base no resultado [br]
## Também executa o [color=light_blue]_on_enter_(mode_name)[/color] que serve para executar funções 
## necessárias ao entrar em um modo 
func _set_active_mode() -> void:
	match _mode:
		Enums.PLAYER_MODE.SQUARE: 
			_active_mode = square_mode
			_on_enter_square_mode()
		Enums.PLAYER_MODE.WAVE:
			_active_mode = wave_mode
			_on_enter_wave_mode()
		Enums.PLAYER_MODE.BALL:
			_active_mode = ball_mode
			_on_enter_ball_mode()
		Enums.PLAYER_MODE.UFO:
			_active_mode = ufo_mode
			_on_enter_ufo_mode()
		Enums.PLAYER_MODE.ROBOT:
			_active_mode = robot_mode
			_on_enter_robot_mode()
		Enums.PLAYER_MODE.SPACESHIP: 
			_active_mode = spaceship_mode
			_on_enter_spaceship_mode()

## Atribui o valor de [member ModeBase.visible] através do parâmetro [param be_visible]
func _set_mode_visual(node: ModeBase, be_visible: bool) -> void:
	node.visible = be_visible

## Obtém os nós [ModeBase] e aplica o valor [code]false[/code] ao atributo [member ModeBase.visible]
func _reset_modes_visibility() -> void:
	for item: Node2D in get_children():
		if item is ModeBase:
			_set_mode_visual(item, false)

## Emite o sinal para que [PlayerCollision] [br]
## obtenha [member CollisionShape2D.shape] do [param mode] e aplica a [member PlayerCollision.shape]
func _set_mode_collision(mode: ModeBase) -> void:
	Events.emit_signal("set_player_collision_shape", mode.get_collision_shape())

func _disconnect_modes_events() -> void:
	pass
#endregion

#region Gravity
func _apply_gravity(delta: float) -> void:
	velocity.y += _active_rsc.gravity * _gravity_dir * delta * _gravity_force_multiplier

func _invert_gravity() -> void:
	if _gravity_dir == Enums.GRAVITY_DIR.NORMAL:
		_gravity_dir = Enums.GRAVITY_DIR.INVERTED
	else:
		_gravity_dir = Enums.GRAVITY_DIR.NORMAL
	_update_scale_y_by_gravity()

func _set_gravity_dir(new_dir: Enums.GRAVITY_DIR) -> void:
	_gravity_dir = new_dir
	_update_scale_y_by_gravity()

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

func _on_enter_square_mode() -> void:
	pass

func _square_mode(delta: float) -> void:
	if not is_on_floor() or not is_on_ceiling():
		_apply_gravity(delta)

	if _can_square_jump():
		_jump()

func _can_square_jump() -> bool:
	return _action_pressed and is_on_floor() or \
	_action_pressed and is_on_ceiling()
#endregion

#region Wave
func _on_enter_wave_mode() -> void:
	_instanciate_wave_trial()

func _wave_mode(_delta: float) -> void:
	velocity.y = _active_rsc.vertical_speed * _active_rsc.direction * _gravity_dir
	if _action_pressed:
		_change_wave_direction(Enums.WAVE_DIR.UP)
		_add_trial_point()
	else:
		_change_wave_direction(Enums.WAVE_DIR.DOWN)
		_add_trial_point()

## Instancia a [WaveTrial] que é uma [Line2D] que acompanha o movimento do [WaveMode] [br]
## A linha instanciada é adicionada dentro do nó [member _wave_trial]
func _instanciate_wave_trial() -> void:
	_wave_trial = _WAVE_TRIAL_SCENE.instantiate()
	_wave_trial.global_position = Vector2.ZERO
	wave_lines.add_child(_wave_trial)
	_add_trial_point()

## Executa [method WaveTrial.add_point] e o insere na posição refente a [member global_position]
func _add_trial_point() -> void:
	if not _wave_trial: return
	var _local_pos = _wave_trial.to_local(global_position)
	_wave_trial.add_point(_local_pos)

func _change_wave_direction(new_dir: Enums.WAVE_DIR) -> void:
	_active_rsc.direction = new_dir
	_apply_wave_rotation_by_state()

## Rotaciona o jogador conforme o estado do [WaveMode]
func _apply_wave_rotation_by_state() -> void:
	if is_on_floor() or is_on_ceiling(): rotation_degrees = _active_rsc.IN_SURFACE_ROTATE_DEG * _gravity_dir
	elif _action_pressed: rotation_degrees = _active_rsc.ACTION_ROTATE_DEG * _gravity_dir
	else: rotation_degrees = _active_rsc.NOT_ACTION_ROTATE_DEG * _gravity_dir

#endregion

#region Ball

func _on_enter_ball_mode() -> void:
	pass

func _ball_mode(delta: float) -> void:
	_apply_gravity(delta)
	if not _can_action: return
	if _action_clicked and is_on_ceiling() : _invert_gravity()
	elif _action_clicked and is_on_floor(): _invert_gravity()
#endregion

#region Ufo

func _on_enter_ufo_mode() -> void:
	pass

func _ufo_mode(delta: float) -> void:
	_apply_gravity(delta)
	if _action_clicked:
		velocity.y = _active_rsc.impulse_height * _gravity_dir
#endregion

#region Spaceship

func _on_enter_spaceship_mode() -> void:
	pass

func _spaceship_mode(delta: float) -> void:
	if _action_pressed and _can_action:
		velocity.y += _active_rsc.vertical_vel * _gravity_dir
	else:
		_apply_gravity(delta)
#endregion

#region Robot
func _on_enter_robot_mode() -> void:
	pass

func _robot_mode(delta: float) -> void:
	if (is_on_floor() and _gravity_dir == Enums.GRAVITY_DIR.NORMAL) or \
	(is_on_ceiling() and _gravity_dir == Enums.GRAVITY_DIR.INVERTED):
		_active_rsc.can_fly = true
	if not is_on_floor() and _action_released:
		_active_rsc.can_fly = false

	if _action_pressed and _active_rsc.can_fly:
		velocity.y += _active_rsc.boost_force * _gravity_dir
		robot_mode.start_fly_timer()
	else:
		_apply_gravity(delta)

func _on_robot_fly_timeout() -> void:
	_active_rsc.can_fly = false

#endregion
#endregion

#region Transform
func _update_scale_y_by_gravity() -> void:
	scale.y = Enums.SCALE_DIR.NORMAL \
		if _gravity_dir == Enums.GRAVITY_DIR.NORMAL \
		else Enums.SCALE_DIR.INVERTED
#endregion

#region Reset
func _reset_player() -> void:
	# Transforms
	global_position = spawn.global_position
	_reset_transform()

	# Gravity
	_gravity_dir = Enums.GRAVITY_DIR.NORMAL
	
	# Velocity
	velocity = Vector2.ZERO

	# Modes
	change_mode(_initial_mode)
	_reset_robot_fly_mode()
	_erase_wave_lines()

func _reset_transform() -> void:
	rotation_degrees = 0
	_update_scale_y_by_gravity()
	scale.x = Enums.SCALE_DIR.NORMAL

func _reset_robot_fly_mode() -> void:
	robot_mode.reset_fly_timer()

func _erase_wave_lines() -> void:
	if wave_lines.get_children():
		for lines in wave_lines.get_children():
			lines.queue_free()
#endregion

#region DieFunctions
func _kill_on_idle() -> void:
	if not _position_verified:
		_old_x_position = int(position.x)
		_position_verified = true
	else:
		if int(position.x) == _old_x_position:
			_died()
		else:
			_old_x_position = 0
		_position_verified = false

func _died() -> void:
	Events.emit_signal("player_died")
	_reset_player()
#endregion

#region Interations
func _on_hurt_box_body_entered(_body: Node2D) -> void:
	_died()

func _on_modifier_sensor_area_entered(area: Area2D) -> void:
	if not area is PlayerModifier: return
	_identify_area_type(area)
	_get_modifier_effect(area)
	_can_action = false

func _get_modifier_effect(entered_area: Area2D) -> void:
	_modifier_effect = entered_area.get_effect()

func _identify_area_type(entered_area: Area2D) -> void:
	if entered_area is Orb: _is_on_orb = true
	elif entered_area is Pad: _is_on_pad = true

func _on_modifier_sensor_area_exited(area: Area2D) -> void:
	if not area is PlayerModifier: return
	_reset_modifier_variables()

func _reset_modifier_variables() -> void:
	_is_on_orb = false
	_is_on_pad = false
	_can_action = true
	_modifier_used = false
#endregion
