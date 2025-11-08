extends TileMapLayer
class_name LevelTileMapStructure

## Contains all the elements that make up a level, which are:
## [i]ground, spikes, platforms, color changes holder, sloped blocks, and misc[/i]


func _ready() -> void:
	Events.connect("player_respawn", _on_player_respawn)

## Performs an interaction with the elements and returns only those that are [TileMapController]
func _get_tile_map_controllers() -> Array[TileMapController]:
	var tile_map_list: Array[TileMapController]
	for node in get_children():
		if node is TileMapController: tile_map_list.append(node)
	return tile_map_list

## Iterates over each [TileMapController] and calls [method TileMapController.reset_default_color] 
## to reset the [member TileMapController.modulate] property to its default value
func _reset_tile_maps_colors() -> void:
	for tile_map: TileMapController in _get_tile_map_controllers():
		tile_map.reset_default_color()

func _on_player_respawn() -> void:
	_reset_tile_maps_colors()
