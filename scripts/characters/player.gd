extends CharacterBody3D
class_name Player

@onready var arrow_shot_scene: PackedScene = preload("res://scenes/arrow_shot.tscn")

const BASE_SPEED: float = 4.5

@onready var camera: Camera3D = $Camera3D
@onready var state_manager: StateManager = $StateManager
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var anim_player: AnimationPlayer = $AnimationTree/AnimationPlayer

@export var speed: float = BASE_SPEED
@export var dash_cooldown: float = 0.0
var charge: float = 0.0
var fire_cooldown: float = 0.0
var hit_points: int = 1

var modifiers: Dictionary[StringName, bool] = {}
# Dictionary[StringName, Array[StringName]]
var _modifier_conflicts: Dictionary[StringName, Array] = {
		&"dash": [&"charge"],
		&"charge": [&"dash"],
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
	dash_cooldown = max(0.0, dash_cooldown - delta)
	fire_cooldown = max(0.0, fire_cooldown - delta)
	state_manager.current_state.update(self, delta)
	move_and_slide()

func is_dash() -> bool:
	for conflict in _modifier_conflicts:
		if modifiers.has(conflict):
			return false
	if Input.is_action_pressed("hold") or dash_cooldown > 0.0:
		return false
	return Input.is_action_just_pressed("dash") and \
	  anim_tree.get("parameters/move/blend_walk/blend_amount") > 0.0

func is_fire() -> bool:
	return Input.is_action_just_pressed("fire")

func update_camera() -> void:
	camera.position = position + Vector3(0.0, 8.0, 3.5)

func handle_damage(damage: int) -> void:
	hit_points = max(hit_points - damage, 0.0)

func handle_controller_movement() -> void:
	var move_dir: Vector2 = Input.get_vector(
		"move_left", "move_right",
		"move_down", "move_up", 0.1
	).normalized()
	anim_tree.set("parameters/move/blend_walk/blend_amount", move_dir.length())
	if move_dir:
		look_at(position + Vector3(move_dir.x, 0.0, -move_dir.y))
		if not Input.is_action_pressed("hold"):
			velocity = -transform.basis.z * speed
		elif not modifiers.has(&"dash"):
			velocity = Vector3.ZERO
	elif not modifiers.has(&"dash"):
		velocity = Vector3.ZERO

func handle_charge() -> void:
	if fire_cooldown:
		return
	if Input.is_action_just_pressed("fire"):
		anim_tree.set(
			"parameters/move/OneShot/request",
			AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE,
		)

func handle_fire(delta: float) -> void:
	if Input.is_action_pressed("fire"):
		charge += delta
		return
	elif not anim_tree.get("parameters/move/OneShot/active"):
		return
	anim_tree.set(
		"parameters/move/OneShot/request",
		AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT,
	)
	charge = clamp(charge, 0.0, 1.0)
	fire_cooldown = 0.2
	_set_modifier(&"charge", false)
	if modifiers.has(&"dash"):
		return
	var arrow_shot: ArrowShot = arrow_shot_scene.instantiate()
	if charge >= 1.0:
		arrow_shot.pierce = 2
	arrow_shot.curve.set("point_1/position", Vector3(0.0, 0.0, -(2.0 + (charge * 14.0))))
	charge = 0.0
	LevelManager.level.add_child(arrow_shot)
	arrow_shot.global_position = global_position
	arrow_shot.rotation = rotation
