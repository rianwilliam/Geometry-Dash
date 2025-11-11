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
@onready var level_music: AudioStreamPlayer = $LevelMusic ## AudioStream responsible for playing the level music
@onready var background_texture: TextureRect = %BackgroundTexture ## Level background
@onready var camera_triggers: Node2D = $CameraTriggers

var attemp_counter: int = 1 ## Death counter
var attemp_text: String = "Attempt" ## Text displayed in [member die_counter]
var player_pos: Vector2 ## Stores the player's position to update [member camera_2d]
var default_background_color: GradientTexture2D

func _ready() -> void:
	default_background_color = background_texture.texture
	_connect_events()
	_refresh_attemp_text()
	pause_menu.visible = false

func _connect_events() -> void:
	Events.connect("player_died", _on_player_die)
	Events.connect("player_pos", _on_player_pos)
	Events.connect("resume_btn_pressed", _on_resume_btn_pressed)
	Events.connect("quit_btn_pressed", _on_quit_btn_pressed)
	Events.connect("level_color_changed", _on_level_color_changed)

#func _set_music_volume() -> void:
	#audio_stream_player.volume_db = AudioController.get_main_volume()

## Checks if the pause button was pressed and continuously moves
## the [member camera_2d] to the current player position
func _process(_delta: float) -> void:
	_camera_logic()
	if Input.is_action_just_pressed("Pause"):
		_pause_game()

func _camera_logic() -> void:
	var target: Vector2 = player_pos.round()
	target.x = clamp(target.x,camera_triggers.start_position().x, camera_triggers.stop_position().x)
	camera_2d.position = Vector2(target.x, player_pos.y)

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
	level_music.stop()

## Updates the [member die_counter] text with the current attempt number
func _refresh_attemp_text() -> void:
	die_counter.text = attemp_text + " " + str(attemp_counter)

## Receives the player's position
func _on_player_pos(pos: Vector2) -> void:
	player_pos = pos

## When the [LevelColorChanger] is activated, it emits a [code]signal[/code] that carries
## the [param new_color] and [param transition_time]; this function creates a tween that changes the background color
func _on_level_color_changed(new_color: Color, transition_time: float) -> void:
	var tween: Tween = background_texture.create_tween()
	tween.tween_property(background_texture, "modulate", new_color * 0.9, transition_time)
