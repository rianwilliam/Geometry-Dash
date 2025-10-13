extends Node
class_name TileMapController

## Responsible for resetting the color of a [MainTileMap]
##
##
@export var tile_map_to_reset: MainTileMap

func reset_default_color() -> void:
	tile_map_to_reset.reset_color()
