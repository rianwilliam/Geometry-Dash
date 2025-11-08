extends Area2D
class_name LevelColorChanger

## Change the [member MainTileMap.modulate] property of all [MainTileMap] inside [member tile_sets]
## based on the value of [member change_to_color]

@export var tile_sets: Array[MainTileMap]
@export var change_to_color: Color = Color(1,1,1)
@export var transition_time: float = 1
@export var change_background: bool = true

var _is_player_alive: bool = true ## Carries the player's state

func _ready() -> void:
	Events.connect("player_died", _on_player_died)
	Events.connect("player_respawn", _on_player_respawn)
	assert(tile_sets, "No tile set setted")

## Here we check if the player is alive; if not, the verification stops
## to avoid invalid checks while the player is respawning
func _process(_delta: float) -> void:
	if _is_player_alive:
		monitoring = true
	else:
		monitoring = false

## Modify the [member MainTileMap.modulate] value using [Tween] for a smoother transition
func _on_body_entered(body: Node2D) -> void:
	if body is not Player: return
	for tile_set: MainTileMap in tile_sets:
		var tile_tween: Tween = tile_set.create_tween()
		tile_tween.tween_property(tile_set, "modulate", change_to_color, transition_time)
	if change_background:
		Events.emit_signal("level_color_changed", change_to_color, transition_time)

func _on_player_died() -> void:
	_is_player_alive = false

func _on_player_respawn() -> void:
	_is_player_alive = true
