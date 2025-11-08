extends Area2D
class_name PlayerMusicTrigger

@export var music: AudioStreamPlayer

var _is_player_alive: bool = true ## Carries the player's state

func _ready() -> void:
	Events.connect("player_died", _on_player_died)
	Events.connect("player_respawn", _on_player_respawn)
	connect("body_entered", _on_body_entered)

## Here we check if the player is alive; if not, the verification stops
## to avoid invalid checks while the player is respawning
func _process(_delta: float) -> void:
	if _is_player_alive:
		monitoring = true
	else:
		monitoring = false

func _on_body_entered(body: Node2D) -> void:
	if not body is Player: return
	music.play()

func _on_player_died() -> void:
	_is_player_alive = false

func _on_player_respawn() -> void:
	_is_player_alive = true
