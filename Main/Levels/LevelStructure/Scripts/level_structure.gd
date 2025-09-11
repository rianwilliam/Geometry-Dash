extends TileMapLayer
class_name LevelStructure

var tile_map_controllers: Array[TileMapController]

func _ready() -> void:
	Events.connect("player_died", _on_player_die)
	tile_map_controllers = _get_tile_map_controllers()

func _get_tile_map_controllers() -> Array[TileMapController]:
	var tile_map_list: Array[TileMapController]
	for node in get_children():
		if node is TileMapController: tile_map_list.append(node)
	return tile_map_list

func _reset_tile_maps_colors() -> void:
	for tile_map: TileMapController in tile_map_controllers:
		tile_map.reset_default_color()

func _on_player_die() -> void:
	_reset_tile_maps_colors()
