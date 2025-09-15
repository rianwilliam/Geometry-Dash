extends Node
class_name PlayerVisuals

#TODO Criar funcao on skin change que dispara toda vez que o jogador altera a skin no menu
# O menu de alteracao de skin vai passar o modo alterado e o novo id da skin

@onready var player_animations: AnimationPlayer = $PlayerAnimations 

const JUMP_ANIM: String = "jump"
var _player_active_mode: Enums.PLAYER_MODE
var _active_skin: PlayerVisualBase

func _ready() -> void:
	Events.connect("send_player_mode", _on_player_send_mode)

func play_jump_anim() -> void:
	player_animations.play(JUMP_ANIM)

func set_skins() -> void:
	pass
	
func _update_skin() -> void:
	match _player_active_mode:
		Enums.PLAYER_MODE.SQUARE: pass
		Enums.PLAYER_MODE.WAVE: pass
		Enums.PLAYER_MODE.BALL: pass
		Enums.PLAYER_MODE.UFO: pass
		Enums.PLAYER_MODE.ROBOT: pass
		Enums.PLAYER_MODE.SPACESHIP: pass

func _on_player_send_mode(mode: Enums.PLAYER_MODE) -> void:
	_player_active_mode = mode
	_update_skin()
