extends State
class_name PlayerStateNormal

func update(player: Node, delta: float) -> void:
	if player is Player:
		player.handle_charge()
		player.handle_controller_movement()
		player.handle_fire(delta)
		player.update_camera()
