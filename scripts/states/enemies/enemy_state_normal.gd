extends State
class_name EnemyStateNormal

func update(enemy: Node, delta: float) -> void:
	if enemy.is_in_group("enemy"):
		EnemyUtil.move_enemy_unit(enemy, delta)
