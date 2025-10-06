extends Control
class_name MainMenu

@onready var options_btn: Button = $Buttons/GridContainer/OptionsBtn
@onready var customize_btn: Button = $Buttons/GridContainer/CustomizeBtn
@onready var customize_screen: Control = $CustomizeScreen
@onready var play_btn: Button = %PlayBtn

func _ready() -> void:
	#options_btn.connect("pressed", _on_options_btn_pressed)
	customize_btn.connect("pressed", _on_customize_btn_pressed)
	play_btn.connect("pressed", _on_play_btn_pressed)

func _on_customize_btn_pressed() -> void:
	customize_screen.visible = true

func _on_play_btn_pressed() -> void:
	Events.emit_signal("play_btn_pressed")
	get_tree().change_scene_to_file("res://Main/GameManager/Scenes/game.tscn")
