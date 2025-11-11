extends Node2D

# Gameplay Signals
signal player_died() ## who's recieve: [LevelTileMapStructure]; [LevelManager]
signal player_pos(pos: Vector2) ## who's recieve:
signal player_use_orb() ## who's recieve: [Orb]
signal send_player_mode(mode: Enums.PLAYER_MODE) ## who's recieve:
signal set_player_collision_shape(new_collision: CollisionShape2D)
signal player_is_in_action(action: bool) ## who's recieve: [ModeBase]
signal player_in_floor(on_floor: bool) ## who's recieve: [ModeBase]
signal player_in_ceiling(on_ceiling: bool) ## who's recieve: [ModeBase]
signal level_color_changed(new_color: Color, transition_time: float) ## who's recieve: [LevelManager]

# Menu Signals
signal send_custom_colors() ## who's recieve: [ModeColorManager]
signal play_btn_pressed() ## who's recieve: [Player]
signal resume_btn_pressed() ## who's recieve: [LevelManager]
signal quit_btn_pressed() ## who's recieve: [LevelManager], [PauseMenu]
