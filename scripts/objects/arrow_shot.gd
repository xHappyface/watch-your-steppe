extends Path3D
class_name ArrowShot

@onready var area: Area3D = $PathFollow3D/Area3D

var pierce: int = 1

func _on_timer_timeout() -> void:
	queue_free()

func _on_static_body_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		if not (pierce > 0):
			return
		EnemyUtil.damage_enemy(body, 1)
		pierce -= 1
		if not (pierce > 0):
			set_deferred("monitoring", false)
