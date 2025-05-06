extends RigidBody3D
class_name Crossbowman

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var reach: Area3D = $Reach
#@onready var attack: Area3D = $Attack
@onready var state_manager: StateManager = $StateManager

var speed: float = 3.5
var hit_points: int = 1

var modifiers: Dictionary[StringName, bool] = {}
# Dictionary[StringName, Array[StringName]]
var _modifier_conflicts: Dictionary[StringName, Array] = {
		&"aim": [&"attack"],
		&"attack": [&"aim"],
	}

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

func is_attack() -> bool:
	return modifiers.has(&"aim") or modifiers.has(&"attack")
