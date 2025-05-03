extends Path3D
class_name ArrowShot

func _on_timer_timeout() -> void:
	queue_free()

func _on_static_body_3d_body_entered(body: Node3D) -> void:
	if body is Enemy:
		EnemyUtil.damage_enemy(body, 1)
