extends Node
class_name PlayerVisuals

#TODO Criar funcao on skin change que dispara toda vez que o jogador altera a skin no menu
# O menu de alteracao de skin vai passar o modo alterado e o novo id da skin

@onready var player_animations: AnimationPlayer = $PlayerAnimations 
@onready var square_visual: PlayerVisualBase = $SquareVisual
@onready var wave_visual: PlayerVisualBase = $WaveVisual

const JUMP_ANIM: String = "jump"
var _player_active_mode: Enums.PLAYER_MODE
var _active_skin: PlayerVisualBase

func _ready() -> void:
	Events.connect("send_player_mode", _on_player_send_mode)
	_active_skin = square_visual

func play_jump_anim() -> void:
	player_animations.play(JUMP_ANIM)

func set_skins() -> void:
	#TODO
	# O menu vai passar esta estrutura como parametro
	# Ou transformar a estrutura em um objeto
	# Possivel estrutura do dict
	# Skins = {
	# 	Enum.SQUARE = SKIN_ID
	pass

func _update_skin() -> void:
	_active_skin.visible = false
	match _player_active_mode:
		Enums.PLAYER_MODE.SQUARE: _apply_visual(square_visual)
		Enums.PLAYER_MODE.WAVE: _apply_visual(wave_visual)
		Enums.PLAYER_MODE.BALL: pass
		Enums.PLAYER_MODE.UFO: pass
		Enums.PLAYER_MODE.ROBOT: pass
		Enums.PLAYER_MODE.SPACESHIP: pass
	_active_skin.visible = true

func _apply_visual(skin: PlayerVisualBase) -> void:
	_active_skin = skin

func _on_player_send_mode(mode: Enums.PLAYER_MODE) -> void:
	_player_active_mode = mode
	_update_skin()
