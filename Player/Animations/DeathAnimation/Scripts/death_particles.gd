extends GPUParticles2D

var player_pos: Vector2

func _ready() -> void:
	Events.connect("player_pos", _on_player_pos)
	emitting = true
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _process(_delta: float) -> void:
	global_position = player_pos

func _on_player_pos(pos: Vector2) -> void:
	player_pos = pos
