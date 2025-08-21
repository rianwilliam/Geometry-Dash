extends Node

enum PLAYER_MODE {
	SQUARE,
	WAVE,
	BALL,
	UFO,
	ROBOT,
	SPACESHIP,
}

enum GRAVITY_DIR {
	FLIP = 0,
	NORMAL = 1,
	INVERTED = -1
}

enum WAVE_DIR {
	UP = -1,
	DOWN = 1
}

enum JUMPS {
	SMALL,
	MEDIUM,
	HIGH,
}

enum MODIFIERS {
	JUMP = 1,
	GRAVITY = 2,
	DASH = 3
}
