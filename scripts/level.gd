extends Node3D
class_name Level

@onready var player: Player = $Ground/NavigationRegion3D/Player
@onready var nav_region: NavigationRegion3D = $Ground/NavigationRegion3D
@onready var portals: Node = $Portals

func _on_timer_timeout() -> void:
	for portal in portals.get_children():
		if portal is Portal:
			portal.spawn(EnemyUtil.EnemyType.GOBLIN)
			portal.anim_player.play(&"spawn")
