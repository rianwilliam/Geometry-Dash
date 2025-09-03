extends PlayerModifier
class_name Orb

@onready var orb_layers: OrbLayers = $OrbLayers

func _ready() -> void:
	Events.connect("player_use_orb", _on_player_use_orb)
	
func _on_player_use_orb() -> void:
	if player_in_area: orb_layers.play_animations()
