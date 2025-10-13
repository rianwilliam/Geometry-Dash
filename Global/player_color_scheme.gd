extends Node

## Stores the colors customized by the player
##
## It keeps the [code]body[/code] and [code]details[/code] colors for each mode
## inside [PlayerColorData].

var skin_colors: Dictionary[Enums.PLAYER_MODE, PlayerColorData]
var _default_color_data = PlayerColorData.new(Color.WHITE, Color.BLACK)

## Defines the color scheme for a given [param mode] using the provided [param color_data]
func define_skin_color(mode: Enums.PLAYER_MODE, color_data: PlayerColorData) -> void:
	skin_colors[mode] = color_data

## Retrieves the [PlayerColorData] for the specified [param mode]
## Returns the default color data if no custom color is defined
func get_mode_custom_color(mode: Enums.PLAYER_MODE) -> PlayerColorData:
	if not skin_colors.get(mode):
		return _default_color_data
	return skin_colors.get(mode)
