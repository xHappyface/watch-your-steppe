extends Path3D
class_name BoltShot

@onready var area: Area3D = $PathFollow3D/Area3D

func _on_timer_timeout() -> void:
	queue_free()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		body.handle_damage(1)
