extends Resource
class_name EnemyUtil

enum EnemyType {
	FOOTMAN,
}

static func move_enemy_unit(enemy: RigidBody3D, delta: float) -> void:
	enemy.nav_agent.target_position = LevelManager.level.player.global_position
	var next_position = enemy.nav_agent.get_next_path_position()
	var direction = (next_position - enemy.global_position).normalized()
	direction.y = 0.0
	if not direction.is_zero_approx():
		enemy.look_at(enemy.global_position + direction)
	#enemy.velocity = direction * enemy.speed
	enemy.move_and_collide(direction * enemy.speed * delta)
	

static func enemy_unit_lock_on_target(enemy: RigidBody3D) -> void:
	enemy.nav_agent.target_position = LevelManager.level.player.global_position
	if not enemy.modifiers.has(&"attack"):
		enemy.look_at(enemy.nav_agent.target_position)

static func damage_enemy(target: RigidBody3D, damage: int) -> void:
	target.hit_points = max(target.hit_points - damage, 0.0)
