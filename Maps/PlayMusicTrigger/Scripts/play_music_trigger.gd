extends Area2D
class_name PlayerMusicTrigger

@export var music: AudioStreamPlayer

func _ready() -> void:
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not body is Player: return
	if music.playing:
		_fade_out_music()
	else:
		music.play()

func _fade_out_music() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(music, "volume_db", -80, 3)
