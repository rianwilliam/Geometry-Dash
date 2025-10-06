extends Node
class_name PlayerColorManager

@export var mode: Enums.PLAYER_MODE
@export var body_color_picker: ColorPicker
@export var details_color_picker: ColorPicker
@export var mode_sprite: ModeBase

var _body_color: Color
var _details_color: Color

func _ready() -> void:
	assert(body_color_picker)
	assert(details_color_picker)
	body_color_picker.connect("color_changed", _on_body_color_change)
	details_color_picker.connect("color_changed", _on_details_color_change)
	Events.connect("send_custom_colors", _on_send_custom_color)

func get_mode() -> Enums.PLAYER_MODE:
	return mode

func get_body_color() -> Color:
	return _body_color

func get_details_color() -> Color:
	return _details_color

func _on_body_color_change(color: Color) -> void:
	mode_sprite.change_body_color(color)

func _on_details_color_change(color: Color) -> void:
	mode_sprite.change_details_color(color)

func _on_send_custom_color() -> void:
	PlayerSkinColors.define_skin_color(
		mode, 
		PlayerColorData.new(_body_color,_details_color)
	)
