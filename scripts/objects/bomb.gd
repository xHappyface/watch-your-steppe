extends StaticBody3D
class_name Bomb

@onready var explosion: Area3D = $Explosion

func explode() -> void:
	var bodies: Array[Node3D] = explosion.get_overlapping_bodies()
	for body in bodies:
		if body is Player:
			body.handle_damage(1)
