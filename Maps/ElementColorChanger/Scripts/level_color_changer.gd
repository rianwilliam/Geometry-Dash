extends Area2D
class_name LevelColorChanger

## Change the [member MainTileMap.modulate] property of all [MainTileMap] inside [member tile_sets]
## based on the value of [member change_to_color]

@export var tile_sets: Array[MainTileMap]
@export var change_to_color: Color = Color(1,1,1)
@export var transition_time: float = 1

func _ready() -> void:
	assert(tile_sets, "No tile set setted")

## Modify the [member MainTileMap.modulate] value using [Tween] for a smoother transition
func _on_body_entered(body: Node2D) -> void:
	if body is not Player: return
	for tile_set: MainTileMap in tile_sets:
		var tile_tween: Tween = tile_set.create_tween()
		tile_tween.tween_property(tile_set, "modulate", change_to_color, transition_time)
