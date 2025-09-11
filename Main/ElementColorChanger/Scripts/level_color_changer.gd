extends Area2D
class_name LevelColorChanger

@export var tile_sets: Array[TileMapLayer]
@export var change_to_color: Color = Color(1,1,1)
@export var transition_time: float = 1

func _ready() -> void:
	assert(tile_sets, "No tile set setted")

func _on_body_entered(body: Node2D) -> void:
	if body is not Player: return
	for tile_set: TileMapLayer in tile_sets:
		var tile_tween: Tween = tile_set.create_tween()
		tile_tween.tween_property(tile_set, "modulate", change_to_color, transition_time)
