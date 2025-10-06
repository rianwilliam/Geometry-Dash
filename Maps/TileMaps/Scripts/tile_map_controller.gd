extends Node
class_name TileMapController

@export var tile_map_to_reset: MainTileMap

func reset_default_color() -> void:
	tile_map_to_reset.reset_color()
