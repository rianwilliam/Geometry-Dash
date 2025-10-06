extends TileMapLayer
class_name MainTileMap

## This node contains the main atlas used for building the levels
##
## The color-changing method is not present because the [LevelColorChanger]
## directly modifies the [member modulate] property

## Retrieves the initial color of [member MainTileMap.modulate]
var _default_color: Color

func _ready() -> void:
	_default_color = modulate.to_html()

func reset_color() -> void:
	modulate = _default_color
