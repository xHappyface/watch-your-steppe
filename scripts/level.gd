extends Node3D
class_name Level

@onready var player: Player = $Ground/NavigationRegion3D/Player
@onready var nav_region: NavigationRegion3D = $Ground/NavigationRegion3D
@onready var portals: Node = $Portals
