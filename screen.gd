extends Node2D


@export var screen_text: String = ""

@onready var spawners = [$RowSpawner, $RowSpawner2, $RowSpawner3]


func respawn(ratio):
	for spawner in spawners:
		spawner.respawn(ratio)
