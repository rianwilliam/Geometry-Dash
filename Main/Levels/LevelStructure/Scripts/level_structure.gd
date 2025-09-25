extends TileMapLayer
class_name LevelStructure

## Contains all the elements that make up a level, which are:
## [italic]ground, spikes, platforms, color changes holder, sloped blocks, and misc

func _ready() -> void:
	Events.connect("player_died", _on_player_die)

## Realiza uma interacão pelos elementos e obtém somente aqueles que são [TileMapController]
func _get_tile_map_controllers() -> Array[TileMapController]:
	var tile_map_list: Array[TileMapController]
	for node in get_children():
		if node is TileMapController: tile_map_list.append(node)
	return tile_map_list

## Itera sobre cada [TileMapController] e executa [method TileMapController.reset_default_color] para 
## alterar a propriedade [member TileMapController.modulate] para o valor padrão
func _reset_tile_maps_colors() -> void:
	for tile_map: TileMapController in _get_tile_map_controllers():
		tile_map.reset_default_color()

func _on_player_die() -> void:
	_reset_tile_maps_colors()
