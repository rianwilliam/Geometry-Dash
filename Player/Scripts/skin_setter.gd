extends Node
class_name SkinSetter

var player_mode: Enums.PLAYER_MODE
var player_skin_id: Enums.SKIN_IDS

func _init(mode: Enums.PLAYER_MODE, skin_id: Enums.SKIN_IDS) -> void:
	player_mode = mode
	player_skin_id = skin_id
