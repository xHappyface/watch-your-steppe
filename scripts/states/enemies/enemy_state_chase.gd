extends State
class_name EnemyStateChase

func update(enemy: Node, delta: float) -> void:
	if enemy is Enemy:
		EnemyUtil.move_enemy_unit(enemy)
