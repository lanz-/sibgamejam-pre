extends Node2D

@export var platform_instances: Array[PackedScene] = []
@onready var spawn_points = [$SpawnPoint1, $SpawnPoint2, $SpawnPoint3]
var platforms = []


func respawn(ratio):
	for platform in platforms:
		platform.queue_free()
	
	platforms.clear()
	
	for point in spawn_points:
		if Global.random_manager.percent_chance(ratio):
			var platform = Global.random_manager.choice(platform_instances).instantiate()
			platform.position = point.position
			add_child(platform)
			platforms.append(platform)
