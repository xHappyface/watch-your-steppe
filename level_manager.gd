extends Node

@onready var footman_scene: PackedScene = preload("res://scenes/footman.tscn")
@onready var crossbowman_scene: PackedScene = preload("res://scenes/crossbowman.tscn")

var level: Node3D = null
