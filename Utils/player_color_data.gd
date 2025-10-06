extends Node
class_name PlayerColorData

var _body_color: Color = Color.WHITE
var _details_color: Color = Color.BLACK

func _init(body_c: Color, details_c: Color) -> void:
	_body_color = body_c
	_details_color = details_c

func get_body_color() -> Color:
	return _body_color

func get_details_color() -> Color:
	return _details_color
