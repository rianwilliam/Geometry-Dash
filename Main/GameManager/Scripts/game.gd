extends Node2D
class_name GameManager

@onready var die_counter: Label = %DieCounter
@onready var camera_2d: Camera2D = %Camera
@onready var pause_menu: PauseMenu = %PauseMenu

var attemp_counter: int = 1
var attemp_text: String = "Attemp"
var player_pos: Vector2

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		_pause_game()
	camera_2d.position = player_pos.round()

func _pause_game() -> void:
	get_tree().paused = true
	pause_menu.show_pause()
	
func _resume_game() -> void:
	get_tree().paused = false
	pause_menu.hide_pause()

func _ready() -> void:
	Events.connect("player_died", _on_player_die)
	Events.connect("player_pos", _on_player_pos)
	Events.connect("resume_btn_pressed", _on_resume_btn_pressed)
	Events.connect("quit_btn_pressed", _on_quit_btn_pressed)
	_refresh_attemp_text()
	pause_menu.visible = false

func _on_resume_btn_pressed() -> void:
	_resume_game()

func _on_quit_btn_pressed() -> void:
	SceneChanger.change_scene(Enums.SCENES.MAIN_MENU)

func _on_player_die() -> void:
	attemp_counter += 1
	_refresh_attemp_text()

func _refresh_attemp_text() -> void:
	die_counter.text = attemp_text + " " + str(attemp_counter)

func _on_player_pos(pos: Vector2) -> void:
	player_pos = pos
