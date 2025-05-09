extends Node3D
class_name Portal

@onready var spawned: Node3D = $Spawned
@onready var anim_player: AnimationPlayer = $AnimationPlayer

func spawn(enemy_type: EnemyUtil.EnemyType) -> void:
	var enemy: RigidBody3D = null
	match enemy_type:
		EnemyUtil.EnemyType.CROSSBOWMAN:
			enemy = LevelManager.crossbowman_scene.instantiate()
		EnemyUtil.EnemyType.GOBLIN:
			enemy = LevelManager.goblin_scene.instantiate()
		_:
			enemy = LevelManager.footman_scene.instantiate()
	enemy.position = Vector3(0.0, 0.05, 0.0)
	enemy.set_physics_process(false)
	spawned.add_child(enemy)
	anim_player.play(&"spawn")
	var tween: Tween = create_tween()
	tween.tween_callback(enemy.reparent.bind(LevelManager.level.nav_region)).set_delay(1.0)
	tween.tween_callback(enemy.nav_agent.set_navigation_map.bind(LevelManager.level.nav_region.get_navigation_map()))
	tween.tween_callback(enemy.set_physics_process.bind(true))
