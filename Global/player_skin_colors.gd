extends Node

var skin_colors: Dictionary[Enums.PLAYER_MODE, PlayerColorData]

func define_skin_color(mode: Enums.PLAYER_MODE, color_data: PlayerColorData) -> void:
	skin_colors[mode] = color_data

func get_mode_custom_color(mode: Enums.PLAYER_MODE) -> PlayerColorData:
	assert(skin_colors.get(mode))
	return skin_colors.get(mode)
