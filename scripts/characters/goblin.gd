extends RigidBody3D
class_name Goblin

@onready var bomb_scene: PackedScene = preload("res://scenes/objects/bomb.tscn")

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var reach: Area3D = $Reach
@onready var state_manager: StateManager = $StateManager

@export var speed: float = 4.5
@export var hit_points: int = 1

var modifiers: Dictionary[StringName, bool] = {}
# Dictionary[StringName, Array[StringName]]
var _modifier_conflicts: Dictionary[StringName, Array] = {}

func _set_state(next_state: State) -> void:
	state_manager.current_state.exit(self)
	state_manager.current_state = next_state
	next_state.enter(self)

func _set_modifier(modifier: StringName, state: bool) -> void:
	if state:
		var modifier_conflicts: Array = []
		if _modifier_conflicts.has(modifier):
			modifier_conflicts = _modifier_conflicts.get(modifier)
		for conflict in modifier_conflicts:
			modifiers.erase(conflict)
		modifiers.set(modifier, true)
	else:
		modifiers.erase(modifier)

func _physics_process(delta: float) -> void:
	state_manager.current_state.update(self, delta)

func is_player_in_reach() -> bool:
	var bodies: Array[Node3D] = reach.get_overlapping_bodies()
	for body in bodies:
		if body is Player:
			return true
	return false

func _on_reach_body_entered(body: Node3D) -> void:
	if body is Player:
		_set_modifier(&"kamikaze", true)

func _on_reach_body_exited(body: Node3D) -> void:
	if body is Player:
		_set_modifier(&"kamikaze", false)

func activate_bomb() -> void:
	var bomb: Bomb = bomb_scene.instantiate()
	add_child(bomb)
	bomb.position = Vector3(0.0, 1.6, 0.0)
