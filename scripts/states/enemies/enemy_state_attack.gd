extends State
class_name EnemyStateAttack

func update(enemy: Node, _delta: float) -> void:
	if enemy.is_in_group("enemy"):
		EnemyUtil.enemy_unit_lock_on_target(enemy)
