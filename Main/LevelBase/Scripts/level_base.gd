extends Node2D
class_name LevelManager

## Manages level resources
##
## This class is responsible for controlling the [Camera2D],
## handling the game's paused state, and resetting the player's position
## when they die.

@onready var die_counter: Label = %DieCounter ## [Label] that displays the number of attempts
@onready var camera_2d: Camera2D = %Camera ## Camera that follows the player's position
@onready var pause_menu: PauseMenu = %PauseMenu ## Pause menu
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var attemp_counter: int = 1 ## Death counter
var attemp_text: String = "Attempt" ## Text displayed in [member die_counter]
var player_pos: Vector2 ## Stores the player's position to update [member camera_2d]

func _ready() -> void:
	Events.connect("player_died", _on_player_die)
	Events.connect("player_pos", _on_player_pos)
	Events.connect("resume_btn_pressed", _on_resume_btn_pressed)
	Events.connect("quit_btn_pressed", _on_quit_btn_pressed)
	_refresh_attemp_text()
	pause_menu.visible = false

func _set_music_volume() -> void:
	audio_stream_player.volume_db = AudioController.get_main_volume()

## Checks if the pause button was pressed and continuously moves
## the [member camera_2d] to the current player position
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		_pause_game()
	camera_2d.position = player_pos.round()

## Pauses the game and displays the [PauseMenu]
func _pause_game() -> void:
	get_tree().paused = true
	pause_menu.show_pause()

## Resumes the game and hides the [PauseMenu]
func _resume_game() -> void:
	get_tree().paused = false
	pause_menu.hide_pause()

## Called when the resume button is pressed
func _on_resume_btn_pressed() -> void:
	_resume_game()

## Returns to the [MainMenu] when receiving the [signal]
func _on_quit_btn_pressed() -> void:
	SceneChanger.change_scene(Enums.SCENES.MAIN_MENU)

## Adds 1 to the [member attemp_counter] and updates the [Label]
## using the [method _refresh_attemp_text]
func _on_player_die() -> void:
	attemp_counter += 1
	_refresh_attemp_text()

## Updates the [member die_counter] text with the current attempt number
func _refresh_attemp_text() -> void:
	die_counter.text = attemp_text + " " + str(attemp_counter)

## Receives the player's position
func _on_player_pos(pos: Vector2) -> void:
	player_pos = pos
