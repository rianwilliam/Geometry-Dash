extends PlayerModifier
class_name Orb

@onready var orb_layers: OrbLayers = $OrbLayers
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	Events.connect("player_use_orb", _on_player_use_orb)
	
func _on_player_use_orb() -> void:
	if player_in_area: 
		orb_layers.play_animations()
		collision_shape_2d.disabled = true
