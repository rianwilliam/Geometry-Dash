extends Line2D
class_name WaveTrial

var is_off_screen: bool = false

func _ready() -> void:
	Events.connect("add_wave_line_point", _on_add_wave_line_point)

func _process(delta: float) -> void:
	if not is_off_screen: return
	if get_point_count():
		remove_point(0)
	else:
		queue_free()

func _on_visible_on_screen_screen_exited() -> void:
	is_off_screen = true

func _on_add_wave_line_point(pos: Vector2) -> void:
	add_point(pos)
