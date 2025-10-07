extends Node

var skin_colors: Dictionary[Enums.PLAYER_MODE, PlayerColorData]
var _default_color_data = PlayerColorData.new(Color.WHITE, Color.BLACK)

func define_skin_color(mode: Enums.PLAYER_MODE, color_data: PlayerColorData) -> void:
	skin_colors[mode] = color_data

func get_mode_custom_color(mode: Enums.PLAYER_MODE) -> PlayerColorData:
	if not skin_colors.get(mode): return _default_color_data
	return skin_colors.get(mode)
