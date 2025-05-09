extends Node

@onready var footman_scene: PackedScene = preload("res://scenes/characters/footman.tscn")
@onready var crossbowman_scene: PackedScene = preload("res://scenes/characters/crossbowman.tscn")
@onready var goblin_scene: PackedScene = preload("res://scenes/characters/goblin.tscn")

var level: Node3D = null
