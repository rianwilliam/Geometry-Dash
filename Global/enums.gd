extends Node2D

## Contains all enums used in the project
##
##

## Contains all possible modes the player can be in
enum PLAYER_MODE {
	SQUARE,
	WAVE,
	BALL,
	UFO,
	ROBOT,
	SPACESHIP,
}

## Contains the directions that [member scale.x] or [member scale.y] can take
enum SCALE_DIR {
	NORMAL = 1,
	INVERTED = -1
}

## Contains the value that determines the direction in which the player moves
enum PLAYER_DIRECTION {
	RIGHT = 1,
	LEFT = -1
}

## Determines how gravity will be changed
enum GRAVITY_DIR {
	FLIP = 0, ## Inverts the current gravity
	NORMAL = 1,
	INVERTED = -1
}

## Determines the levels of gravity strength that affect the player
enum GRAVITY_FORCE {
	NORMAL = 1,
	STRONG = 3
}

## Indicates the position in which [WaveMode] is moving
enum WAVE_DIR {
	UP = -1,
	DOWN = 1
}

## Indicates the jump levels of the player in ascending order
enum JUMPS {
	SMALL,
	MEDIUM,
	MEDIUM_HIGH,
	HIGH,
}

## Determines the type of modifier, this enum is used in [Orb] or [Pad]
enum MODIFIERS {
	JUMP = 1,
	GRAVITY = 2,
	G_FORCE = 3,
}

## Loads the types of scenes that can be loaded
enum SCENES {
	MAIN_MENU,
	LEVEL_MENU,
}
