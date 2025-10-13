extends Node
class_name ModeColorManager

## Responsible for managing and updating the color preview of the player's modes
##
## The [CustomizeMenu] contains a preview showing how each player mode will look
## with its customized colors. This class handles updating those colors in real time.

@export var mode: Enums.PLAYER_MODE ## The player mode whose color will be changed
@export var body_color_picker: ColorPicker ## [ColorPicker] that defines the body color
@export var details_color_picker: ColorPicker ## [ColorPicker] that defines the details color
@export var mode_sprite: ModeBase ## The preview sprite that will have its colors updated

var _body_color: Color ## Stores the customized body color
var _details_color: Color ## Stores the customized details color

func _ready() -> void:
	assert(body_color_picker)
	assert(details_color_picker)
	_connect_signals()
	_apply_saved_mode_colors(mode)

## When the player exits and reopens the menu, the previously chosen colors
## need to remain. This function retrieves the colors from the global
## [PlayerColorScheme] class and applies them to the [member body_color_picker],
## [member details_color_picker], and the corresponding sprite.
func _apply_saved_mode_colors(player_mode: Enums.PLAYER_MODE) -> void:
	var mode_color: PlayerColorData = PlayerColorScheme.get_mode_custom_color(player_mode)
	body_color_picker.color = mode_color.get_body_color()
	details_color_picker.color = mode_color.get_details_color()
	_change_sprite_body_color(body_color_picker.color)
	_change_sprite_details_color(details_color_picker.color)

## Connects all signals related to color picking and data saving
func _connect_signals() -> void:
	body_color_picker.connect("color_changed", _on_body_color_change)
	details_color_picker.connect("color_changed", _on_details_color_change)
	Events.connect("send_custom_colors", _on_send_custom_color)

func get_mode() -> Enums.PLAYER_MODE:
	return mode

func get_body_color() -> Color:
	return _body_color

func get_details_color() -> Color:
	return _details_color

## Changes the body color of the sprite and updates [member _body_color]
func _change_sprite_body_color(color: Color) -> void:
	mode_sprite.change_body_color(color)
	_body_color = color

## Changes the details color of the sprite and updates [member _details_color]
func _change_sprite_details_color(color: Color) -> void:
	mode_sprite.change_details_color(color)
	_details_color = color

func _on_body_color_change(color: Color) -> void:
	_change_sprite_body_color(color)

func _on_details_color_change(color: Color) -> void:
	_change_sprite_details_color(color)

## Stores the current mode colors in the global [PlayerColorScheme]
## so they can be accessed by other classes such as [Player]
func _on_send_custom_color() -> void:
	PlayerColorScheme.define_skin_color(
		mode, 
		PlayerColorData.new(_body_color, _details_color)
	)
