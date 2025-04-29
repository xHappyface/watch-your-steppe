extends Path3D
class_name ArrowShot

func _on_timer_timeout() -> void:
	queue_free()
