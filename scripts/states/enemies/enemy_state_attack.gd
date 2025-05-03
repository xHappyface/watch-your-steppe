extends State
class_name EnemyStateAttack

func update(enemy: Node, delta: float) -> void:
	if enemy is Enemy:
		EnemyUtil.enemy_unit_lock_on_target(enemy)
