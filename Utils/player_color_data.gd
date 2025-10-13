extends Node
class_name PlayerColorData

## Stores the body and detail colors of the player
##
## 
var _body_color: Color = Color.WHITE ## Default body color
var _details_color: Color = Color.BLACK ## Default details color

## Retrieves the custom colors when instantiated
func _init(body_c: Color, details_c: Color) -> void:
	_body_color = body_c
	_details_color = details_c

## Returns [member _body_color]
func get_body_color() -> Color:
	return _body_color

## Returns [member _details_color]
func get_details_color() -> Color:
	return _details_color
