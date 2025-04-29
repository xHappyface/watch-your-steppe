extends Node
class_name Game

@onready var level_scene: PackedScene = preload("res://scenes/level_0.tscn")

@onready var game_viewport: SubViewport = $GameView/GameViewport

func _ready() -> void:
	var level: Node3D = level_scene.instantiate()
	game_viewport.add_child(level)
	LevelManager.level = level
