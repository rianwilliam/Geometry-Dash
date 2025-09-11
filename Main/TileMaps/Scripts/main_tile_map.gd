extends TileMapLayer
class_name MainTileMap

var _default_color: Color

func _ready() -> void:
	_default_color = modulate.to_html()

func reset_color() -> void:
	modulate = _default_color
