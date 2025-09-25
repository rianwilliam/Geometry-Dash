extends Node2D

## Who's Recieve
## [LevelStructure]
signal player_died()
signal player_pos(pos: Vector2)
signal player_use_orb()
signal send_player_mode(mode: Enums.PLAYER_MODE)
signal set_player_collision_shape(new_collision: CollisionShape2D)
signal player_is_in_action(action: bool) # who's recieve: Mode Base
signal player_in_floor(on_floor: bool)
signal player_in_ceiling(on_ceiling: bool)
signal player_gravity_dir(direction: Enums.GRAVITY_DIR)
