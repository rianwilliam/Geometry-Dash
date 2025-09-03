extends Marker2D
class_name OrbLayers

@onready var middle_layer: Marker2D = $MiddleLayer
@onready var external_layer: OrbExternalLayer = $ExternalLayer
@onready var center_layer: Marker2D = $CenterLayer

func play_animations() -> void:
	external_layer.play_pop_anim()
