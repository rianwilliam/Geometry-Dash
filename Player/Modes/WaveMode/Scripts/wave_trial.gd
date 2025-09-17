extends Line2D
class_name WaveTrial

#var is_off_screen: bool = false
#
#func _process(delta: float) -> void:
	#if not is_off_screen: return
	#if get_point_count():
		#remove_point(0)
	#else:
		#queue_free()
#
#func _on_visible_on_screen_screen_exited() -> void:
	#is_off_screen = true
