extends CharacterBody3D
class_name Enemy

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var state_manager: StateManager = $StateManager

var speed: float = 3.0

var modifiers: Dictionary[StringName, bool] = {}
# Dictionary[StringName, Array[StringName]]
var _modifier_conflicts: Dictionary[StringName, Array] = {
	}

func _set_state(next_state: State) -> void:
	state_manager.current_state.exit(self)
	state_manager.current_state = next_state
	next_state.enter(self)

func _physics_process(delta: float) -> void:
	state_manager.current_state.update(self, delta)
